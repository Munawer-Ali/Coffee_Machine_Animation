# ☕ Coffee Machine Animation

A sophisticated Flutter application showcasing a coffee ordering system with smooth animations, custom BLoC state management, and modern UI/UX design patterns.

![Animation](https://github.com/user-attachments/assets/0d32d59c-5a40-41a4-a4ac-623a30667ba6)

## 🎯 Overview

This project demonstrates a complete coffee ordering experience with:
- **Custom BLoC Architecture** (no external packages)
- **Smooth Animations** with wave effects and cart interactions
- **Dynamic Pricing System** based on cup size and quantity
- **Dark/Light Theme Support** with seamless switching
- **Responsive Design** across all platforms
- **Clean Architecture** with separation of concerns

## 🏗️ Architecture

### BLoC Pattern Implementation (Manual)

This project implements a **custom BLoC (Business Logic Component) pattern** without external dependencies, providing:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│       UI        │    │      BLoC       │    │     State       │
│   (Widgets)     │───▶│   (Business     │───▶│   (Immutable    │
│                 │    │    Logic)       │    │    Data)        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         ▲                       │                       │
         │                       ▼                       │
         └─────────────────────Events─────────────────────┘
```

#### Core Components:

1. **Events** (`lib/bloc/coffee_events.dart`)
   - Immutable classes representing user actions
   - Type-safe event handling

2. **State** (`lib/bloc/coffee_state.dart`)
   - Single source of truth for application state
   - Immutable with `copyWith()` pattern

3. **BLoC** (`lib/bloc/coffee_bloc.dart`)
   - Handles business logic and state transitions
   - Manages async operations and animations

### Project Structure

```
lib/
├── bloc/                    # Custom BLoC implementation
│   ├── coffee_events.dart   # Event definitions
│   ├── coffee_state.dart    # State management
│   └── coffee_bloc.dart     # Business logic
├── constants/               # App-wide constants
│   └── app_constants.dart   # Colors, sizes, durations
├── widgets/                 # Reusable UI components
│   ├── coffee_machine_widget.dart
│   ├── cup_selector_widget.dart
│   ├── quantity_selector_widget.dart
│   └── action_button_widget.dart
├── utils/                   # Utility classes
│   └── price_formatter.dart # Price formatting logic
├── cup_enum.dart           # Cup types and pricing
└── main.dart               # App entry point
```

## 🎨 Features

### ✨ Animation System
- **Wave Animation**: Realistic coffee filling effect
- **Drop Animation**: Coffee dripping simulation
- **Cart Animation**: Smooth add-to-cart transitions
- **Loading States**: Visual feedback during operations

### 🎯 State Management
- **Reactive UI**: Automatic updates via StreamBuilder
- **Immutable State**: Predictable state changes
- **Event-Driven**: Clean separation of actions and reactions

### 🌙 Theme System
- **Dynamic Switching**: Toggle between light/dark themes
- **Custom ColorScheme**: Tailored color palettes
- **Consistent Styling**: Unified design language

### 💰 Dynamic Pricing
- **Size-Based Pricing**: Different prices per cup size
- **Quantity Calculation**: Real-time total updates
- **Price Breakdown**: Clear pricing display

## 🛠️ Technical Implementation

### BLoC Pattern Benefits

1. **Separation of Concerns**
   ```dart
   // UI only handles presentation
   StreamBuilder<CoffeeState>(
     stream: coffeeBloc.stateStream,
     builder: (context, snapshot) {
       final state = snapshot.data!;
       return CoffeeUI(state: state);
     },
   )
   ```

2. **Testability**
   ```dart
   // Easy unit testing
   test('should increment quantity', () {
     bloc.add(QuantityIncrementEvent());
     expect(bloc.currentState.quantity, 2);
   });
   ```

3. **Predictable State Changes**
   ```dart
   // Immutable state updates
   CoffeeState copyWith({
     CupEnum? selectedCup,
     int? quantity,
     bool? isDarkMode,
   }) => CoffeeState(
     selectedCup: selectedCup ?? this.selectedCup,
     quantity: quantity ?? this.quantity,
     isDarkMode: isDarkMode ?? this.isDarkMode,
   );
   ```

### Animation Management

```dart
// Coordinated animation sequences
void _handleFillingAnimation() async {
  await Future.delayed(const Duration(milliseconds: 600));
  add(ShowLoadingOverlayEvent());
  
  await Future.delayed(AppConstants.waveDuration);
  add(FillingCompletedEvent());
}
```

### Theme Implementation

```dart
// Dynamic theme switching
ThemeData get darkTheme => ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffD4A574),
    background: Color(0xff121212),
    // ... more colors
  ),
);
```

## 🚀 Best Practices Implemented

### 1. **Clean Architecture**
- Single Responsibility Principle
- Dependency Inversion
- Separation of Concerns

### 2. **State Management**
- Immutable state objects
- Centralized state management
- Predictable state transitions

### 3. **Code Organization**
- Feature-based structure
- Reusable components
- Consistent naming conventions

### 4. **Performance Optimization**
- Efficient widget rebuilds
- Proper resource disposal
- Optimized animations

### 5. **Type Safety**
- Strong typing throughout
- Null safety compliance
- Pattern matching for events

### 6. **Error Handling**
- Graceful error states
- Resource cleanup
- Async safety checks

## 📱 Supported Platforms

- ✅ **Android**
- ✅ **iOS**
- ✅ **Web**
- ✅ **Windows**
- ✅ **macOS**
- ✅ **Linux**

## 🎯 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/coffee-machine-animation.git
   cd coffee-machine-animation
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Run with hot reload
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

## 🧪 Testing

The BLoC architecture makes testing straightforward:

```dart
// Unit test example
void main() {
  group('CoffeeBloc', () {
    late CoffeeBloc bloc;
    
    setUp(() {
      bloc = CoffeeBloc();
    });
    
    test('should start with initial state', () {
      expect(bloc.currentState.selectedCup, CupEnum.small);
      expect(bloc.currentState.quantity, 1);
    });
    
    test('should update cup selection', () {
      bloc.selectCup(CupEnum.large);
      expect(bloc.currentState.selectedCup, CupEnum.large);
    });
  });
}
```

## 🎨 UI/UX Features

### Design Principles
- **Material Design 3** compliance
- **Smooth animations** (60fps)
- **Intuitive interactions**
- **Accessibility support**
- **Responsive layout**

### Key Interactions
- **Tap to Fill**: Initiates coffee brewing animation
- **Swipe Cups**: Navigate between cup sizes
- **Quantity Controls**: Increment/decrement with haptic feedback
- **Theme Toggle**: Instant theme switching
- **Add to Cart**: Animated cart addition

## 🔧 Customization

### Adding New Cup Types
```dart
// In cup_enum.dart
enum CupEnum {
  small(label: 'Small', price: 30, image: 'assets/cup1.png'),
  medium(label: 'Medium', price: 35, image: 'assets/cup2.png'),
  large(label: 'Large', price: 40, image: 'assets/cup3.png'),
  extraLarge(label: 'Extra Large', price: 45, image: 'assets/cup4.png'), // New
}
```

### Modifying Animations
```dart
// In app_constants.dart
class AppConstants {
  static const Duration waveDuration = Duration(seconds: 5);
  static const Duration animation1200 = Duration(milliseconds: 1200);
  // Add your custom durations
}
```

## 📚 Learning Resources

This project demonstrates:
- **BLoC Pattern** implementation
- **Stream-based** state management
- **Animation** coordination
- **Theme** management
- **Clean Architecture** principles

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Community contributors for inspiration

---

**Built with ❤️ using Flutter and custom BLoC architecture**
