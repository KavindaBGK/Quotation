class Item {
  final int id;
  final String name;
  final double price;

  Item({required this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class Quotation {
  final int? id;
  final String name;
  final double price;
  final int qty;
  final double discount;
  final double total;

  Quotation({
    this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.discount,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'qty': qty,
      'discount': discount,
      'total': total,
    };
  }

  factory Quotation.fromMap(Map<String, dynamic> map) {
    return Quotation(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      qty: map['qty'],
      discount: map['discount'],
      total: map['total'],
    );
  }
}
