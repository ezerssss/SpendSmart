import 'package:spendsmart/models/receipt.dart';

const List<String> CATEGORIES = [
  "Grocery",
  "Restaurant",
  "Fast Food",
  "Cafe",
  "Retail",
  "Pharmacy",
  "Gas Station",
  "Electronics",
  "Clothing",
  "Home Improvement",
  "Office Supplies",
  "Bookstore",
  "Bakery",
  "Liquor Store",
  "Convenience Store",
];

final List<Item> SAMPLE_ITEMS = List.generate(
  3,
  (index) =>
      Item(name: "Item $index", quantity: 1 + index, price: 50 * (index + 1)),
);

final Receipt SAMPLE_RECEIPT = Receipt(
  businessName: "Merchant Store",
  category: "Restaurant",
  items: SAMPLE_ITEMS,
  date: DateTime.now().toIso8601String(),
  imageUrl:
      "https://firebasestorage.googleapis.com/v0/b/segunda-ph.firebasestorage.app/o/users%2FZm6kX5KKFEhsq6Jl0H63snMSxXj2%2FitemImages%2Fd9d428d8-f855-4834-ae67-6829cf58b7c9?alt=media&token=2b7fe38a-d7bf-49eb-abae-fb5b50b8a07e",
  totalPrice: 0,
);
