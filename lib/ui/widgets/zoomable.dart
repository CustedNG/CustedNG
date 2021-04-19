import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:custed2/core/utils.dart';

class ZoomableWidget extends StatefulWidget {
  ZoomableWidget({
    Key key,
    this.minScale = 0.7,
    this.maxScale = 1.4,
    this.initialScale = 1.0,
    this.initialOffset = Offset.zero,
    this.initialRotation = 0.0,
    this.enableZoom = true,
    this.panLimit = 1.0,
    this.singleFingerPan = true,
    this.multiFingersPan = true,
    this.enableRotate = false,
    this.child,
    this.onTap,
    this.zoomSteps = 0,
    this.autoCenter = false,
    this.bounceBackBoundary = true,
    this.enableFling = true,
    this.flingFactor = 1.0,
    this.onZoomChanged,
    this.resetDuration = const Duration(milliseconds: 250),
    this.resetCurve = Curves.easeInOut,
  })  : assert(minScale != null),
        assert(maxScale != null),
        assert(initialScale != null),
        assert(initialOffset != null),
        assert(initialRotation != null),
        assert(enableZoom != null),
        assert(panLimit != null),
        assert(singleFingerPan != null),
        assert(multiFingersPan != null),
        assert(enableRotate != null),
        assert(zoomSteps != null),
        assert(autoCenter != null),
        assert(bounceBackBoundary != null),
        assert(enableFling != null),
        assert(flingFactor != null);

  /// The minimum size for scaling.
  final double minScale;

  /// The maximum size for scaling.
  final double maxScale;

  /// The initial scale.
  final double initialScale;

  /// The initial offset.
  final Offset initialOffset;

  /// The initial rotation.
  final double initialRotation;

  /// Allow zooming the child widget.
  final bool enableZoom;

  /// Allow panning with one finger.
  final bool singleFingerPan;

  /// Allow panning with more than one finger.
  final bool multiFingersPan;

  /// Allow rotating the [image].
  final bool enableRotate;

  /// Create a boundary with the factor.
  final double panLimit;

  /// The child widget that is display.
  final Widget child;

  /// Tap callback for this widget.
  final VoidCallback onTap;

  /// Allow users to zoom with double tap steps by steps.
  final int zoomSteps;

  /// Center offset when zooming to minimum scale.
  final bool autoCenter;

  /// Enable the bounce-back boundary.
  final bool bounceBackBoundary;

  /// Allow fling child widget after panning.
  final bool enableFling;

  /// Greater value create greater fling distance.
  final double flingFactor;

  /// When the scale value changed, the callback will be invoked.
  final ValueChanged<double> onZoomChanged;

  /// The duration of reset animation.
  final Duration resetDuration;

  /// The curve of reset animation.
  final Curve resetCurve;

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  final GlobalKey _key = GlobalKey();

  double _zoom = 1.0;
  double _previousZoom = 1.0;
  Offset _previousPanOffset = Offset.zero;
  Offset _pan = Offset.zero;
  Offset _zoomOriginOffset = Offset.zero;
  double _rotation = 0.0;
  double _previousRotation = 0.0;

  Size _childSize = Size.zero;
  Size _containerSize = Size.zero;

  Duration _duration = const Duration(milliseconds: 100);
  Curve _curve = Curves.easeOut;

