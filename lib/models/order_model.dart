import 'package:multi_vendor/models/cart_model.dart';
import 'package:multi_vendor/models/user_model.dart';

class OrderModel {
  int user_id, shipping;
  List<int> products, quantity;
  List<double> prices;
  double total;

  OrderModel(
      {required this.user_id,
      required this.prices,
      required this.products,
      required this.shipping,
      required this.quantity,
      required this.total});

  static OrderModel fromCart(
      {required List<CartModel> list, required double total, required int id}) {
    List<int> product_ids = [];
    List<double> product_prices = [];
    List<int> product_quantity = [];

    for (CartModel element in list) {
      product_ids.add(element.id);
      product_prices.add(double.parse(element.price));
      product_quantity.add(element.quantity);
    }
    return OrderModel(
        user_id: id,
        prices: product_prices,
        products: product_ids,
        shipping: 0,
        total: total,
        quantity: product_quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": user_id,
      "product_price": prices,
      "product_list": products,
      "total": total,
      "quantity": quantity,
      "shipping": shipping
    };
  }
}
