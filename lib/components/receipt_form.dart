import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/constants/receipt.dart';
import 'package:spendsmart/models/receipt.dart';
import 'package:spendsmart/receipt_page.dart';
import 'package:spendsmart/services/firestore.dart';
import 'package:spendsmart/styles.dart';

class ReceiptForm extends StatefulWidget {
  final bool isEditable;
  final Receipt receipt;
  final String? id;

  const ReceiptForm({
    super.key,
    required this.isEditable,
    required this.receipt,
    this.id,
  });

  @override
  State<ReceiptForm> createState() => _ReceiptFormState();
}

class _ReceiptFormState extends State<ReceiptForm> {
  late TextEditingController _businessNameController;
  late String _category;
  late List<Item> _items;
  late String _date;
  late String _imageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(
      text: widget.receipt.businessName,
    );
    _category = widget.receipt.category;
    _items = List.from(widget.receipt.items);
    _date = widget.receipt.date;
    _imageUrl = widget.receipt.imageUrl;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    super.dispose();
  }

  double get total =>
      _items.fold(0, (sum, item) => sum + (item.quantity * item.price));

  void addItem() {
    setState(() {
      _items.add(Item(name: "", quantity: 1, price: 0));
    });
  }

  void removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> handleSave() async {
    setState(() {
      _isSaving = true;
    });

    final updatedReceipt = Receipt(
      id: widget.receipt.id,
      businessName: _businessNameController.text,
      category: _category,
      items: _items,
      date: _date,
      totalPrice: total,
      imageUrl: _imageUrl,
    );

    final user = AppState().currentUser.value;

    try {
      final receiptId = await FirestoreService.saveReceipt(
        userId: user["uid"],
        receipt: updatedReceipt,
        receiptId: updatedReceipt.id,
      );

      print("Receipt saved/updated with ID: $receiptId");

      updatedReceipt.id = receiptId;

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => ReceiptPage(receipt: updatedReceipt, isEditable: false),
          ),
        );
      }
    } catch (e) {
      print("Error saving receipt: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final receiptDate = DateTime.parse(_date).toLocal();

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.isEditable)
              TextField(
                controller: _businessNameController,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Business Name",
                  labelStyle: TextStyle(color: Colors.black54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
              )
            else
              Center(
                child: Text(
                  _businessNameController.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            if (widget.isEditable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: _category,
                  dropdownColor: AppColors.secondary,
                  underline: const SizedBox(),
                  isExpanded: true,
                  iconEnabledColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _category = val);
                    }
                  },
                  items:
                      CATEGORIES
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                ),
              )
            else
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _category,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            if (widget.isEditable)
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: receiptDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) {
                    setState(() {
                      _date = picked.toIso8601String();
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black54),
                      labelText: "Date",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('MMM d, yyyy').format(receiptDate),
                    ),
                    style: const TextStyle(color: Colors.black87),
                    readOnly: true,
                  ),
                ),
              )
            else
              Center(
                child: Text(
                  DateFormat('MMM d, yyyy h:mm a').format(receiptDate),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

            const SizedBox(height: 16),

            Divider(color: Colors.grey.shade300, thickness: 1),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Items",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            ..._items.asMap().entries.map((entry) {
              int index = entry.key;
              Item item = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child:
                    widget.isEditable
                        ? Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                initialValue: item.name,
                                onChanged: (val) => _items[index].name = val,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Item name",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 50,
                              child: TextFormField(
                                initialValue: item.quantity.toString(),
                                keyboardType: TextInputType.number,
                                onChanged:
                                    (val) =>
                                        _items[index].quantity =
                                            int.tryParse(val) ?? 1,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Qty",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                initialValue: item.price.toString(),
                                keyboardType: TextInputType.number,
                                onChanged:
                                    (val) =>
                                        _items[index].price =
                                            double.tryParse(val) ?? 0,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Price",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => removeItem(index),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "${item.quantity}x",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      item.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              (item.quantity * item.price).toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
              );
            }),

            if (widget.isEditable)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: addItem,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Item"),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                  ),
                ),
              ),

            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: AppTextSize.title,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "₱",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: AppTextSize.title,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: AppTextSize.title,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.isEditable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(_isSaving ? "Saving" : "Save"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
