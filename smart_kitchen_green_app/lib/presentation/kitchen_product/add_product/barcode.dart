import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:smart_kitchen_green_app/apis/kitchen_apis/barcode_info.dart';
import 'package:smart_kitchen_green_app/data_layer/kitchen/kitchen_product.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/product_list/temp_list_products.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String _scanResult = "Scan a barcode";
  Map<String, dynamic>? _info;
  String productName = "";
  String entryDate = "";
  String expiryDate = "";

  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan(
          options: const ScanOptions(
              autoEnableFlash: true,
              android: AndroidOptions(useAutoFocus: true)));
      setState(() {
        _scanResult = result.rawContent;
      });
      _info = await fetchProductDetails(result.rawContent);

      if (_info != null) {
        fecthIformation(_info!, result.rawContent);
      }
    } catch (e) {
      setState(() {
        _scanResult = "Failed to get barcode: $e";
      });
    }
  }

  void fecthIformation(Map<String, dynamic> info, code) {
    setState(() {
      productName = info['product_name'];
      entryDate = info['entry_dates_tags'].toString();
      expiryDate = info['expiration-date-to-be-completed'] ?? "-----";

      Product product = Product.add(
          name: productName,
          quantity: '1',
          expiryDate: expiryDate,
          barcode: code);

      Products.addProduct(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            Text(_scanResult),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _scanBarcode();

                productName = "";
                entryDate = "";
                expiryDate = "";
              },
              child: Text('Scan Barcode'),
            ),
            SizedBox(height: 20),
            TempListProducts(),
          ],
        ),
      ),
    );
  }
}
