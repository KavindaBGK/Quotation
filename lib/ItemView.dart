import 'package:flutter/material.dart';
import 'SQL_Helper.dart';
import 'ItemModel.dart';

class QuotationViewModel with ChangeNotifier {
  List<Item> _items = [];
  List<Map<String, dynamic>> _selectedItems = [];
  List<Map<String, dynamic>> _selectedItemsnew = [];
  double _netAmount = 0.0;

  List<Item> get items => _items;
  List<Map<String, dynamic>> get selectedItems => _selectedItems;
  List<Map<String, dynamic>> get selectedItemsnew => _selectedItemsnew;
  double get netAmount => _netAmount;
  late String a;

  QuotationViewModel() {
    _loadItems();
  }

  Future<void> _loadItems() async {
    _items = await DatabaseHelper.instance.getItems();
    final _quotations = await DatabaseHelper.instance.getItems1();

    _selectedItemsnew =
        _quotations.map((quotation) => quotation.toMap()).toList();

    _selectedItemsnew.forEach((item) {
      print(
          'Name: ${item['name']}, Price: ${item['price']}, Qty: ${item['qty']}, Discount: ${item['discount']}, Total: ${item['total']}');
    });

    _netAmount =
        _selectedItemsnew.fold(0.0, (sum, item) => sum + item['total']);

    notifyListeners();
  }

  void addItem(Map<String, dynamic> item) {
    _selectedItems.add(item);
    _selectedItemsnew.addAll(_selectedItems);
    _calculateNetAmount();
    notifyListeners();
  }

  void _calculateNetAmount() {
    _netAmount =
        _selectedItemsnew.fold(0.0, (sum, item) => sum + item['total']);
  }

  Future<void> saveQuotation() async {
    if (_selectedItems.isEmpty) {
      print('Empty data');
    } else {
      await DatabaseHelper.instance.saveQuotation(_selectedItems);
      print(_selectedItems);
    }

    notifyListeners();
  }
}
