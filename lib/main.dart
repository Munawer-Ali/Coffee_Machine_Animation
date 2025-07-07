import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:add_to_cart_animation/add_to_cart_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
      ),
      home: const CoffeeOrderPage(),
    );
  }
}

class CoffeeOrderPage extends StatefulWidget {
  const CoffeeOrderPage({Key? key}) : super(key: key);

  @override
  State<CoffeeOrderPage> createState() => _CoffeeOrderPageState();
}

class _CoffeeOrderPageState extends State<CoffeeOrderPage> with TickerProviderStateMixin {
 GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final PageController _controller = PageController(viewportFraction: 0.8);
  double _currentPage = 0.0;
  int _selectedSize = 0;
  int _quantity = 1;
  bool _isLoading = false;
  bool _showLoadingOverlay = false;
  bool _animationComplete = false;
 bool drop = false;
 bool dropAnimation = false;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
 
  final GlobalKey _cupKey = GlobalKey();
   late Function(GlobalKey) runAddToCartAnimation;
  final List<String> _sizes = ['Small', 'Medium', 'Large', 'XLarge', 'Custom'];
  final List<IconData> _sizeIcons = [
    Icons.local_cafe,
    Icons.local_cafe_outlined,
    Icons.coffee,
    Icons.coffee_outlined,
    Icons.more_horiz,
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _waveAnimation = Tween<double>(begin: -0.1, end: 1.0).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
      });
    });
   
  }

  @override
  void dispose() {
    _waveController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTapToFill() async {
    if(_animationComplete){
     _onAddToCart();
      return;
    }
    setState(() {
      _isLoading = true;
      _showLoadingOverlay = false;
    });
    await Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && _isLoading) {
        setState(() {
          _showLoadingOverlay = true;
        });
      }
    });
    _waveController.reset();
    _waveController.forward();
    await Future.delayed(_waveController.duration!);
    setState(() {
      _isLoading = false;
      _showLoadingOverlay = false;
       _animationComplete = true;
    });

    Future.delayed(Duration(milliseconds: 1200),(){
      drop = true;
      setState(() {

      });
      Future.delayed(Duration(milliseconds: 10),(){
        dropAnimation = true;
        setState(() {

        });
      });

    });
    Future.delayed(Duration(milliseconds: 1000),(){
      dropAnimation = false;
      drop = false;
      setState(() {

      });
    });
  }

  void _onAddToCart() async {
    // Use add_to_cart_animation package
    await runAddToCartAnimation(_cupKey);
    cartKey.currentState?.runCartAnimation((1).toString());
    setState(() {
      _animationComplete = false;
      _selectedSize = 0;
      _quantity = 1;
    });
  }

  double cupSize(int index) {
      switch (index) {
        case 0:
          return 14;
        case 1:
          return 12;
        case 2:
          return 10;
        case 3:
          return 8;
        case 4:
          return 14;
      }
      return 0;
  }

  double cupScale(int index){
        switch (index) {
        case 0:
          return 0.7;
        case 1:
          return 0.8;
        case 2:
          return 0.9;
        case 3:
          return 1.1;
      }
      return 0;
    
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: AddToCartAnimation(
        cartKey: cartKey,
        jumpAnimation: JumpAnimationOptions(active: false),
        dragAnimation: DragToCartAnimationOptions(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
         createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 55, // Made the AppBar shorter
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () {},
            ),
            title: const Text(
              'Caramel Frappuccino',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            actions: [
             AddToCartIcon(
              key: cartKey,
              icon: const Icon(Icons.shopping_cart),
            
              badgeOptions: const BadgeOptions(
                active: true,
                fontSize: 9,
                width: 3,
                height: 3,
 backgroundColor: Colors.white,
               ),
            ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              // Coffee machine image placeholder
            
             Expanded(child: Center()),
              SizedBox(
                height: 320,
                child: Stack(
                  children: [
                    Image.asset('assets/machine.png'),
                 
                    Positioned(
                      top: 27,
                      left: 113,
                      child: AnimatedContainer(duration: Duration(milliseconds: 800),curve: Curves.easeInOut,height: 12,width: 12,decoration: BoxDecoration(boxShadow: [BoxShadow(color:_showLoadingOverlay ?  Colors.white : Colors.transparent,blurRadius: _showLoadingOverlay ? 3 :1,offset: Offset(0,10))],borderRadius: BorderRadius.circular(2)),),
                    ),

                    

               Positioned(
                      top: 50,
                      left: 113,
                      child: AnimatedContainer(duration: Duration(milliseconds: 800),curve: Curves.easeInOut,height: 12,width: 12,decoration: BoxDecoration(boxShadow: [BoxShadow(color:_showLoadingOverlay ?  Colors.white : Colors.transparent,blurRadius: _showLoadingOverlay ? 3 :1,offset: Offset(0,10))],borderRadius: BorderRadius.circular(2)),),
                    ),


               Positioned(
                      top: 27,
                      right: 113,
                      child: AnimatedContainer(duration: Duration(milliseconds: 800),curve: Curves.easeInOut,height: 12,width: 12,decoration: BoxDecoration(boxShadow: [BoxShadow(color:_showLoadingOverlay ?  Colors.white : Colors.transparent,blurRadius: _showLoadingOverlay ? 3 :1,offset: Offset(0,10))],borderRadius: BorderRadius.circular(2)),),
                    ),



                      Positioned(
                      top: 50,
                      right: 113,
                      child: AnimatedContainer(duration: Duration(milliseconds: 800),curve: Curves.easeInOut,height: 12,width: 12,decoration: BoxDecoration(boxShadow: [BoxShadow(color:_showLoadingOverlay ?  Colors.white : Colors.transparent,blurRadius: _showLoadingOverlay ? 3 :1,offset: Offset(0,10))],borderRadius: BorderRadius.circular(2)),),
                    ),




 Positioned(
                      top: 144,
                      right: 142,
                      child: AnimatedOpacity(
                        opacity: _showLoadingOverlay ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        child: AnimatedContainer(height: _showLoadingOverlay ? 80 : 0,width: 4,decoration: BoxDecoration(color: Color(0xffC1885A),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2),bottomRight: Radius.circular(2))
                        ),duration: Duration(milliseconds: 1000),curve: Curves.easeInOut,),
                      ),
                    ),
                      Positioned(
                      top: 144,
                      left: 142,
                      child: AnimatedOpacity(
                        opacity: _showLoadingOverlay ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        child: AnimatedContainer(height: _showLoadingOverlay ? 80 : 0,width: 4,decoration: BoxDecoration(color: Color(0xffC1885A),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2),bottomRight: Radius.circular(2))
                        ),duration: Duration(milliseconds: 1000),curve: Curves.easeInOut,),
                      ),
                    ),

                drop ?    AnimatedPositioned(
                  duration: Duration(milliseconds: 700),
                      top: dropAnimation ? 230:144,
                      right: 142,
                      child: AnimatedContainer(height: 4,width: 4,decoration: BoxDecoration(color: Color(0xffC1885A),
                          shape: BoxShape.circle
                      ),duration: Duration(milliseconds: 1000),curve: Curves.easeInOut,),
                    ):SizedBox(),

                    Positioned(
                      top: 50,
                      left: 108,
                      right: 108,
                      bottom: -105,
                      
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: PageView.builder(
                          itemCount: 3,
                          controller: _controller,
                          itemBuilder: (context, index) {
                            double scale = 1.0;
                            double diff = (_currentPage - index).abs();
                            scale = 1 - (diff * 0.4);
                            if (scale < 0.8) scale = 0.8;
                            // Animate scale for the selected cup
                            return AnimatedScale(
                              scale: cupScale(_selectedSize),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.all(diff * 30),
                                curve: Curves.easeOut,
                                child: Container(
                              key: _currentPage == index ? _cupKey : null,
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
                    ),

                  ],
                )),

              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Size Options',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),

                    Row(
                  children: const [
                    Text(
                      '\$30',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      '.00',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Size options
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 72,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_sizes.length, (index) {
                    final selected = _selectedSize == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap:  () {
                                setState(() {
                                  _selectedSize = index;
                                });
                              },
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:  (selected ? Colors.green : Colors.grey[200]),
                                shape: BoxShape.circle,
                               
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(cupSize(index)),
                                  child: Image.asset(
                                    'assets/cupIcon.png',
                                    color: (selected ? Colors.white : Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _sizes[index],
                              style: TextStyle(
                                color:  Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: Row(
                  children: [
                    // Delete icon
                    Icon(Icons.delete_forever_outlined),
                    // Quantity selector
                    SizedBox(width: 8,),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      child: Icon(Icons.add_circle_outline)),
                   
                    // Tap to fill button
                    SizedBox(width: 20,),
                    Expanded(
                      child: GestureDetector(
                        onTap: _isLoading ? null : _onTapToFill,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 45,
                          decoration: BoxDecoration(
                            color: _isLoading ? Colors.white:Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child:_showLoadingOverlay ?AnimatedOpacity(
                            opacity: _showLoadingOverlay ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            child: 
                                 Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: AnimatedBuilder(
                                            animation: _waveAnimation,
                                            builder: (context, child) {
                                              return  RotatedBox(
                                              quarterTurns: -1,
                                                child: WaveWidget(
                                                  duration: 3000,
                                                  config: CustomConfig(
                                                    colors: [
                                                      Colors.white,
                                                    ],
                                                    durations: [2000],
                                                    heightPercentages: [
                                                      (_waveAnimation.value)
                                                    ],
                                                  ),
                                                  size: const Size(double.infinity, double.infinity),
                                                  waveAmplitude: 0,
                                                  waveFrequency: 1,
                                                  wavePhase: 2,
                                                  backgroundColor: Color(0xff482D13),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                
                                Center(
                                  child: Text(
                                          'Tap to fill',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                )
                                    ],
                                  )
                              
                          )  : Center(
                                     child: GestureDetector(
                                       onTap: _animationComplete ? _onAddToCart : null,
                                       child: Text(
                                         _animationComplete ? "Add to cart":'Tap to fill',
                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                       ),
                                     ),
                                   ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
     ),
   );
  }
}