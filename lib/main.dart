import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc/coffee_bloc.dart';
import 'bloc/coffee_state.dart';
import 'constants/app_constants.dart';
import 'widgets/action_button_widget.dart';
import 'widgets/coffee_machine_widget.dart';
import 'widgets/cup_selector_widget.dart';
import 'widgets/quantity_selector_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CoffeeBloc _coffeeBloc;

  @override
  void initState() {
    super.initState();
    _coffeeBloc = CoffeeBloc();
  }

  @override
  void dispose() {
    _coffeeBloc.dispose();
    super.dispose();
  }

  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xffC1885A), // coffeeBrown
        onPrimary: Colors.white,
        secondary: Colors.green, // primaryGreen
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 5.0,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.black, size: 20),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        centerTitle: true,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xffD4A574), // lighter coffee for dark mode
        onPrimary: Colors.black,
        secondary: Colors.greenAccent,
        onSecondary: Colors.black,
        error: Colors.redAccent,
        onError: Colors.black,
        surface: Color(0xff1E1E1E),
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff1E1E1E),
        foregroundColor: Colors.white,
        elevation: 5.0,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white, size: 20),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        centerTitle: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoffeeState>(
      stream: _coffeeBloc.stateStream,
      initialData: _coffeeBloc.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return MaterialApp(
          title: 'Coffee Animation',
          theme: state.isDarkMode ? darkTheme : lightTheme,
          home: CoffeeOrderPage(coffeeBloc: _coffeeBloc),
        );
      },
    );
  }
}

class CoffeeOrderPage extends StatefulWidget {
  final CoffeeBloc coffeeBloc;

  const CoffeeOrderPage({
    super.key,
    required this.coffeeBloc,
  });

  @override
  State<CoffeeOrderPage> createState() => _CoffeeOrderPageState();
}

class _CoffeeOrderPageState extends State<CoffeeOrderPage>
    with TickerProviderStateMixin {
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final PageController _controller =
      PageController(viewportFraction: AppConstants.viewportFraction);
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  final GlobalKey _cupKey = GlobalKey();
  late Function(GlobalKey) runAddToCartAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: AppConstants.waveDuration,
    );
    _waveAnimation = Tween<double>(
      begin: AppConstants.waveBegin,
      end: AppConstants.waveEnd,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    _controller.addListener(() {
      widget.coffeeBloc.updatePage(_controller.page!);
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTapToFill() async {
    final state = widget.coffeeBloc.currentState;
    if (state.animationComplete) {
      await _onAddToCart();
      return;
    }

    widget.coffeeBloc.startFilling();

    // Manejar la animación de onda
    _waveController.reset();
    _waveController.forward();
  }

  Future<void> _onAddToCart() async {
    await runAddToCartAnimation(_cupKey);
    cartKey.currentState?.runCartAnimation((1).toString());
    widget.coffeeBloc.addToCart();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoffeeState>(
      stream: widget.coffeeBloc.stateStream,
      initialData: widget.coffeeBloc.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data!;
        final colorScheme = Theme.of(context).colorScheme;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: colorScheme.surface,
            statusBarIconBrightness: colorScheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: colorScheme.brightness,
          ),
          child: AddToCartAnimation(
            cartKey: cartKey,
            jumpAnimation: JumpAnimationOptions(active: false),
            dragAnimation: DragToCartAnimationOptions(
              duration: AppConstants.animation300,
              curve: Curves.easeInOut,
            ),
            createAddToCartAnimation: (runAddToCartAnimation) {
              this.runAddToCartAnimation = runAddToCartAnimation;
            },
            child: Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: AppBar(
                toolbarHeight: AppConstants.appBarHeight,
                leadingWidth: 100,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: AppConstants.iconSize),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        size: AppConstants.iconSize,
                      ),
                      onPressed: () => widget.coffeeBloc.toggleTheme(),
                    ),
                  ],
                ),
                title: const Text(
                  'Caramel Frappuccino',
                  style: TextStyle(
                    fontSize: AppConstants.fontSize18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
                actions: [
                  AddToCartIcon(
                    key: cartKey,
                    icon: const Icon(Icons.shopping_cart),
                    badgeOptions: BadgeOptions(
                      active: true,
                      fontSize: AppConstants.fontSize9,
                      width: 3,
                      height: 3,
                      backgroundColor: colorScheme.surface,
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  const SizedBox(height: AppConstants.spacing16),
                  Expanded(child: Center()),
                  CoffeeMachineWidget(
                    showLoadingOverlay: state.showLoadingOverlay,
                    drop: state.drop,
                    dropAnimation: state.dropAnimation,
                    selectedCup: state.selectedCup,
                    currentPage: state.currentPage,
                    controller: _controller,
                    cupKey: _cupKey,
                    waveAnimation: _waveAnimation,
                  ),
                  const SizedBox(height: AppConstants.spacing80),
                  CupSelectorWidget(
                    selectedCup: state.selectedCup,
                    onCupSelected: (cup) => widget.coffeeBloc.selectCup(cup),
                    quantity: state.quantity,
                  ),
                  const SizedBox(height: AppConstants.spacing40),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacing24,
                      vertical: AppConstants.spacing8,
                    ),
                    child: Row(
                      children: [
                        QuantitySelectorWidget(
                          quantity: state.quantity,
                          onIncrement: () =>
                              widget.coffeeBloc.incrementQuantity(),
                          onDecrement: () =>
                              widget.coffeeBloc.decrementQuantity(),
                        ),
                        const SizedBox(width: AppConstants.spacing20),
                        ActionButtonWidget(
                          isLoading: state.isLoading,
                          showLoadingOverlay: state.showLoadingOverlay,
                          animationComplete: state.animationComplete,
                          waveAnimation: _waveAnimation,
                          onTapToFill: _onTapToFill,
                          onAddToCart: _onAddToCart,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
