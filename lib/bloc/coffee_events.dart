// Base class for all events
abstract class CoffeeEvent {}

// Cup-related events
class CupSelectedEvent extends CoffeeEvent {
  final String cupType;
  CupSelectedEvent(this.cupType);
}

// Quantity-related events
class QuantityIncrementEvent extends CoffeeEvent {}

class QuantityDecrementEvent extends CoffeeEvent {}

// Theme-related events
class ThemeToggleEvent extends CoffeeEvent {}

// Filling animation events
class StartFillingEvent extends CoffeeEvent {}

class FillingCompletedEvent extends CoffeeEvent {}

class AddToCartEvent extends CoffeeEvent {}

class ResetAnimationEvent extends CoffeeEvent {}

// Specific animation events
class ShowLoadingOverlayEvent extends CoffeeEvent {}

class StartDropAnimationEvent extends CoffeeEvent {}

class EndDropAnimationEvent extends CoffeeEvent {}

// Event to update current PageView page
class PageChangedEvent extends CoffeeEvent {
  final double page;
  PageChangedEvent(this.page);
}
