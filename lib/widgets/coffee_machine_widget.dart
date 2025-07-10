import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../cup_enum.dart';

class CoffeeMachineWidget extends StatefulWidget {
  final bool showLoadingOverlay;
  final bool drop;
  final bool dropAnimation;
  final CupEnum selectedCup;
  final double currentPage;
  final PageController controller;
  final GlobalKey cupKey;
  final Animation<double> waveAnimation;

  const CoffeeMachineWidget({
    super.key,
    required this.showLoadingOverlay,
    required this.drop,
    required this.dropAnimation,
    required this.selectedCup,
    required this.currentPage,
    required this.controller,
    required this.cupKey,
    required this.waveAnimation,
  });

  @override
  State<CoffeeMachineWidget> createState() => _CoffeeMachineWidgetState();
}

class _CoffeeMachineWidgetState extends State<CoffeeMachineWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.machineHeight,
      child: Stack(
        children: [
          Image.asset('assets/machine.png'),
          ..._buildLightIndicators(context),
          ..._buildCoffeeStreams(context),
          if (widget.drop) _buildDropAnimation(context),
          _buildCupSelector(),
        ],
      ),
    );
  }

  List<Widget> _buildLightIndicators(BuildContext context) {
    final positions = [
      {'top': AppConstants.lightTop1, 'left': AppConstants.lightLeft},
      {'top': AppConstants.lightTop2, 'left': AppConstants.lightLeft},
      {'top': AppConstants.lightTop1, 'right': AppConstants.lightRight},
      {'top': AppConstants.lightTop2, 'right': AppConstants.lightRight},
    ];
    final colorScheme = Theme.of(context).colorScheme;
    return positions.map((position) {
      return Positioned(
        top: position['top']?.toDouble(),
        left: position['left']?.toDouble(),
        right: position['right']?.toDouble(),
        child: _buildLightIndicator(colorScheme),
      );
    }).toList();
  }

  Widget _buildLightIndicator(ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: AppConstants.animation800,
      curve: Curves.easeInOut,
      height: AppConstants.lightSize,
      width: AppConstants.lightSize,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.showLoadingOverlay
                ? colorScheme.onPrimary
                : Colors.transparent,
            blurRadius: widget.showLoadingOverlay ? 3 : 1,
            offset: const Offset(0, 10),
          )
        ],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  List<Widget> _buildCoffeeStreams(BuildContext context) {
    final positions = [
      {'right': AppConstants.coffeeRight},
      {'left': AppConstants.coffeeLeft},
    ];
    final colorScheme = Theme.of(context).colorScheme;
    return positions.map((position) {
      return Positioned(
        top: AppConstants.coffeeTop,
        left: position['left']?.toDouble(),
        right: position['right']?.toDouble(),
        child: _buildCoffeeStream(colorScheme),
      );
    }).toList();
  }

  Widget _buildCoffeeStream(ColorScheme colorScheme) {
    return AnimatedOpacity(
      opacity: widget.showLoadingOverlay ? 1.0 : 0.0,
      duration: AppConstants.animation700,
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        height: widget.showLoadingOverlay ? AppConstants.coffeeHeight : 0,
        width: AppConstants.coffeeWidth,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
        ),
        duration: AppConstants.animation1000,
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget _buildDropAnimation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedPositioned(
      duration: AppConstants.animation700,
      top: widget.dropAnimation ? AppConstants.dropTop : AppConstants.coffeeTop,
      right: AppConstants.coffeeRight,
      child: AnimatedContainer(
        height: AppConstants.coffeeWidth,
        width: AppConstants.coffeeWidth,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        duration: AppConstants.animation1000,
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget _buildCupSelector() {
    return Positioned(
      top: AppConstants.lightTop2,
      left: 108,
      right: 108,
      bottom: -105,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: PageView.builder(
          itemCount: 3,
          controller: widget.controller,
          itemBuilder: (context, index) {
            double scale = 1.0;
            double diff = (widget.currentPage - index).abs();
            scale = 1 - (diff * AppConstants.scaleFactor);
            if (scale < AppConstants.minScale) scale = AppConstants.minScale;

            return AnimatedScale(
              scale: widget.selectedCup.scale,
              duration: AppConstants.animation400,
              curve: Curves.easeInOut,
              child: AnimatedContainer(
                duration: AppConstants.animation300,
                padding: EdgeInsets.all(diff * AppConstants.paddingFactor),
                curve: Curves.easeOut,
                child: Container(
                  key: widget.currentPage == index ? widget.cupKey : null,
                  child: Image.asset(
                    'assets/cup${index + 1}.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
