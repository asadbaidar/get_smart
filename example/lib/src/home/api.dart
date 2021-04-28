import 'dart:async';
import 'dart:isolate';

import 'package:example/src/home/model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_smart/get_smart.dart';

class Api {
  Future<GetResult<Alphabet>> getAlphabets() {
    return compute(parseData, Alphabet());
  }
}

class GetIsolate {
  Isolate _isolate;
  SendPort sendPort;
  ReceivePort receivePort;
  Map<String, Completer> completer = {};

  Future<GetResult<T>> parseJson<T extends Mappable>({String key, T as}) async {
    final _completer = completer[key] = Completer<GetResult<T>>();
    sendPort.send(IsolateParcel(key: key, mappable: as));
    final result = await _completer.future;
    completer.remove(key);
    return result;
  }

  Future<void> init() async {
    Completer _completer = Completer<SendPort>();
    receivePort = ReceivePort();

    receivePort.listen((data) {
      if (data is SendPort) {
        print('[init] $data');
        SendPort mainToIsolatePort = data;
        _completer.complete(mainToIsolatePort);
      } else if (data is IsolateParcel) {
        print('[isolateToMainPort] $data');
        completer[data.key].complete(data.result);
      }
    });

    _isolate = await Isolate.spawn(isolateEntry, receivePort.sendPort);
    sendPort = await _completer.future;
  }

  static void isolateEntry(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((data) {
      print('[receivePort] $data');
      if (data is IsolateParcel) {
        final result =
            parseData(data.mappable /*, data.key == "1" ? data1 : data2*/);
        sendPort.send(data..result = result);
      }
    });
  }

  void kill() {
    receivePort?.close();
    _isolate?.kill();
  }
}

class IsolateParcel {
  IsolateParcel({this.key, this.mappable});

  final String key;
  final Mappable mappable;
  var result;

  @override
  String toString() {
    return key + "\n" + mappable.toString() + "\n" + (result?.toString() ?? "");
  }
}

GetResult<T> parseData<T extends Mappable>(T as) {
  return GetResult<T>.success()
    ..list = data1.map((Object e) => e.getObject<T>(as: as)).toList();
}

const data1 = [
  {
    "id": "A",
    "description": "Apple",
  },
  {
    "id": "B",
    "description": "Ball",
  },
  {
    "id": "C",
    "description": "Cat",
  },
  {
    "id": "D",
    "description": "Doll",
  },
  {
    "id": "E",
    "description": "Elephant",
  },
];

const data2 = [
  {
    "id": "F",
    "description": "Frog",
  },
  {
    "id": "G",
    "description": "Glass",
  },
  {
    "id": "H",
    "description": "Horse",
  },
  {
    "id": "I",
    "description": "Ink",
  },
  {
    "id": "J",
    "description": "Jug",
  },
];
