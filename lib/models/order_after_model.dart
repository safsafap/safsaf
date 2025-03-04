class OrderAfterModel {
  final String order_id;

  final String status;
  final String image;
  final String total;

  OrderAfterModel({
    required this.order_id,
    required this.status,
    required this.image,
    required this.total,
  });

  // Factory method to create an instance from JSON
  factory OrderAfterModel.fromJson(Map<String, dynamic> json) {
    return OrderAfterModel(
      order_id: json['order_id'] as String,
      status: json['status'] as String,
      image: json['image'] as String,
      total: json['total'] as String,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'status': status,
      'image': image,
      'total': total,
    };
  }
}
