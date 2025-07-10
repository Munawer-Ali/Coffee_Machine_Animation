import 'package:coffee_animation/bloc/coffee_state.dart';
import 'package:coffee_animation/cup_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeState', () {
    group('Constructor', () {
      test('should create state with default values', () {
        // Act
        const state = CoffeeState();

        // Assert
        expect(state.selectedCup, CupEnum.small);
        expect(state.quantity, 1);
        expect(state.isDarkMode, false);
        expect(state.isLoading, false);
        expect(state.showLoadingOverlay, false);
        expect(state.animationComplete, false);
        expect(state.drop, false);
        expect(state.dropAnimation, false);
        expect(state.currentPage, 0.0);
      });

      test('should create state with custom values', () {
        // Act
        const state = CoffeeState(
          selectedCup: CupEnum.large,
          quantity: 3,
          isDarkMode: true,
          isLoading: true,
          showLoadingOverlay: true,
          animationComplete: true,
          drop: true,
          dropAnimation: true,
          currentPage: 2.5,
        );

        // Assert
        expect(state.selectedCup, CupEnum.large);
        expect(state.quantity, 3);
        expect(state.isDarkMode, true);
        expect(state.isLoading, true);
        expect(state.showLoadingOverlay, true);
        expect(state.animationComplete, true);
        expect(state.drop, true);
        expect(state.dropAnimation, true);
        expect(state.currentPage, 2.5);
      });
    });

    group('copyWith', () {
      test('should create new state with updated selectedCup', () {
        // Arrange
        const originalState = CoffeeState();

        // Act
        final newState = originalState.copyWith(selectedCup: CupEnum.medium);

        // Assert
        expect(newState.selectedCup, CupEnum.medium);
        expect(newState.quantity, originalState.quantity);
        expect(newState.isDarkMode, originalState.isDarkMode);
      });

      test('should create new state with updated quantity', () {
        // Arrange
        const originalState = CoffeeState();

        // Act
        final newState = originalState.copyWith(quantity: 5);

        // Assert
        expect(newState.quantity, 5);
        expect(newState.selectedCup, originalState.selectedCup);
        expect(newState.isDarkMode, originalState.isDarkMode);
      });

      test('should create new state with multiple updates', () {
        // Arrange
        const originalState = CoffeeState();

        // Act
        final newState = originalState.copyWith(
          selectedCup: CupEnum.large,
          quantity: 2,
          isDarkMode: true,
          isLoading: true,
        );

        // Assert
        expect(newState.selectedCup, CupEnum.large);
        expect(newState.quantity, 2);
        expect(newState.isDarkMode, true);
        expect(newState.isLoading, true);
        expect(newState.showLoadingOverlay, originalState.showLoadingOverlay);
        expect(newState.animationComplete, originalState.animationComplete);
      });

      test('should preserve original values when null is passed', () {
        // Arrange
        const originalState = CoffeeState(
          selectedCup: CupEnum.large,
          quantity: 3,
          isDarkMode: true,
        );

        // Act
        final newState = originalState.copyWith(
          selectedCup: null,
          quantity: null,
          isDarkMode: null,
        );

        // Assert
        expect(newState.selectedCup, originalState.selectedCup);
        expect(newState.quantity, originalState.quantity);
        expect(newState.isDarkMode, originalState.isDarkMode);
      });
    });

    group('totalPrice', () {
      test('should calculate correct total price for small cup', () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.small,
          quantity: 1,
        );

        // Act & Assert
        expect(state.totalPrice, 30); // 1 * 30
      });

      test('should calculate correct total price for medium cup with quantity',
          () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.medium,
          quantity: 2,
        );

        // Act & Assert
        expect(state.totalPrice, 70); // 2 * 35
      });

      test('should calculate correct total price for large cup with quantity',
          () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.large,
          quantity: 3,
        );

        // Act & Assert
        expect(state.totalPrice, 120); // 3 * 40
      });

      test('should calculate correct total price for xLarge cup with quantity',
          () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.xLarge,
          quantity: 4,
        );

        // Act & Assert
        expect(state.totalPrice, 180); // 4 * 45
      });

      test('should calculate correct total price for custom cup with quantity',
          () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.custom,
          quantity: 2,
        );

        // Act & Assert
        expect(state.totalPrice, 100); // 2 * 50
      });
    });

    group('Equality', () {
      test('should be equal when all properties match', () {
        // Arrange
        const state1 = CoffeeState(
          selectedCup: CupEnum.medium,
          quantity: 2,
          isDarkMode: true,
          isLoading: false,
          showLoadingOverlay: false,
          animationComplete: true,
          drop: false,
          dropAnimation: false,
          currentPage: 1.0,
        );

        const state2 = CoffeeState(
          selectedCup: CupEnum.medium,
          quantity: 2,
          isDarkMode: true,
          isLoading: false,
          showLoadingOverlay: false,
          animationComplete: true,
          drop: false,
          dropAnimation: false,
          currentPage: 1.0,
        );

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when selectedCup differs', () {
        // Arrange
        const state1 = CoffeeState(selectedCup: CupEnum.small);
        const state2 = CoffeeState(selectedCup: CupEnum.medium);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when quantity differs', () {
        // Arrange
        const state1 = CoffeeState(quantity: 1);
        const state2 = CoffeeState(quantity: 2);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when isDarkMode differs', () {
        // Arrange
        const state1 = CoffeeState(isDarkMode: false);
        const state2 = CoffeeState(isDarkMode: true);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when isLoading differs', () {
        // Arrange
        const state1 = CoffeeState(isLoading: false);
        const state2 = CoffeeState(isLoading: true);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when showLoadingOverlay differs', () {
        // Arrange
        const state1 = CoffeeState(showLoadingOverlay: false);
        const state2 = CoffeeState(showLoadingOverlay: true);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when animationComplete differs', () {
        // Arrange
        const state1 = CoffeeState(animationComplete: false);
        const state2 = CoffeeState(animationComplete: true);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when drop differs', () {
        // Arrange
        const state1 = CoffeeState(drop: false);
        const state2 = CoffeeState(drop: true);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when dropAnimation differs', () {
        // Arrange
        const state1 = CoffeeState(dropAnimation: false);
        const state2 = CoffeeState(dropAnimation: true);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when currentPage differs', () {
        // Arrange
        const state1 = CoffeeState(currentPage: 0.0);
        const state2 = CoffeeState(currentPage: 1.0);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should be equal to itself', () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.large,
          quantity: 3,
          isDarkMode: true,
        );

        // Act & Assert
        expect(state, equals(state));
        expect(state.hashCode, equals(state.hashCode));
      });
    });

    group('Immutability', () {
      test('should not modify original state when using copyWith', () {
        // Arrange
        const originalState = CoffeeState(
          selectedCup: CupEnum.small,
          quantity: 1,
          isDarkMode: false,
        );

        // Act
        final newState = originalState.copyWith(
          selectedCup: CupEnum.large,
          quantity: 5,
          isDarkMode: true,
        );

        // Assert - original state should remain unchanged
        expect(originalState.selectedCup, CupEnum.small);
        expect(originalState.quantity, 1);
        expect(originalState.isDarkMode, false);

        // Assert - new state should have updated values
        expect(newState.selectedCup, CupEnum.large);
        expect(newState.quantity, 5);
        expect(newState.isDarkMode, true);
      });
    });

    group('Edge Cases', () {
      test('should handle zero quantity in totalPrice calculation', () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.medium,
          quantity: 0,
        );

        // Act & Assert
        expect(state.totalPrice, 0); // 0 * 35
      });

      test('should handle negative quantity in totalPrice calculation', () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.large,
          quantity: -1,
        );

        // Act & Assert
        expect(state.totalPrice, -40); // -1 * 40
      });

      test('should handle large quantity in totalPrice calculation', () {
        // Arrange
        const state = CoffeeState(
          selectedCup: CupEnum.custom,
          quantity: 1000,
        );

        // Act & Assert
        expect(state.totalPrice, 50000); // 1000 * 50
      });

      test('should handle extreme currentPage values', () {
        // Arrange
        const state1 = CoffeeState(currentPage: double.infinity);
        const state2 = CoffeeState(currentPage: double.negativeInfinity);
        const state3 = CoffeeState(currentPage: double.nan);

        // Act & Assert
        expect(state1.currentPage, double.infinity);
        expect(state2.currentPage, double.negativeInfinity);
        expect(state3.currentPage.isNaN, true);
      });
    });
  });
}
