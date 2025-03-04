import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_vendor/models/cart_model.dart';

class CartService {
  final GetStorage _storage = GetStorage(); // Initialize GetStorage
  final String _cartKey = 'cartBox'; // Define a key for cart storage

  // Add an item to the cart
  Future<void> addToCart(CartModel cartItem) async {
    // Get the current cart data or initialize an empty map
    final Map<String, dynamic> cartData = _storage.read(_cartKey) ?? {};

    // Add/update the item by its unique ID
    cartData[cartItem.id.toString()] = cartItem.toJson();

    // Save the updated cart back to storage
    await _storage.write(_cartKey, cartData);
  }

  // Remove an item from the cart
  Future<void> removeFromCart(int id) async {
    // Get the current cart data
    final Map<String, dynamic> cartData = _storage.read(_cartKey) ?? {};

    // Remove the item by its ID
    cartData.remove(id.toString());

    // Save the updated cart back to storage
    await _storage.write(_cartKey, cartData);
  }

  // Get all items in the cart
  Future<List<CartModel>> getCart() async {
    // Read the current cart data
      final GetStorage storage = GetStorage(); // Initialize GetStorage

    final Map<String, dynamic>? cartData = storage.read(_cartKey);

    // Convert the data to a list of CartModel objects
    if (cartData == null) {
      return [];
    }

    return cartData.values
        .map((item) => CartModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Get a specific item by product ID
  CartModel? getCartByProduct(int id) {
    // Read the current cart data
    final Map<String, dynamic>? cartData = _storage.read(_cartKey);

    if (cartData != null && cartData.containsKey(id.toString())) {
      final item = cartData[id.toString()];
      return CartModel.fromJson(Map<String, dynamic>.from(item));
    }

    return null;
  }

  // Check if an item is in the cart
  Future<bool> isInCart(int id) async {
    // Read the current cart data
    final Map<String, dynamic>? cartData = _storage.read(_cartKey);
    return cartData?.containsKey(id.toString()) ?? false;
  }

  // Update an item in the cart
  Future<void> updateCart(CartModel cartItem) async {
    // Use the same logic as addToCart
    await addToCart(cartItem);
  }

  // Clear the entire cart
  Future<void> clearCart() async {
    await _storage.remove(_cartKey);
  }
}
