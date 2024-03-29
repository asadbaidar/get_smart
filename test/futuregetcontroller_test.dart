import 'package:flutter_test/flutter_test.dart';
import 'package:get_smart/get_smart.dart';

const String numberDelayFuture = 'delayedNumber';
const String stringDelayFuture = 'delayedString';
const _numberDelayException = FormatException('getNumberAfterDelay failed');

class TestMultipleFutureGetController extends MultipleFutureGetController {
  final bool failOne;
  final int futureOneDuration;
  final int futureTwoDuration;

  TestMultipleFutureGetController(
      {this.failOne = false,
      this.futureOneDuration = 300,
      this.futureTwoDuration = 400});

  int numberToReturn = 5;

  @override
  Map<Object, FutureCallback> get futuresToRun => {
        numberDelayFuture: getNumberAfterDelay,
        stringDelayFuture: getStringAfterDelay,
      };

  Future<int> getNumberAfterDelay() async {
    if (failOne) {
      throw _numberDelayException;
    }
    await Future.delayed(Duration(milliseconds: futureOneDuration));
    return numberToReturn;
  }

  Future<String> getStringAfterDelay() async {
    await Future.delayed(Duration(milliseconds: futureTwoDuration));
    return 'String data';
  }
}

void main() {
  group('MultipleFutureGetController -', () {
    test(
        'When running multiple futures the associated key should hold the value when complete',
        () async {
      var futureGetController = TestMultipleFutureGetController();
      await futureGetController.initialise();

      expect(futureGetController.dataMap[numberDelayFuture], 5);
      expect(futureGetController.dataMap[stringDelayFuture], 'String data');
    });

    test(
        'When one of multiple futures fail only the failing one should have an error',
        () async {
      var futureGetController = TestMultipleFutureGetController(failOne: true);
      await futureGetController.initialise();

      expect(futureGetController.hasErrorFor(numberDelayFuture), true);
      expect(futureGetController.hasErrorFor(stringDelayFuture), false);
    });

    test(
        'When one of multiple futures fail the passed one should have data and failing one not',
        () async {
      var futureGetController = TestMultipleFutureGetController(failOne: true);
      await futureGetController.initialise();

      expect(futureGetController.dataMap[numberDelayFuture], null);
      expect(futureGetController.dataMap[stringDelayFuture], 'String data');
    });

    test('When multiple futures run the key should be set to indicate busy',
        () async {
      var futureGetController = TestMultipleFutureGetController();
      futureGetController.initialise();

      expect(futureGetController.isBusy, true);
    });

    test(
        'When multiple futures are complete the key should be set to indicate NOT busy',
        () async {
      var futureGetController = TestMultipleFutureGetController();
      await futureGetController.initialise();

      expect(futureGetController.busyFor(numberDelayFuture), false);
      expect(futureGetController.busyFor(stringDelayFuture), false);
    });

    test('When a future fails busy should be set to false', () async {
      var futureGetController = TestMultipleFutureGetController(failOne: true);
      await futureGetController.initialise();

      expect(futureGetController.busyFor(numberDelayFuture), false);
      expect(futureGetController.busyFor(stringDelayFuture), false);
    });

    test('When a future fails should set error for future key', () async {
      var futureGetController = TestMultipleFutureGetController(failOne: true);
      await futureGetController.initialise();

      expect(futureGetController.errorFor(numberDelayFuture),
          _numberDelayException.toString());

      expect(futureGetController.errorFor(stringDelayFuture), null);
    });

    test(
        'When 1 future is still running out of two anyObjectsBusy should return true',
        () async {
      var futureGetController = TestMultipleFutureGetController(
          futureOneDuration: 10, futureTwoDuration: 60);
      futureGetController.initialise();
      await Future.delayed(30.milliseconds);

      expect(futureGetController.busyFor(numberDelayFuture), false,
          reason: 'String future should be done at this point');
      expect(futureGetController.isAnyBusy, true,
          reason: 'Should be true because second future is still running');
    });

    group('Dynamic Source Tests', () {
      test('notifySourceChanged - When called should re-run Future', () async {
        var futureGetController = TestMultipleFutureGetController();
        await futureGetController.initialise();
        expect(futureGetController.dataMap[numberDelayFuture], 5);
        futureGetController.numberToReturn = 10;
        futureGetController.notifySourceChanged();
        await futureGetController.initialise();
        expect(futureGetController.dataMap[numberDelayFuture], 10);
      });
    });
  });
}
