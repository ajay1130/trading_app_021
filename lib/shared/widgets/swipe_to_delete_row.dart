import 'package:trading_app_021/util/exports.dart';

/// Swipe-to-delete row that does not compete with vertical list scrolling.
///
/// [Dismissible] registers a horizontal drag recognizer that fights the list
/// scroll on diagonal pans. This widget listens to raw pointer events and only
/// tracks horizontal movement after the drag axis is clearly horizontal.
class SwipeToDeleteRow extends StatefulWidget {
  final Widget child;
  final Widget background;
  final VoidCallback onDismissed;

  /// Fraction of row width that must be revealed before [onDismissed] runs.
  final double dismissThreshold;

  const SwipeToDeleteRow({
    super.key,
    required this.child,
    required this.background,
    required this.onDismissed,
    this.dismissThreshold = 0.65,
  });

  @override
  State<SwipeToDeleteRow> createState() => _SwipeToDeleteRowState();
}

class _SwipeToDeleteRowState extends State<SwipeToDeleteRow>
    with SingleTickerProviderStateMixin {
  static const double _touchSlop = 18;

  double _dragOffset = 0;
  Offset? _pointerStart;
  bool? _horizontalDrag;
  late AnimationController _snapController;
  Animation<double>? _snapAnimation;
  double _rowWidth = 0;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        final animation = _snapAnimation;
        if (animation != null) {
          setState(() => _dragOffset = animation.value);
        }
      });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _animateOffsetTo(double target) {
    _snapAnimation = Tween<double>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic),
    );
    _snapController.forward(from: 0);
  }

  void _resetPointerState() {
    _pointerStart = null;
    _horizontalDrag = null;
  }

  void _onPointerDown(PointerDownEvent event) {
    _snapController.stop();
    _pointerStart = event.localPosition;
    _horizontalDrag = null;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final start = _pointerStart;
    if (start == null) return;

    if (_horizontalDrag == null) {
      final total = event.localPosition - start;
      if (total.distance < _touchSlop) return;
      _horizontalDrag = total.dx.abs() > total.dy.abs();
    }

    if (_horizontalDrag != true) return;

    setState(() {
      final next = _dragOffset + event.delta.dx;
      _dragOffset = next.clamp(-_rowWidth, 0.0);
    });
  }

  void _onPointerEnd() {
    if (_horizontalDrag == true) {
      if (_rowWidth > 0 &&
          -_dragOffset >= _rowWidth * widget.dismissThreshold) {
        widget.onDismissed();
      } else if (_dragOffset != 0) {
        _animateOffsetTo(0);
      }
    }
    _resetPointerState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _rowWidth = constraints.maxWidth;
        return Listener(
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: (_) => _onPointerEnd(),
          onPointerCancel: (_) => _onPointerEnd(),
          behavior: HitTestBehavior.translucent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: widget.background),
              Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}