  @override
  void initState() {
    super.initState();
    _zoom = widget.initialScale;
    _pan = widget.initialOffset;
    _rotation = widget.initialRotation;
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (_childSize == Size.zero) {
      final RenderBox renderbox = _key.currentContext.findRenderObject();
      _childSize = renderbox.size;
    }
    setState(() {
      _zoomOriginOffset = details.focalPoint;
      _previousPanOffset = _pan;
      _previousZoom = _zoom;
      _previousRotation = _rotation;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    Size boundarySize = _boundarySize;

    Size _marginSize = const Size(100.0, 100.0);

    _duration = const Duration(milliseconds: 50);
    _curve = Curves.easeOut;

    setState(() {
      if (widget.enableRotate) {
        _rotation = (_previousRotation + details.rotation).clamp(-pi, pi);
      }
      if (widget.enableZoom && details.scale != 1.0) {
        _zoom = (_previousZoom * details.scale)
            .clamp(widget.minScale, widget.maxScale);
        if (widget.onZoomChanged != null) widget.onZoomChanged(_zoom);
      }
    });

    if ((widget.singleFingerPan && details.scale == 1.0) ||
        (widget.multiFingersPan && details.scale != 1.0)) {
      Offset _panRealOffset = (details.focalPoint -
              _zoomOriginOffset +
              _previousPanOffset * _previousZoom) /
          _zoom;

      if (widget.panLimit == 0.0) {
        _pan = _panRealOffset;
      } else {
        Offset _baseOffset = Offset(
          _panRealOffset.dx
              .clamp(-boundarySize.width / 2, boundarySize.width / 2),
          _panRealOffset.dy
              .clamp(-boundarySize.height / 2, boundarySize.height / 2),
        );

        Offset _marginOffset = _panRealOffset - _baseOffset;
        double _widthFactor = sqrt(_marginOffset.dx.abs()) / _marginSize.width;
        double _heightFactor =
            sqrt(_marginOffset.dy.abs()) / _marginSize.height;
        _marginOffset = Offset(
          _marginOffset.dx * _widthFactor * 2,
          _marginOffset.dy * _heightFactor * 2,
        );
        _pan = _baseOffset + _marginOffset;
      }
      setState(() {});
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    Size boundarySize = _boundarySize;

    _duration = widget.resetDuration;
    _curve = widget.resetCurve;

    final Offset velocity = details.velocity.pixelsPerSecond;
    final double magnitude = velocity.distance;
    if (magnitude > 800.0 * _zoom && widget.enableFling) {
      final Offset direction = velocity / magnitude;
      final double distance = (Offset.zero & context.size).shortestSide;
      final Offset endOffset =
          _pan + direction * distance * widget.flingFactor * 0.5;
      _pan = Offset(
        endOffset.dx.clamp(-boundarySize.width / 2, boundarySize.width / 2),
        endOffset.dy.clamp(-boundarySize.height / 2, boundarySize.height / 2),
      );
    }
    Offset _clampedOffset = Offset(
      _pan.dx.clamp(-boundarySize.width / 2, boundarySize.width / 2),
      _pan.dy.clamp(-boundarySize.height / 2, boundarySize.height / 2),
    );
    if (_zoom == widget.minScale && widget.autoCenter) {
      _clampedOffset = Offset.zero;
    }
    setState(() => _pan = _clampedOffset);
  }

  Size get _boundarySize {
    Size _boundarySize = Size(
          (_containerSize.width == _childSize.width)
              ? (_containerSize.width - _childSize.width / _zoom).abs()
              : (_containerSize.width - _childSize.width * _zoom).abs() / _zoom,
          (_containerSize.height == _childSize.height)
              ? (_containerSize.height - _childSize.height / _zoom).abs()
              : (_containerSize.height - _childSize.height * _zoom).abs() /
                  _zoom,
        ) *
        widget.panLimit;

    return _boundarySize;
  }

  void _handleDoubleTap() {
    double _stepLength = 0.0;

    _duration = widget.resetDuration;
    _curve = widget.resetCurve;

    if (widget.zoomSteps > 0) {
      _stepLength = (widget.maxScale - 1.0) / widget.zoomSteps;
    }

    double _tmpZoom = _zoom + _stepLength;
    if (_tmpZoom > widget.maxScale || _stepLength == 0.0) _tmpZoom = 1.0;

    setState(() {
      _zoom = _tmpZoom;
      if (widget.onZoomChanged != null) widget.onZoomChanged(_zoom);
      _pan = Offset.zero;
      _rotation = 0.0;
      _previousZoom = _tmpZoom;
      if (_tmpZoom == 1.0) {
        _zoomOriginOffset = Offset.zero;
        _previousPanOffset = Offset.zero;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return SizedBox();

    return CustomMultiChildLayout(
      delegate: _ZoomableWidgetLayout(),
      children: <Widget>[
        LayoutId(
          id: _ZoomableWidgetLayout.painter,
          child: _ZoomableChild(
            duration: _duration,
            curve: _curve,
            zoom: _zoom,
            panOffset: _pan,
            rotation: _rotation,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                _containerSize =
                    Size(constraints.maxWidth, constraints.maxHeight);
                return Center(
                  child: Container(key: _key, child: widget.child),
                );
              },
            ),
          ),
        ),
        LayoutId(
          id: _ZoomableWidgetLayout.gestureContainer,
          child: GestureDetector(
            child: Container(color: Color(0)),
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: widget.bounceBackBoundary ? _onScaleEnd : null,
            onDoubleTap: _handleDoubleTap,
            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }
}

class _ZoomableWidgetLayout extends MultiChildLayoutDelegate {
  _ZoomableWidgetLayout();

  static final String gestureContainer = 'gesturecontainer';
  static final String painter = 'painter';

  @override
  void performLayout(Size size) {
    layoutChild(gestureContainer,
        BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(gestureContainer, Offset.zero);
    layoutChild(painter,
        BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(painter, Offset.zero);
  }

  @override
  bool shouldRelayout(_ZoomableWidgetLayout oldDelegate) => false;
}

class _ZoomableChild extends ImplicitlyAnimatedWidget {
  const _ZoomableChild({
    Duration duration,
    Curve curve = Curves.linear,
    @required this.zoom,
    @required this.panOffset,
    @required this.rotation,
    @required this.child,
  }) : super(duration: duration, curve: curve);

  final double zoom;
  final Offset panOffset;
  final double rotation;
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _ZoomableChildState();
}

class _ZoomableChildState extends AnimatedWidgetBaseState<_ZoomableChild> {
  DoubleTween _zoom;
  OffsetTween _panOffset;
  // OffsetTween _zoomOriginOffset;
  DoubleTween _rotation;

  @override
  void forEachTween(visitor) {
    _zoom = visitor(
        _zoom, widget.zoom, (dynamic value) => DoubleTween(begin: value));
    _panOffset = visitor(_panOffset, widget.panOffset,
        (dynamic value) => OffsetTween(begin: value));
    _rotation = visitor(_rotation, widget.rotation,
        (dynamic value) => DoubleTween(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      origin: Offset(-_panOffset.evaluate(animation).dx,
          -_panOffset.evaluate(animation).dy),
      transform: Matrix4.identity()
        ..translate(_panOffset.evaluate(animation).dx,
            _panOffset.evaluate(animation).dy)
        ..scale(_zoom.evaluate(animation), _zoom.evaluate(animation)),
      child: Transform.rotate(
        angle: _rotation.evaluate(animation),
        child: widget.child,
      ),
    );
  }
}


/// Calculate crc32 checksum
///
/// crc table generator:
/// ```dart
/// List<String> createCRCTable() {
///   List<String> result = List<String>(256);
///   for (int i = 0; i <= 255; i++) {
///     int rem = i;
///     for (int j = 0; j <= 7; j++) {
///       rem = (rem & 1) > 0 ? (rem >> 1) ^ 0xedb88320 : rem >> 1;
///     }
///     result[i] = '0x' + rem.toRadixString(16).padLeft(8, '0');
///   }
///   return result;
/// }
/// ```
int crc32(List<int> bytes) {
  const List<int> crcTable = [
    0x00000000,0x77073096,0xee0e612c,0x990951ba,0x076dc419,0x706af48f,
    0xe963a535,0x9e6495a3,0x0edb8832,0x79dcb8a4,0xe0d5e91e,0x97d2d988,
    0x09b64c2b,0x7eb17cbd,0xe7b82d07,0x90bf1d91,0x1db71064,0x6ab020f2,
    0xf3b97148,0x84be41de,0x1adad47d,0x6ddde4eb,0xf4d4b551,0x83d385c7,
    0x136c9856,0x646ba8c0,0xfd62f97a,0x8a65c9ec,0x14015c4f,0x63066cd9,
    0xfa0f3d63,0x8d080df5,0x3b6e20c8,0x4c69105e,0xd56041e4,0xa2677172,
    0x3c03e4d1,0x4b04d447,0xd20d85fd,0xa50ab56b,0x35b5a8fa,0x42b2986c,
    0xdbbbc9d6,0xacbcf940,0x32d86ce3,0x45df5c75,0xdcd60dcf,0xabd13d59,
    0x26d930ac,0x51de003a,0xc8d75180,0xbfd06116,0x21b4f4b5,0x56b3c423,
    0xcfba9599,0xb8bda50f,0x2802b89e,0x5f058808,0xc60cd9b2,0xb10be924,
    0x2f6f7c87,0x58684c11,0xc1611dab,0xb6662d3d,0x76dc4190,0x01db7106,
    0x98d220bc,0xefd5102a,0x71b18589,0x06b6b51f,0x9fbfe4a5,0xe8b8d433,
    0x7807c9a2,0x0f00f934,0x9609a88e,0xe10e9818,0x7f6a0dbb,0x086d3d2d,
    0x91646c97,0xe6635c01,0x6b6b51f4,0x1c6c6162,0x856530d8,0xf262004e,
    0x6c0695ed,0x1b01a57b,0x8208f4c1,0xf50fc457,0x65b0d9c6,0x12b7e950,
    0x8bbeb8ea,0xfcb9887c,0x62dd1ddf,0x15da2d49,0x8cd37cf3,0xfbd44c65,
    0x4db26158,0x3ab551ce,0xa3bc0074,0xd4bb30e2,0x4adfa541,0x3dd895d7,
    0xa4d1c46d,0xd3d6f4fb,0x4369e96a,0x346ed9fc,0xad678846,0xda60b8d0,
    0x44042d73,0x33031de5,0xaa0a4c5f,0xdd0d7cc9,0x5005713c,0x270241aa,
    0xbe0b1010,0xc90c2086,0x5768b525,0x206f85b3,0xb966d409,0xce61e49f,
    0x5edef90e,0x29d9c998,0xb0d09822,0xc7d7a8b4,0x59b33d17,0x2eb40d81,
    0xb7bd5c3b,0xc0ba6cad,0xedb88320,0x9abfb3b6,0x03b6e20c,0x74b1d29a,
    0xead54739,0x9dd277af,0x04db2615,0x73dc1683,0xe3630b12,0x94643b84,
    0x0d6d6a3e,0x7a6a5aa8,0xe40ecf0b,0x9309ff9d,0x0a00ae27,0x7d079eb1,
    0xf00f9344,0x8708a3d2,0x1e01f268,0x6906c2fe,0xf762575d,0x806567cb,
    0x196c3671,0x6e6b06e7,0xfed41b76,0x89d32be0,0x10da7a5a,0x67dd4acc,
    0xf9b9df6f,0x8ebeeff9,0x17b7be43,0x60b08ed5,0xd6d6a3e8,0xa1d1937e,
    0x38d8c2c4,0x4fdff252,0xd1bb67f1,0xa6bc5767,0x3fb506dd,0x48b2364b,
    0xd80d2bda,0xaf0a1b4c,0x36034af6,0x41047a60,0xdf60efc3,0xa867df55,
    0x316e8eef,0x4669be79,0xcb61b38c,0xbc66831a,0x256fd2a0,0x5268e236,
    0xcc0c7795,0xbb0b4703,0x220216b9,0x5505262f,0xc5ba3bbe,0xb2bd0b28,
    0x2bb45a92,0x5cb36a04,0xc2d7ffa7,0xb5d0cf31,0x2cd99e8b,0x5bdeae1d,
    0x9b64c2b0,0xec63f226,0x756aa39c,0x026d930a,0x9c0906a9,0xeb0e363f,
    0x72076785,0x05005713,0x95bf4a82,0xe2b87a14,0x7bb12bae,0x0cb61b38,
    0x92d28e9b,0xe5d5be0d,0x7cdcefb7,0x0bdbdf21,0x86d3d2d4,0xf1d4e242,
    0x68ddb3f8,0x1fda836e,0x81be16cd,0xf6b9265b,0x6fb077e1,0x18b74777,
    0x88085ae6,0xff0f6a70,0x66063bca,0x11010b5c,0x8f659eff,0xf862ae69,
    0x616bffd3,0x166ccf45,0xa00ae278,0xd70dd2ee,0x4e048354,0x3903b3c2,
    0xa7672661,0xd06016f7,0x4969474d,0x3e6e77db,0xaed16a4a,0xd9d65adc,
    0x40df0b66,0x37d83bf0,0xa9bcae53,0xdebb9ec5,0x47b2cf7f,0x30b5ffe9,
    0xbdbdf21c,0xcabac28a,0x53b39330,0x24b4a3a6,0xbad03605,0xcdd70693,
    0x54de5729,0x23d967bf,0xb3667a2e,0xc4614ab8,0x5d681b02,0x2a6f2b94,
    0xb40bbe37,0xc30c8ea1,0x5a05df1b,0x2d02ef8d,
  ];

  int crc = 0xffffffff;

  for (int byte in bytes) {
    crc = crcTable[(crc ^ byte) & 0xff] ^ (crc >> 8);
  }

  return crc ^ 0xffffffff;
}

typedef Future<String> UrlResolver();
typedef void LoadingProgress(double progress, Uint8List data);

/// Get uid from hashCode.
String uid(String str) => str.hashCode.toString();

/// Fetch the image from network.
Future<Uint8List> loadFromRemote(
  String url,
  Map<String, String> header,
  int retryLimit,
  Duration retryDuration,
  double retryDurationFactor,
  Duration timeoutDuration,
  LoadingProgress loadingProgress,
  UrlResolver getRealUrl, {
  List<int> skipRetryStatusCode,
  bool printError = false,
  Client client,
}) async {
  assert(url != null);
  assert(retryLimit != null);

  if (retryLimit < 0) retryLimit = 0;
  skipRetryStatusCode ??= [];

  /// Retry mechanism.
  Future<Response> run<T>(Future f(), int retryLimit,
      Duration retryDuration, double retryDurationFactor) async {
    for (int t in List.generate(retryLimit + 1, (int t) => t + 1)) {
      try {
        Response res = await f();
        if (res != null) {
          if ([HttpStatus.ok, HttpStatus.partialContent]
                  .contains(res.statusCode) &&
              res.bodyBytes.isNotEmpty) {
            return res;
          } else {
            if (printError) {
              debugPrint(
                  'Failed to load, response status code: ${res.statusCode.toString()}.');
            }
            if (skipRetryStatusCode.contains(res.statusCode)) return null;
          }
        }
      } catch (e) {
        if (printError) debugPrint(e.toString());
      }
      await Future.delayed(retryDuration * pow(retryDurationFactor, t - 1));
    }

    if (retryLimit > 0 && printError) debugPrint('Retry failed!');
    return null;
  }

  Uint8List buffer;
  int bufferPosition = 0;
  bool acceptRangesHeader = false;

  Response _response;
  _response = await run(() async {
    String _url = url;
    if (getRealUrl != null) _url = (await getRealUrl()) ?? url;

    if (loadingProgress != null) {
      client ??= Client();
      final _req = Request('GET', Uri.parse(_url));
      if (header != null) _req.headers.addAll(header);
      if (!acceptRangesHeader && bufferPosition != 0) {
        _req.headers[HttpHeaders.rangeHeader] = 'bytes=$bufferPosition-';
      }

      final _res = await client.send(_req).timeout(timeoutDuration);
      acceptRangesHeader =
          _res.headers.containsKey(HttpHeaders.acceptRangesHeader) &&
              _res.headers[HttpHeaders.acceptRangesHeader] == 'bytes';

      if (!acceptRangesHeader && buffer != null) {
        bufferPosition = 0;
        buffer.clear();
        buffer = null;
      }

      final completer = Completer<Response>();
      double _progress;

      _res.stream.listen(
        (bytes) {
          buffer ??= Uint8List(
                (_res.contentLength != null && _res.contentLength != 0)
                    ? _res.contentLength
                    : 1048576);

          if (buffer.length < bufferPosition + bytes.length) {
            // Increase buffer size by 512kb if the received bytes don't fit into the buffer
            Uint8List oldBuffer = buffer;
            buffer = Uint8List(oldBuffer.length + 524288);
            buffer.setAll(0, oldBuffer);
          }

          // Add received bytes to the buffer
          buffer.setAll(bufferPosition, bytes);
          bufferPosition += bytes.length;

          if (_res.contentLength != null && _res.contentLength != 0) {
            final double progress = bufferPosition / _res.contentLength;
            if (_progress == null || (progress - _progress).abs() >= 0.01) {
              // Trigger loading progress callback every percent change
              loadingProgress(
                  progress, Uint8List.view(buffer.buffer, 0, bufferPosition));
              _progress = progress;
            }
          }
        },
        onDone: () {
          Uint8List resultData;
          if (buffer == null) {
            resultData = Uint8List(0);
          } else {
            resultData = (buffer.length == bufferPosition)
                ? buffer
                : Uint8List.view(buffer.buffer, 0, bufferPosition);
          }

          completer.complete(Response.bytes(
            resultData,
            _res.statusCode,
            request: _res.request,
            headers: _res.headers,
            isRedirect: _res.isRedirect,
            persistentConnection: _res.persistentConnection,
            reasonPhrase: _res.reasonPhrase,
          ));
          client.close();
        },
        cancelOnError: true,
        onError: (e, stackTrace) {
          completer.completeError(e, stackTrace);
          client.close();
        },
      );

      return completer.future;
    } else {
      return await get(_url.uri, headers: header).timeout(timeoutDuration);
    }
  }, retryLimit, retryDuration, retryDurationFactor);
  if (_response != null) return _response.bodyBytes;

  return null;
}

class DoubleTween extends Tween<double> {
  DoubleTween({double begin, double end}) : super(begin: begin, end: end);

  @override
  double lerp(double t) => (begin + (end - begin) * t);
}

class OffsetTween extends Tween<Offset> {
  OffsetTween({Offset begin, Offset end}) : super(begin: begin, end: end);

  @override
  Offset lerp(double t) => (begin + (end - begin) * t);
}