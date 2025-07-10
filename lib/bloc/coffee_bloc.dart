import 'dart:async';

import '../constants/app_constants.dart';
import '../cup_enum.dart';
import 'coffee_events.dart';
import 'coffee_state.dart';

class CoffeeBloc {
  // Stream controllers for BLoC pattern
  final _eventController = StreamController<CoffeeEvent>();
  final _stateController = StreamController<CoffeeState>.broadcast();

  // Current state
  CoffeeState _currentState = const CoffeeState();

  // Public getters
  Stream<CoffeeState> get stateStream => _stateController.stream;
  CoffeeState get currentState => _currentState;
  Sink<CoffeeEvent> get eventSink => _eventController.sink;

  CoffeeBloc() {
    // Listen to events and process them
    _eventController.stream.listen(_mapEventToState);

    // Emit initial state
    _stateController.add(_currentState);
  }

  // Method to add events
  void add(CoffeeEvent event) {
    eventSink.add(event);
  }

  // Map events to states
  void _mapEventToState(CoffeeEvent event) {
    CoffeeState newState = _currentState;

    if (event is CupSelectedEvent) {
      final selectedCup = CupEnum.values.firstWhere(
        (cup) => cup.label.toLowerCase() == event.cupType.toLowerCase(),
        orElse: () => CupEnum.small,
      );
      newState = _currentState.copyWith(selectedCup: selectedCup);
    } else if (event is QuantityIncrementEvent) {
      newState = _currentState.copyWith(quantity: _currentState.quantity + 1);
    } else if (event is QuantityDecrementEvent) {
      if (_currentState.quantity > 1) {
        newState = _currentState.copyWith(quantity: _currentState.quantity - 1);
      }
    } else if (event is ThemeToggleEvent) {
      newState = _currentState.copyWith(isDarkMode: !_currentState.isDarkMode);
    } else if (event is StartFillingEvent) {
      newState = _currentState.copyWith(
        isLoading: true,
        showLoadingOverlay: false,
        animationComplete: false,
      );
      _handleFillingAnimation();
    } else if (event is ShowLoadingOverlayEvent) {
      newState = _currentState.copyWith(showLoadingOverlay: true);
    } else if (event is FillingCompletedEvent) {
      newState = _currentState.copyWith(
        isLoading: false,
        showLoadingOverlay: false,
        animationComplete: true,
      );
      _handleDropAnimation();
    } else if (event is StartDropAnimationEvent) {
      newState = _currentState.copyWith(drop: true);
      _scheduleDropAnimation();
    } else if (event is EndDropAnimationEvent) {
      newState = _currentState.copyWith(
        drop: false,
        dropAnimation: false,
      );
    } else if (event is AddToCartEvent) {
      newState = _currentState.copyWith(
        animationComplete: false,
        selectedCup: CupEnum.small,
        quantity: 1,
      );
    } else if (event is PageChangedEvent) {
      newState = _currentState.copyWith(currentPage: event.page);
    }

    if (newState != _currentState) {
      _currentState = newState;
      _stateController.add(_currentState);
    }
  }

  // Handle filling animation
  void _handleFillingAnimation() async {
    // Wait 600ms before showing overlay
    await Future.delayed(const Duration(milliseconds: 600));
    add(ShowLoadingOverlayEvent());

    // Wait for wave duration (5 seconds)
    await Future.delayed(AppConstants.waveDuration);
    add(FillingCompletedEvent());
  }

  // Handle drop animation
  void _handleDropAnimation() async {
    await Future.delayed(AppConstants.animation1200);
    add(StartDropAnimationEvent());

    await Future.delayed(AppConstants.animation1000);
    add(EndDropAnimationEvent());
  }

  // Schedule drop animation
  void _scheduleDropAnimation() async {
    await Future.delayed(const Duration(milliseconds: 10));
    final newState = _currentState.copyWith(dropAnimation: true);
    _currentState = newState;
    _stateController.add(_currentState);
  }

  // Convenience methods
  void selectCup(CupEnum cup) {
    add(CupSelectedEvent(cup.label));
  }

  void incrementQuantity() {
    add(QuantityIncrementEvent());
  }

  void decrementQuantity() {
    add(QuantityDecrementEvent());
  }

  void toggleTheme() {
    add(ThemeToggleEvent());
  }

  void startFilling() {
    if (_currentState.animationComplete) {
      add(AddToCartEvent());
    } else {
      add(StartFillingEvent());
    }
  }

  void addToCart() {
    add(AddToCartEvent());
  }

  void updatePage(double page) {
    add(PageChangedEvent(page));
  }

  // Clean up resources
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
