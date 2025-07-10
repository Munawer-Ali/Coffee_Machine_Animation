enum CupEnum {
  small(label: 'Small', padding: 14, scale: 0.7, price: 30),
  medium(label: 'Medium', padding: 12, scale: 0.8, price: 35),
  large(label: 'Large', padding: 10, scale: 0.9, price: 40),
  xLarge(label: 'XLarge', padding: 8, scale: 1.1, price: 45),
  custom(label: 'Custom', padding: 14, scale: 0, price: 50),
  ;

  final String label;
  final double padding;
  final double scale;
  final int price;

  const CupEnum({
    required this.label,
    required this.padding,
    required this.scale,
    required this.price,
  });
}
