import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/apis/kitchen_apis/add_kitchen_product.dart';
import 'package:smart_kitchen_green_app/apis/kitchen_apis/get_kitche_produtcs.dart';
import 'package:smart_kitchen_green_app/data_layer/kitchen/kitchen_product.dart';

class TempListProducts extends StatefulWidget {
  const TempListProducts({Key? key}) : super(key: key);

  @override
  _TempListProductsState createState() => _TempListProductsState();
}

class _TempListProductsState extends State<TempListProducts> {
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Barcode')),
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Expiry Date')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: Products.getProducts().map((product) {
                    int index = Products.getProducts().indexOf(product);
                    return DataRow(cells: [
                      DataCell(
                        TextFormField(
                          initialValue: product.barcode,
                          onChanged: (value) {
                            setState(() {
                              Products.getProducts()[index].barcode = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          initialValue: product.name,
                          onChanged: (value) {
                            setState(() {
                              Products.getProducts()[index].name = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          initialValue: product.quantity.toString(),
                          onChanged: (value) {
                            setState(() {
                              Products.getProducts()[index].quantity =
                                  value ?? "";
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quantity';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          initialValue: product.expiryDate,
                          onChanged: (value) {
                            setState(() {
                              Products.getProducts()[index].expiryDate = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiry date';
                            }
                            // Regex for YYYY-MM-DD format
                            if (!RegExp(r"^\d{4}-\d{2}-\d{2}$")
                                .hasMatch(value)) {
                              return 'Date should be YYYY-MM-DD';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              Products.getProducts().removeAt(index);
                            });
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator()
                : TextButton(
                    child: Text("ADD ALL IsNTO DATABASE"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isUploading = true;
                        });
                        try {
                          await fetchKitchenProducts(context);
                          await addKitchenProducts(
                              context, Products.getProducts());
                          // Clear products after successful upload
                          Products.cleanProducts();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add products: $e'),
                            ),
                          );
                        } finally {
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please correct the errors in the form'),
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
