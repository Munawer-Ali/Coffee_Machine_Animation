import '../cup_enum.dart';

class CoffeeState {
  final CupEnum selectedCup;
  final int quantity;
  final bool isDarkMode;
  final bool isLoading;
  final bool showLoadingOverlay;
  final bool animationComplete;
  final bool drop;
  final bool dropAnimation;
  final double currentPage;

  const CoffeeState({
    this.selectedCup = CupEnum.small,
    this.quantity = 1,
    this.isDarkMode = false,
    this.isLoading = false,
    this.showLoadingOverlay = false,
    this.animationComplete = false,
    this.drop = false,
    this.dropAnimation = false,
    this.currentPage = 0.0,
  });

  // Method to create a copy with specific changes
  CoffeeState copyWith({
    CupEnum? selectedCup,
    int? quantity,
    bool? isDarkMode,
    bool? isLoading,
    bool? showLoadingOverlay,
    bool? animationComplete,
    bool? drop,
    bool? dropAnimation,
    double? currentPage,
  }) {
    return CoffeeState(
      selectedCup: selectedCup ?? this.selectedCup,
      quantity: quantity ?? this.quantity,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isLoading: isLoading ?? this.isLoading,
      showLoadingOverlay: showLoadingOverlay ?? this.showLoadingOverlay,
      animationComplete: animationComplete ?? this.animationComplete,
      drop: drop ?? this.drop,
      dropAnimation: dropAnimation ?? this.dropAnimation,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  // Method to get total price
  int get totalPrice => selectedCup.price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CoffeeState &&
        other.selectedCup == selectedCup &&
        other.quantity == quantity &&
        other.isDarkMode == isDarkMode &&
        other.isLoading == isLoading &&
        other.showLoadingOverlay == showLoadingOverlay &&
        other.animationComplete == animationComplete &&
        other.drop == drop &&
        other.dropAnimation == dropAnimation &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode {
    return Object.hash(
      selectedCup,
      quantity,
      isDarkMode,
      isLoading,
      showLoadingOverlay,
      animationComplete,
      drop,
      dropAnimation,
      currentPage,
    );
  }
}
