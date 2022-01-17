import 'package:flutter_test/flutter_test.dart';
import 'package:get_smart/get_smart.dart';

class TestGetController extends BaseGetController {
  bool onErrorCalled = false;

  Future _runFuture(
      {Object? busyKey, bool fail = false, bool throwException = false}) {
    return runBusyFuture(
      _futureToRun(fail),
      key: busyKey,
      throwException: throwException,
    );
  }

  Future _runTestErrorFuture(
      {Object? key, bool fail = false, bool throwException = false}) {
    return runErrorFuture(
      _futureToRun(fail),
      key: key,
      throwException: throwException,
    );
  }

  Future _futureToRun(bool fail) async {
    await Future.delayed(50.milliseconds);
    if (fail) {
      throw Exception('Broken Future');
    }
  }

  @override
  void onError(error, key) {
    onErrorCalled = true;
  }
}

void main() {
  group('BaseGetController Tests -', () {
    group('Busy functionality -', () {
      test('When setBusy is called with true isBusy should be true', () {
        var controller = TestGetController();
        controller.setBusy(true);
        expect(controller.isBusy, true);
      });

      test(
          'When setBusyFor is called with parameter true busy for that object should be true',
          () {
        const key = "key";
        var controller = TestGetController();
        controller.setBusyFor(key, true);
        expect(controller.busyFor(key), true);
      });

      test('When setBusyFor is called with true then false, should be false',
          () {
        const key = "key";
        var controller = TestGetController();
        controller.setBusyFor(key, true);
        controller.setBusyFor(key, false);
        expect(controller.busyFor(key), false);
      });

      test('When busyFuture is run should report busy for the model', () {
        var controller = TestGetController();
        controller._runFuture();
        expect(controller.isBusy, true);
      });

      test(
          'When busyFuture is run with busyObject should report busy for the Object',
          () {
        var busyObjectKey = 'busyObjectKey';
        var controller = TestGetController();
        controller._runFuture(busyKey: busyObjectKey);
        expect(controller.busyFor(busyObjectKey), true);
      });

      test(
          'When busyFuture is run with busyObject should report NOT busy when error is thrown',
          () async {
        var busyObjectKey = 'busyObjectKey';
        var controller = TestGetController();
        await controller._runFuture(busyKey: busyObjectKey, fail: true);
        expect(controller.busyFor(busyObjectKey), false);
      });

      test(
          'When busyFuture is run with busyObject should throw exception if throwException is set to true',
          () async {
        var busyObjectKey = 'busyObjectKey';
        var controller = TestGetController();

        expect(
            () async => await controller._runFuture(
                busyKey: busyObjectKey, fail: true, throwException: true),
            throwsException);
      });

      /*test(
          'When busy future is complete should have called update twice, 1 for busy 1 for not busy',
          () async {
        var called = 0;
        var controller = TestGetController();
        controller.addListener(() {
          ++called;
        });
        await controller.runFuture(fail: true);
        expect(called, 2);
      });*/

      test('When update is called before onClose, should not throw exception',
          () async {
        var controller = TestGetController();
        await controller._runFuture();
        controller.update();
        controller.onClose();
        expect(() => controller.update(), returnsNormally);
      });

      test('When update is called after onClose, should not throw exception',
          () async {
        var controller = TestGetController();
        await controller._runFuture();
        controller.onClose();
        controller.update();
        expect(() => controller.update(), returnsNormally);
      });
    });

    group('runErrorFuture -', () {
      test('When called and error is thrown should set error', () async {
        var controller = TestGetController();
        await controller._runTestErrorFuture(fail: true);
        expect(controller.hasError, true);
      });
      test(
          'When called and error is thrown should call onErrorForFuture override',
          () async {
        var controller = TestGetController();
        await controller._runTestErrorFuture(fail: true, throwException: false);
        expect(controller.onErrorCalled, true);
      });
    });
  });
}
