import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MagicalButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isPrimary;
  
  const MagicalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
  });

  @override
  State<MagicalButton> createState() => _MagicalButtonState();
}

class _MagicalButtonState extends State<MagicalButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.isPrimary ? [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(_glowAnimation.value * 0.5),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ] : [],
          ),
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isPrimary ? AppTheme.primaryColor : Colors.transparent,
              foregroundColor: widget.isPrimary ? Colors.white : AppTheme.primaryColor,
              elevation: widget.isPrimary ? 0 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: widget.isPrimary ? BorderSide.none : BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.text,
                    style: AppTheme.buttonTextStyle.copyWith(
                      color: widget.isPrimary ? Colors.white : AppTheme.primaryColor,
                    ),
                  ),
          ),
        );
      },
    );
  }
}