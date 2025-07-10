import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../constants/app_constants.dart';

class ActionButtonWidget extends StatelessWidget {
  final bool isLoading;
  final bool showLoadingOverlay;
  final bool animationComplete;
  final Animation<double> waveAnimation;
  final VoidCallback onTapToFill;
  final VoidCallback onAddToCart;

  const ActionButtonWidget({
    super.key,
    required this.isLoading,
    required this.showLoadingOverlay,
    required this.animationComplete,
    required this.waveAnimation,
    required this.onTapToFill,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: isLoading ? null : onTapToFill,
        child: AnimatedContainer(
          duration: AppConstants.animation300,
          curve: Curves.easeInOut,
          height: AppConstants.buttonHeight,
          decoration: BoxDecoration(
            color: isLoading ? colorScheme.surface : colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          child: _buildButtonContent(context, colorScheme),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, ColorScheme colorScheme) {
    if (showLoadingOverlay) {
      return _buildLoadingContent(colorScheme);
    } else {
      return _buildNormalContent(colorScheme);
    }
  }

  Widget _buildLoadingContent(ColorScheme colorScheme) {
    return AnimatedOpacity(
      opacity: showLoadingOverlay ? 1.0 : 0.0,
      duration: AppConstants.animation400,
      curve: Curves.easeInOut,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            child: AnimatedBuilder(
              animation: waveAnimation,
              builder: (context, child) {
                return RotatedBox(
                  quarterTurns: -1,
                  child: WaveWidget(
                    duration: AppConstants.waveWidgetDurationMs,
                    config: CustomConfig(
                      colors: [colorScheme.onPrimary],
                      durations: [AppConstants.waveWidgetDurationMs],
                      heightPercentages: [waveAnimation.value],
                    ),
                    size: const Size(double.infinity, double.infinity),
                    waveAmplitude: AppConstants.waveAmplitude,
                    waveFrequency: AppConstants.waveFrequency,
                    wavePhase: AppConstants.wavePhase,
                    backgroundColor: colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          Center(
            child: Text(
              'Tap to fill',
              style: TextStyle(
                fontSize: AppConstants.fontSize14,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSecondary,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNormalContent(ColorScheme colorScheme) {
    return Center(
      child: GestureDetector(
        onTap: animationComplete ? onAddToCart : null,
        child: Text(
          animationComplete ? "Add to cart" : 'Tap to fill',
          style: TextStyle(
            fontSize: AppConstants.fontSize14,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
