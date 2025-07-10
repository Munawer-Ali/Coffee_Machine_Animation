class PriceFormatter {
  static String formatPrice(int price) {
    return '\$$price.00';
  }

  static String formatPriceWithQuantity(int price, int quantity) {
    final total = price * quantity;
    return '\$$total.00';
  }
}
