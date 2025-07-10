import 'package:coffee_animation/bloc/coffee_events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeEvent', () {
    group('CupSelectedEvent', () {
      test('should create event with cup type', () {
        // Act
        final event = CupSelectedEvent('Medium');

        // Assert
        expect(event.cupType, 'Medium');
        expect(event, isA<CoffeeEvent>());
      });

      test('should create event with different cup types', () {
        // Act
        final smallEvent = CupSelectedEvent('Small');
        final largeEvent = CupSelectedEvent('Large');

        // Assert
        expect(smallEvent.cupType, 'Small');
        expect(largeEvent.cupType, 'Large');
      });

      test('should handle empty string', () {
        // Act
        final event = CupSelectedEvent('');

        // Assert
        expect(event.cupType, '');
      });

      test('should handle special characters', () {
        // Act
        final event = CupSelectedEvent('XL@rge-Cup_123');

        // Assert
        expect(event.cupType, 'XL@rge-Cup_123');
      });
    });

    group('QuantityIncrementEvent', () {
      test('should create event', () {
        // Act
        final event = QuantityIncrementEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<QuantityIncrementEvent>());
      });

      test('should be different instances', () {
        // Act
        final event1 = QuantityIncrementEvent();
        final event2 = QuantityIncrementEvent();

        // Assert
        expect(event1, isNot(same(event2)));
      });
    });

    group('QuantityDecrementEvent', () {
      test('should create event', () {
        // Act
        final event = QuantityDecrementEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<QuantityDecrementEvent>());
      });

      test('should be different instances', () {
        // Act
        final event1 = QuantityDecrementEvent();
        final event2 = QuantityDecrementEvent();

        // Assert
        expect(event1, isNot(same(event2)));
      });
    });

    group('ThemeToggleEvent', () {
      test('should create event', () {
        // Act
        final event = ThemeToggleEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<ThemeToggleEvent>());
      });

      test('should be different instances', () {
        // Act
        final event1 = ThemeToggleEvent();
        final event2 = ThemeToggleEvent();

        // Assert
        expect(event1, isNot(same(event2)));
      });
    });

    group('StartFillingEvent', () {
      test('should create event', () {
        // Act
        final event = StartFillingEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<StartFillingEvent>());
      });
    });

    group('FillingCompletedEvent', () {
      test('should create event', () {
        // Act
        final event = FillingCompletedEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<FillingCompletedEvent>());
      });
    });

    group('AddToCartEvent', () {
      test('should create event', () {
        // Act
        final event = AddToCartEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<AddToCartEvent>());
      });
    });

    group('ResetAnimationEvent', () {
      test('should create event', () {
        // Act
        final event = ResetAnimationEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<ResetAnimationEvent>());
      });
    });

    group('ShowLoadingOverlayEvent', () {
      test('should create event', () {
        // Act
        final event = ShowLoadingOverlayEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<ShowLoadingOverlayEvent>());
      });
    });

    group('StartDropAnimationEvent', () {
      test('should create event', () {
        // Act
        final event = StartDropAnimationEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<StartDropAnimationEvent>());
      });
    });

    group('EndDropAnimationEvent', () {
      test('should create event', () {
        // Act
        final event = EndDropAnimationEvent();

        // Assert
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<EndDropAnimationEvent>());
      });
    });

    group('PageChangedEvent', () {
      test('should create event with page value', () {
        // Act
        final event = PageChangedEvent(1.5);

        // Assert
        expect(event.page, 1.5);
        expect(event, isA<CoffeeEvent>());
        expect(event, isA<PageChangedEvent>());
      });

      test('should create event with different page values', () {
        // Act
        final event1 = PageChangedEvent(0.0);
        final event2 = PageChangedEvent(2.5);
        final event3 = PageChangedEvent(-1.0);

        // Assert
        expect(event1.page, 0.0);
        expect(event2.page, 2.5);
        expect(event3.page, -1.0);
      });

      test('should handle extreme double values', () {
        // Act
        final infinityEvent = PageChangedEvent(double.infinity);
        final negativeInfinityEvent = PageChangedEvent(double.negativeInfinity);
        final nanEvent = PageChangedEvent(double.nan);

        // Assert
        expect(infinityEvent.page, double.infinity);
        expect(negativeInfinityEvent.page, double.negativeInfinity);
        expect(nanEvent.page.isNaN, true);
      });

      test('should handle very large numbers', () {
        // Act
        final largeEvent = PageChangedEvent(1e100);
        final smallEvent = PageChangedEvent(1e-100);

        // Assert
        expect(largeEvent.page, 1e100);
        expect(smallEvent.page, 1e-100);
      });
    });

    group('Event Hierarchy', () {
      test('all events should extend CoffeeEvent', () {
        // Arrange
        final events = [
          CupSelectedEvent('Medium'),
          QuantityIncrementEvent(),
          QuantityDecrementEvent(),
          ThemeToggleEvent(),
          StartFillingEvent(),
          FillingCompletedEvent(),
          AddToCartEvent(),
          ResetAnimationEvent(),
          ShowLoadingOverlayEvent(),
          StartDropAnimationEvent(),
          EndDropAnimationEvent(),
          PageChangedEvent(1.0),
        ];

        // Assert
        for (final event in events) {
          expect(event, isA<CoffeeEvent>());
        }
      });

      test('events should be of correct specific types', () {
        // Arrange & Act
        final cupEvent = CupSelectedEvent('Large');
        final incrementEvent = QuantityIncrementEvent();
        final decrementEvent = QuantityDecrementEvent();
        final themeEvent = ThemeToggleEvent();
        final startFillingEvent = StartFillingEvent();
        final fillingCompletedEvent = FillingCompletedEvent();
        final addToCartEvent = AddToCartEvent();
        final resetAnimationEvent = ResetAnimationEvent();
        final showLoadingOverlayEvent = ShowLoadingOverlayEvent();
        final startDropAnimationEvent = StartDropAnimationEvent();
        final endDropAnimationEvent = EndDropAnimationEvent();
        final pageChangedEvent = PageChangedEvent(2.0);

        // Assert
        expect(cupEvent, isA<CupSelectedEvent>());
        expect(incrementEvent, isA<QuantityIncrementEvent>());
        expect(decrementEvent, isA<QuantityDecrementEvent>());
        expect(themeEvent, isA<ThemeToggleEvent>());
        expect(startFillingEvent, isA<StartFillingEvent>());
        expect(fillingCompletedEvent, isA<FillingCompletedEvent>());
        expect(addToCartEvent, isA<AddToCartEvent>());
        expect(resetAnimationEvent, isA<ResetAnimationEvent>());
        expect(showLoadingOverlayEvent, isA<ShowLoadingOverlayEvent>());
        expect(startDropAnimationEvent, isA<StartDropAnimationEvent>());
        expect(endDropAnimationEvent, isA<EndDropAnimationEvent>());
        expect(pageChangedEvent, isA<PageChangedEvent>());
      });
    });

    group('Event Categorization', () {
      test('should identify cup-related events', () {
        // Arrange
        final cupEvent = CupSelectedEvent('Large');

        // Assert
        expect(cupEvent, isA<CupSelectedEvent>());
      });

      test('should identify quantity-related events', () {
        // Arrange
        final incrementEvent = QuantityIncrementEvent();
        final decrementEvent = QuantityDecrementEvent();

        // Assert
        expect(incrementEvent, isA<QuantityIncrementEvent>());
        expect(decrementEvent, isA<QuantityDecrementEvent>());
      });

      test('should identify theme-related events', () {
        // Arrange
        final themeEvent = ThemeToggleEvent();

        // Assert
        expect(themeEvent, isA<ThemeToggleEvent>());
      });

      test('should identify animation-related events', () {
        // Arrange
        final animationEvents = [
          StartFillingEvent(),
          FillingCompletedEvent(),
          ResetAnimationEvent(),
          ShowLoadingOverlayEvent(),
          StartDropAnimationEvent(),
          EndDropAnimationEvent(),
        ];

        // Assert
        expect(animationEvents[0], isA<StartFillingEvent>());
        expect(animationEvents[1], isA<FillingCompletedEvent>());
        expect(animationEvents[2], isA<ResetAnimationEvent>());
        expect(animationEvents[3], isA<ShowLoadingOverlayEvent>());
        expect(animationEvents[4], isA<StartDropAnimationEvent>());
        expect(animationEvents[5], isA<EndDropAnimationEvent>());
      });

      test('should identify cart-related events', () {
        // Arrange
        final cartEvent = AddToCartEvent();

        // Assert
        expect(cartEvent, isA<AddToCartEvent>());
      });

      test('should identify page-related events', () {
        // Arrange
        final pageEvent = PageChangedEvent(1.0);

        // Assert
        expect(pageEvent, isA<PageChangedEvent>());
      });
    });

    group('Event Properties', () {
      test('CupSelectedEvent should store cup type correctly', () {
        // Arrange
        const cupTypes = ['Small', 'Medium', 'Large', 'XLarge', 'Custom'];

        // Act & Assert
        for (final cupType in cupTypes) {
          final event = CupSelectedEvent(cupType);
          expect(event.cupType, cupType);
        }
      });

      test('PageChangedEvent should store page value correctly', () {
        // Arrange
        const pageValues = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0];

        // Act & Assert
        for (final pageValue in pageValues) {
          final event = PageChangedEvent(pageValue);
          expect(event.page, pageValue);
        }
      });
    });

    group('Event Immutability', () {
      test('CupSelectedEvent should be immutable', () {
        // Arrange
        final event = CupSelectedEvent('Medium');

        // Assert - should not be able to modify cupType
        expect(event.cupType, 'Medium');
        // Note: Since cupType is final, it cannot be modified
      });

      test('PageChangedEvent should be immutable', () {
        // Arrange
        final event = PageChangedEvent(1.5);

        // Assert - should not be able to modify page
        expect(event.page, 1.5);
        // Note: Since page is final, it cannot be modified
      });
    });
  });
}
