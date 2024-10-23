import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ItemModel.dart';
import 'ItemView.dart';
import 'package:intl/intl.dart';

class QuotationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuotationViewModel(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Quotation'),
            backgroundColor: Color.fromARGB(255, 14, 71, 118),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Handle back navigation here
              },
            ),
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      context.read<QuotationViewModel>().saveQuotation();
                    },
                  );
                },
              ),
            ],
          ),
          body: QuotationForm(),
        ),
      ),
    );
  }
}

class QuotationForm extends StatefulWidget {
  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String getTodayDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                hint: Text('Auckland Offices'),
                items:
                    ['Auckland Offices', 'Sydney Office'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              Text(getTodayDate(), style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 14, 71, 118)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Color.fromARGB(255, 14, 71, 118),
                borderRadius: BorderRadius.circular(10),
              ),
              tabs: [
                Container(
                  width: 150,
                  child: Tab(text: 'General'),
                ),
                Container(
                  width: 150,
                  child: Tab(text: 'Items'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 14, 71, 118),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Net Amount: ${Provider.of<QuotationViewModel>(context).netAmount}',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 20),

          // Item Entry Form
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<Item>(
                    hint: Text('Item'),
                    onChanged: (value) {
                      _itemController.text = value?.name ?? '';
                      _priceController.text = value?.price.toString() ?? '';
                    },
                    items: Provider.of<QuotationViewModel>(context)
                        .items
                        .map((item) {
                      return DropdownMenuItem<Item>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _reasonController,
                    decoration: InputDecoration(labelText: 'Reason'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    enabled: false,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _qtyController,
                          decoration: InputDecoration(labelText: 'Qty'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _discountController,
                          decoration: InputDecoration(labelText: 'Discount %'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final selectedItem = Provider.of<QuotationViewModel>(
                                  context,
                                  listen: false)
                              .items
                              .firstWhere(
                                  (item) => item.name == _itemController.text);
                          final price = selectedItem.price;
                          final qty = int.parse(_qtyController.text);
                          final discount =
                              double.parse(_discountController.text);

                          // Calculate the total
                          final total = price * qty * (1 - discount / 100);

                          final item = {
                            'name': selectedItem.name,
                            'price': price,
                            'qty': qty,
                            'discount': discount,
                            'total': total, // Add the calculated total here
                          };
                          Provider.of<QuotationViewModel>(context,
                                  listen: false)
                              .addItem(item);
                          _itemController.clear();
                          _priceController.clear();
                          _discountController.clear();
                          _qtyController.clear();
                          _reasonController.clear();
                        },
                        child: Text('ADD'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 14, 71, 118),
                            foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(
                          color: Colors.grey,
                          width: 0.5), // Subtle inner border
                      verticalInside:
                          BorderSide(color: Colors.grey, width: 0.5),
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide.none,
                    ),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        children: [
                          tableHeaderCell('Item'),
                          tableHeaderCell('Price'),
                          tableHeaderCell('Qty'),
                          tableHeaderCell('Discount'),
                          tableHeaderCell('Total'),
                        ],
                      ),
                      for (var item in Provider.of<QuotationViewModel>(context)
                          .selectedItemsnew)
                        TableRow(
                          children: [
                            tableCell(item['name']),
                            tableCell(item['price'].toString()),
                            tableCell(item['qty'].toString()),
                            tableCell(item['discount'].toString()),
                            tableCell(
                                item['total'].toString()), // Show total here
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableCell tableHeaderCell(String value) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color for header
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  TableCell tableCell(String value) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
