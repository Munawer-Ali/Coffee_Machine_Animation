import 'package:coffee_animation/bloc/coffee_bloc.dart';
import 'package:coffee_animation/bloc/coffee_events.dart';
import 'package:coffee_animation/bloc/coffee_state.dart';
import 'package:coffee_animation/cup_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeBloc', () {
    late CoffeeBloc bloc;

    setUp(() {
      bloc = CoffeeBloc();
    });

    tearDown(() {
      bloc.dispose();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        expect(bloc.currentState.selectedCup, CupEnum.small);
        expect(bloc.currentState.quantity, 1);
        expect(bloc.currentState.isDarkMode, false);
        expect(bloc.currentState.isLoading, false);
        expect(bloc.currentState.showLoadingOverlay, false);
        expect(bloc.currentState.animationComplete, false);
        expect(bloc.currentState.drop, false);
        expect(bloc.currentState.dropAnimation, false);
        expect(bloc.currentState.currentPage, 0.0);
        expect(bloc.currentState.totalPrice, 30); // Small cup price
      });

      test('should provide access to state stream', () {
        // Assert
        expect(bloc.stateStream, isA<Stream<CoffeeState>>());
      });
    });

    group('Cup Selection', () {
      test('should update selected cup when CupSelectedEvent is added',
          () async {
        // Act
        bloc.add(CupSelectedEvent('Medium'));

        // Wait for state update
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.selectedCup, CupEnum.medium);
        expect(bloc.currentState.totalPrice, 35); // Medium cup price
      });

      test('should handle invalid cup type gracefully', () async {
        // Act
        bloc.add(CupSelectedEvent('Invalid'));

        // Wait for state update
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert - should default to small
        expect(bloc.currentState.selectedCup, CupEnum.small);
      });

      test('should use convenience method selectCup', () async {
        // Act
        bloc.selectCup(CupEnum.large);

        // Wait for state update
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.selectedCup, CupEnum.large);
        expect(bloc.currentState.totalPrice, 40); // Large cup price
      });

      test('should update state when cup is selected', () async {
        // Act
        bloc.selectCup(CupEnum.large);

        // Wait for state change
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.selectedCup, CupEnum.large);
      });
    });

    group('Quantity Management', () {
      test('should increment quantity when QuantityIncrementEvent is added',
          () async {
        // Act
        bloc.add(QuantityIncrementEvent());

        // Wait for state update
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.quantity, 2);
        expect(bloc.currentState.totalPrice, 60); // 2 * 30
      });

      test('should decrement quantity when QuantityDecrementEvent is added',
          () async {
        // Arrange - first increment to have quantity > 1
        bloc.add(QuantityIncrementEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Act
        bloc.add(QuantityDecrementEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.quantity, 1);
      });

      test('should not decrement quantity below 1', () async {
        // Act - try to decrement from initial quantity of 1
        bloc.add(QuantityDecrementEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.quantity, 1);
      });

      test('should use convenience methods for quantity', () async {
        // Act
        bloc.incrementQuantity();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.quantity, 2);

        // Act
        bloc.decrementQuantity();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.quantity, 1);
      });

      test('should calculate total price correctly with quantity changes',
          () async {
        // Arrange - select medium cup
        bloc.selectCup(CupEnum.medium);
        await Future.delayed(const Duration(milliseconds: 10));

        // Act - increment quantity to 3
        bloc.incrementQuantity();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.incrementQuantity();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.quantity, 3);
        expect(bloc.currentState.totalPrice, 105); // 3 * 35
      });
    });

    group('Theme Management', () {
      test('should toggle theme when ThemeToggleEvent is added', () async {
        // Act
        bloc.add(ThemeToggleEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.isDarkMode, true);

        // Act again
        bloc.add(ThemeToggleEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.isDarkMode, false);
      });

      test('should use convenience method toggleTheme', () async {
        // Act
        bloc.toggleTheme();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.isDarkMode, true);
      });
    });

    group('Animation States', () {
      test('should start filling animation when StartFillingEvent is added',
          () async {
        // Act
        bloc.add(StartFillingEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.isLoading, true);
        expect(bloc.currentState.showLoadingOverlay, false);
        expect(bloc.currentState.animationComplete, false);
      });

      test('should show loading overlay when ShowLoadingOverlayEvent is added',
          () async {
        // Act
        bloc.add(ShowLoadingOverlayEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.showLoadingOverlay, true);
      });

      test('should complete filling when FillingCompletedEvent is added',
          () async {
        // Act
        bloc.add(FillingCompletedEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.isLoading, false);
        expect(bloc.currentState.showLoadingOverlay, false);
        expect(bloc.currentState.animationComplete, true);
      });

      test('should handle drop animation events', () async {
        // Act
        bloc.add(StartDropAnimationEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.drop, true);

        // Act
        bloc.add(EndDropAnimationEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.drop, false);
        expect(bloc.currentState.dropAnimation, false);
      });

      test('should reset state when AddToCartEvent is added', () async {
        // Arrange - modify state
        bloc.selectCup(CupEnum.large);
        bloc.incrementQuantity();
        bloc.add(FillingCompletedEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Act
        bloc.add(AddToCartEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.animationComplete, false);
        expect(bloc.currentState.selectedCup, CupEnum.small);
        expect(bloc.currentState.quantity, 1);
      });
    });

    group('Page Management', () {
      test('should update current page when PageChangedEvent is added',
          () async {
        // Act
        bloc.add(PageChangedEvent(1.5));
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.currentPage, 1.5);
      });

      test('should use convenience method updatePage', () async {
        // Act
        bloc.updatePage(2.0);
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.currentPage, 2.0);
      });
    });

    group('Convenience Methods', () {
      test('should handle startFilling when animation is not complete',
          () async {
        // Act
        bloc.startFilling();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.isLoading, true);
      });

      test('should handle startFilling when animation is complete', () async {
        // Arrange - set animation as complete
        bloc.add(FillingCompletedEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        // Act
        bloc.startFilling();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert - should trigger add to cart
        expect(bloc.currentState.animationComplete, false);
        expect(bloc.currentState.selectedCup, CupEnum.small);
        expect(bloc.currentState.quantity, 1);
      });

      test('should handle addToCart convenience method', () async {
        // Arrange - modify state
        bloc.selectCup(CupEnum.medium);
        bloc.incrementQuantity();
        await Future.delayed(const Duration(milliseconds: 10));

        // Act
        bloc.addToCart();
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(bloc.currentState.selectedCup, CupEnum.small);
        expect(bloc.currentState.quantity, 1);
      });
    });

    group('Complex Scenarios', () {
      test('should handle multiple state changes correctly', () async {
        // Act - perform multiple operations
        bloc.selectCup(CupEnum.xLarge);
        bloc.incrementQuantity();
        bloc.incrementQuantity();
        bloc.toggleTheme();
        bloc.updatePage(1.0);

        // Wait for all updates
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(bloc.currentState.selectedCup, CupEnum.xLarge);
        expect(bloc.currentState.quantity, 3);
        expect(bloc.currentState.isDarkMode, true);
        expect(bloc.currentState.currentPage, 1.0);
        expect(bloc.currentState.totalPrice, 135); // 3 * 45
      });

      test('should maintain state consistency during animation flow', () async {
        // Act - simulate full animation flow
        bloc.add(StartFillingEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        expect(bloc.currentState.isLoading, true);

        bloc.add(ShowLoadingOverlayEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        expect(bloc.currentState.showLoadingOverlay, true);

        bloc.add(FillingCompletedEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        expect(bloc.currentState.animationComplete, true);
        expect(bloc.currentState.isLoading, false);

        bloc.add(AddToCartEvent());
        await Future.delayed(const Duration(milliseconds: 10));

        expect(bloc.currentState.animationComplete, false);
      });
    });

    group('Stream Behavior', () {
      test('should emit states in correct order', () async {
        // Arrange
        final states = <CoffeeState>[];
        final subscription = bloc.stateStream.listen(states.add);

        // Act
        bloc.selectCup(CupEnum.medium);
        bloc.incrementQuantity();

        // Wait for emissions
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(states.length, greaterThanOrEqualTo(2));
        expect(states.last.selectedCup, CupEnum.medium);
        expect(states.last.quantity, 2);

        // Cleanup
        await subscription.cancel();
      });

      test('should not emit duplicate states', () async {
        // Arrange
        final states = <CoffeeState>[];
        final subscription = bloc.stateStream.listen(states.add);

        // Act - add same event multiple times
        bloc.selectCup(CupEnum.medium);
        bloc.selectCup(CupEnum.medium);
        bloc.selectCup(CupEnum.medium);

        // Wait for emissions
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert - should only emit once for actual state change
        final mediumStates =
            states.where((s) => s.selectedCup == CupEnum.medium);
        expect(mediumStates.length, 1);

        // Cleanup
        await subscription.cancel();
      });
    });

    group('Error Handling', () {
      test('should handle unknown events gracefully', () async {
        // This test ensures the bloc doesn't crash with unknown events
        // Since we use if-else instead of switch, unknown events are ignored

        // Act - add a custom event (this won't match any condition)
        bloc.eventSink.add(CustomTestEvent());

        // Wait a bit
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert - state should remain unchanged
        expect(bloc.currentState.selectedCup, CupEnum.small);
        expect(bloc.currentState.quantity, 1);
      });
    });
  });
}

// Custom event for testing error handling
class CustomTestEvent extends CoffeeEvent {}
