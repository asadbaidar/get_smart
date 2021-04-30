import 'dart:async';
import 'dart:isolate';

import 'package:example/main.dart';
import 'package:example/src/home/model.dart';
import 'package:get_smart/get_smart.dart';

class Api {
  Future<GetResult<Alphabet>> getAlphabets() async {
    // return compute(parseData, Alphabet());
    return background.parseJson(key: "1", as: Alphabet());
  }
}

class GetIsolate {
  late Isolate _isolate;
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  Map<String?, Completer> completer = {};

  Future<GetResult<T>> parseJson<T>({String? key, T? as}) async {
    final _completer = completer[key] = Completer<GetResult<T>>();
    _sendPort.send(IsolateParcel<T>(key: key, mappable: as));
    return _completer.future.then((result) {
      print("parseJson $result");
      completer.remove(key);
      return result;
    }).catchError((e) {
      print(e);
      return GetResult<T>.error(e.toString());
    });
  }

  Future<void> init() async {
    Completer _completer = Completer<SendPort>();
    _receivePort = ReceivePort();
    _receivePort.listen((data) {
      if (data is SendPort) {
        print('[init] $data');
        SendPort mainToIsolatePort = data;
        _completer.complete(mainToIsolatePort);
      } else if (data is IsolateParcel) {
        print('[isolateToMainPort] $data');
        completer[data.key]?.complete(data.result);
      }
    });
    _isolate = await Isolate.spawn(isolateEntry, _receivePort.sendPort);
    _sendPort = await _completer.future;
  }

  static void isolateEntry(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((data) {
      print('[receivePort] $data');
      if (data is IsolateParcel) {
        final result = parseData(data.result, data.mappable);
        if (result != null) data.result = result;
        sendPort.send(data);
      }
    });
  }

  void kill() {
    _receivePort.close();
    _isolate.kill();
  }
}

class IsolateParcel<T> {
  IsolateParcel({this.key, this.mappable});

  final String? key;
  final T? mappable;
  GetResult<T> result = GetResult<T>();

  @override
  String toString() {
    return (key ?? "") +
        "\n" +
        (mappable?.toString() ?? "") +
        "\n" +
        result.toString();
  }
}

T? parseData<T>(T as, Mappable mappable) {
  return data1.getObject<T>(as: as, builders: mappable.builders);
}

const data1 = """
{
   "tag":"test",
   "msg":"Success",
   "status":true,
   "result":[
      {
         "id":"A",
         "description":"Apple"
      },
      {
         "id":"B",
         "description":"Ball"
      },
      {
         "id":"C",
         "description":"Cat"
      },
      {
         "id":"D",
         "description":"Doll"
      },
      {
         "id":"E",
         "description":"Elephant"
      }
   ]
}
""";

const data2 = """
{
   "tag":"test",
   "msg":"Success",
   "status":true,
   "result":[
      {
         "id":"F",
         "description":"Frog"
      },
      {
         "id":"G",
         "description":"Glass"
      },
      {
         "id":"H",
         "description":"Horse"
      },
      {
         "id":"I",
         "description":"Ink"
      },
      {
         "id":"J",
         "description":"Jug"
      }
   ]
}
""";
