import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../cup_enum.dart';
import '../utils/price_formatter.dart';

class CupSelectorWidget extends StatelessWidget {
  final CupEnum selectedCup;
  final ValueChanged<CupEnum> onCupSelected;
  final int quantity;

  const CupSelectorWidget({
    super.key,
    required this.selectedCup,
    required this.onCupSelected,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        _buildHeader(colorScheme),
        const SizedBox(height: AppConstants.spacing30),
        _buildCupOptions(colorScheme),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Size Options',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSize14,
              color: colorScheme.onSurface,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                PriceFormatter.formatPriceWithQuantity(
                    selectedCup.price, quantity),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.fontSize20,
                  color: colorScheme.onSurface,
                ),
              ),
              if (quantity > 1)
                Text(
                  '${PriceFormatter.formatPrice(selectedCup.price)} x $quantity',
                  style: TextStyle(
                    fontSize: AppConstants.fontSize12,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCupOptions(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing8),
      height: AppConstants.cupSelectorHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: CupEnum.values.map((cup) {
          final selected = cup == selectedCup;
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacing8),
            child: GestureDetector(
              onTap: () => onCupSelected(cup),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: AppConstants.animation300,
                    curve: Curves.easeInOut,
                    width: AppConstants.cupIconSize,
                    height: AppConstants.cupIconSize,
                    decoration: BoxDecoration(
                      color: selected
                          ? colorScheme.secondary
                          : colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(cup.padding),
                        child: Image.asset(
                          'assets/cupIcon.png',
                          color: selected
                              ? colorScheme.onSecondary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing2),
                  Text(
                    cup.label,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
