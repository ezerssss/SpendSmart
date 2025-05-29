import 'package:spendsmart/errors/receipt.dart';

class Item {
  final String name;
  final double price;
  final int quantity;

  Item({required this.name, required this.price, required this.quantity});

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      name: map["name"],
      price: map["price"],
      quantity: map["quantity"],
    );
  }

  static Map<String, dynamic> toMap(Item item) {
    return {"name": item.name, "price": item.price, "quantity": item.quantity};
  }
}

class Receipt {
  final String businessName;
  final String category;
  final List<Item> items;
  final String date;
  final String imageUrl;
  final double totalPrice;

  Receipt({
    required this.businessName,
    required this.category,
    required this.items,
    required this.date,
    required this.imageUrl,
    required this.totalPrice,
  });

  static Receipt fromMap(Map<String, dynamic> map) {
    final List<Item> listItem = [];
    for (var item in map["items"]) {
      listItem.add(Item.fromMap(item));
    }
    return Receipt(
      businessName: map["businessName"],
      category: map["category"],
      items: listItem,
      date: map["date"],
      imageUrl: map["imageUrl"],
      totalPrice: map["totalPrice"],
    );
  }

  static Map<String, dynamic> toMap(Receipt receipt) {
    List<Map<String, dynamic>> itemsListMap =
        receipt.items.map((item) {
          return Item.toMap(item);
        }).toList();

    return {
      "businessName": receipt.businessName,
      "category": receipt.category,
      "items": itemsListMap,
      "date": receipt.date,
      "imageUrl": receipt.imageUrl,
      "totalPrice": receipt.totalPrice,
    };
  }

  static Receipt fromOpenAIResponse(Map<String, dynamic> map, String imageUrl) {
    if (!map["isValid"]) {
      throw InvalidReceipt(map["message"]);
    }

    String now = DateTime.now().toIso8601String();
    final List<Item> items = [];
    double total = 0;

    for (final mapItem in map["items"]) {
      Item item = Item.fromMap(mapItem);
      items.add(item);
      total += item.price * item.quantity;
    }

    return Receipt(
      businessName: map["businessName"],
      category: map["category"],
      items: items,
      date: now,
      imageUrl: imageUrl,
      totalPrice: total,
    );
  }
}
