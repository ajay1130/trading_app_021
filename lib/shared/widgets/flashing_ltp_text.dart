import 'package:trading_app_021/util/exports.dart';

/// LTP text that briefly flashes green/red when the price changes.
class FlashingLtpText extends StatefulWidget {
  final int ltpPaise;
  final TextStyle? style;

  const FlashingLtpText({super.key, required this.ltpPaise, this.style});

  @override
  State<FlashingLtpText> createState() => _FlashingLtpTextState();
}

class _FlashingLtpTextState extends State<FlashingLtpText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  int? _previousLtp;
  Color _flashColor = AppColors.profitGreen;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: Dimens.duration700ms),
    );
    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ltpPaise = widget.ltpPaise;
    if (_previousLtp != null && _previousLtp != ltpPaise) {
      _flashColor = ltpPaise > _previousLtp!
          ? AppColors.profitGreen
          : AppColors.lossRed;
      _controller.forward(from: 0.0);
    }
    _previousLtp = ltpPaise;

    final c = context.colors;
    final baseStyle =
        widget.style ??
        TextStyle(
          color: c.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: Dimens.font15,
        );

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) {
        final color = Color.lerp(
          baseStyle.color ?? c.textPrimary,
          _flashColor,
          _opacity.value,
        )!;
        return Text(
          '₹${AppFormatters.currency.format(ltpPaise / 100.0)}',
          style: baseStyle.copyWith(color: color),
        );
      },
    );
  }
}
