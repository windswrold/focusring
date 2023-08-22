import 'package:flutter/foundation.dart';
import 'package:beering/net/api_stream/header.dart';
import '../../utils/console_logger.dart';
import '../protocols/can_cancel.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'result.dart';

typedef VMProgressCallback = void Function(int count, int total);

class VMRequestStream<T> {
  T? data;
  List<ValueChanged<T>> _onSuccesses = [];
  VMProgressCallback? onSendProgress, onReceiveProgress;
  List<void Function(VMResult)> _onErrors = [];
  List<VoidCallback> _onCancelleds = [];
  List<VoidCallback> _onFinishes = [];

  StreamSubscription? streamSubscription;
  Stream? stream;

  VMRequestStream([this.streamSubscription]);

  Future asFuture() => streamSubscription!.asFuture();
}

class VMMapRequestStream<T, S> extends VMRequestStream<T> {
  VMRequestStream<S> source;
  T Function(S) _converter;
  VMMapRequestStream(this.source, this._converter, [StreamSubscription? ss])
      : super(ss);

  void convert(S data, VMRequestStream stream) =>
      stream.data = _converter(data);
}

class VMApiStream<T> extends VMRequestStream<T> implements CanCancel {
  VMRequestStream<T> _stream;

//  Future<T> _future;
  VMResult? result;
  VMApiStream([VMRequestStream<T>? stream])
      : this._stream = stream ?? VMRequestStream<T>();
  CancelToken? dioCancelToken;

  VMApiStream? _next;

  bool isFinished = false;

  void queryCache(VMRequest re) async {
    if (re.canQueryCache == false) {
      return;
    }

    var result = await re.queryCache();
    if (result == null) {
      return;
    }
    VMResult nmResult = VMResult(VMResultType.successful, result, 200, re);
    this.stream = Stream.fromFuture(Future.value(nmResult)).asBroadcastStream();
    this.streamSubscription = this.stream?.listen((value) {
      vmPrint("cache ${re.queryKey}");
      assert(value is VMResult);
      VMResult tempResult = value;
      this.data = value;
      this.result = value;
      switch (tempResult.type) {
        case VMResultType.successful:
          for (final map in this._onSuccesses) {
            map(value);
          }
          break;
        case VMResultType.connectionError:
        case VMResultType.apiFailed:
          _dealErrorCode(this.result?.code);
          for (final map in this._onErrors) {
            map(value);
          }
          break;
        case VMResultType.cancelled:
          for (final map in this._onCancelleds) {
            map();
          }
          break;
        case VMResultType.none:

          ///do nothing
          break;
      }
      this._onFinishes.forEach((element) => element());
      if (this._next != null) {
        this._next!.result = this.result;
        this._next!._notifyNext(this.result!.type, this.data);
      }
    });
  }

  void setFuture(Future<VMResult> future) {
    this.stream = Stream.fromFuture(future).asBroadcastStream();
    this.streamSubscription = this.stream?.listen((value) {
      assert(value is VMResult);
      VMResult tempResult = value;
      this.data = value;
      this.result = value;
      switch (tempResult.type) {
        case VMResultType.successful:
          for (final map in this._onSuccesses) {
            map(value);
          }
          break;
        case VMResultType.connectionError:
        case VMResultType.apiFailed:
          _dealErrorCode(this.result?.code);
          for (final map in this._onErrors) {
            map(value);
          }
          break;
        case VMResultType.cancelled:
          for (final map in this._onCancelleds) {
            map();
          }
          break;
        case VMResultType.none:

          ///do nothing
          break;
      }
      this._onFinishes.forEach((element) => element());
      if (this._next != null) {
        this._next!.result = this.result;
        this._next!._notifyNext(this.result!.type, this.data);
      }
    });
//    s._future.then((value) {
//      vmPrint('123123');
//      next(value);
//    });
//    return this;
  }

  static void _dealErrorCode(int? code) {
    switch (code) {
      case 100010:
//        eventBus.fire(LogoutEvent('$code'));
        break;
    }
  }

  void _notifyNext(VMResultType type, dynamic sourceData) {
    switch (type) {
      case VMResultType.successful:
        if (_stream is VMMapRequestStream) {
          final ms = _stream as VMMapRequestStream;
          ms.convert(sourceData, this);
        }
        for (final map in _onSuccesses) {
          map(data!);
        }
        break;
      case VMResultType.connectionError:
      case VMResultType.apiFailed:
        for (final map in _onErrors) {
          map(result!);
        }
        break;
      case VMResultType.cancelled:
        for (final map in _onCancelleds) {
          map();
        }
        break;
      case VMResultType.none:

        ///do nothing
        break;
    }
    this._onFinishes.forEach((element) => element());
    if (_next != null) {
      _next!.result = result;
      _next!._notifyNext(result!.type, data);
    }
  }

  VMApiStream<S> convert<S>(S Function(T r) converter) {
    _next = VMApiStream<S>(VMMapRequestStream<S, T>(this, converter));
//    _next._request = this._request;
    _next!.stream = stream;
    _next!.streamSubscription = streamSubscription;
    _next!.dioCancelToken = dioCancelToken;
    return _next! as VMApiStream<S>;
  }

  VMApiStream<T> onSuccess(ValueChanged<T> block) {
    _onSuccesses.add(block);
    return this;
  }

  VMApiStream<T> onError(void Function(VMResult r) block) {
    _onErrors.add(block);
    return this;
  }

  VMApiStream<T> onCancelled(void Function() block) {
    _onCancelleds.add(block);
//    vmPrint('this.hash:${this.hashCode}');
//    vmPrint('this.stream.hash:${this.stream.hashCode}');
    return this;
  }

  VMApiStream<T> onFinish(VoidCallback block) {
    _onFinishes.add(block);
    return this;
  }

  FutureOr<void> _cancelDio({dynamic reason}) {
    if (!(dioCancelToken?.isCancelled ?? true)) {
      if (reason == null) {
        dioCancelToken?.cancel();
      } else {
        dioCancelToken?.cancel(reason);
      }
    }
  }

  FutureOr<void> cancel({dynamic reason}) => _cancelDio(reason: reason);

  bool get isCancelled => dioCancelToken?.isCancelled ?? false;
}
