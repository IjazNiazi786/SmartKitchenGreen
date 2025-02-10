import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_kitchen_green_app/data_layer/kitchen/kitchen_product.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/product_list/temp_list_products.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AddWithVoice extends StatefulWidget {
  const AddWithVoice({super.key});

  @override
  State<AddWithVoice> createState() => _AddWithVoiceState();
}

class _AddWithVoiceState extends State<AddWithVoice> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  late TextEditingController _productNameController;
  late TextEditingController _quantityController;
  late TextEditingController _expiryDateController;
  late TextEditingController _barcodeController;
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _numberWords = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
    'zero': '0',
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _productNameController = TextEditingController();
    _quantityController = TextEditingController();
    _expiryDateController = TextEditingController();
    _barcodeController = TextEditingController();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle the case where the user denied the permission
      print("Microphone permission denied");
    }
  }

  void _listen(TextEditingController controller, {bool isDate = false}) async {
    if (!_isListening) {
      bool available = await _speech.initialize(onStatus: (val) {
        if (val == "done") {
          setState(() {
            _isListening = false;
          });
        }
      }, onError: (val) {
        setState(() {
          _isListening = false;
        });
      });
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = _convertToDigits(val.recognizedWords);
            if (isDate) {
              String decoratedDate = decorateDate(_text);
              controller.text = decoratedDate;
            } else {
              controller.text = _text;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  String _convertToDigits(String recognizedWords) {
    return recognizedWords
        .split(' ')
        .map((word) => _numberWords[word.toLowerCase()] ?? word)
        .join(' ');
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _expiryDateController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _productNameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        prefixIcon: Icon(Icons.text_fields),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: () => _listen(_productNameController),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.line_weight),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: () => _listen(_quantityController),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _expiryDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: "YYYY-MM-DD",
                        labelText: 'Expiry Date (YYYY-MM-DD)',
                        prefixIcon: Icon(Icons.date_range),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                            IconButton(
                              icon: Icon(Icons.mic),
                              onPressed: () => _listen(_expiryDateController),
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an expiry date';
                        } else if (!isValidDate(value)) {
                          return "Please Enter Valid Date Format (YYYY-MM-DD)";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _barcodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Barcode (Optional)',
                        prefixIcon: Icon(Icons.barcode_reader),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: () => _listen(_barcodeController),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Product product = Product.add(
                            name: _productNameController.text,
                            quantity: _quantityController.text,
                            expiryDate: _expiryDateController.text,
                            barcode: _barcodeController.text,
                          );

                          Products.addProduct(product);
                          setState(() {});
                        }
                      },
                      child: Text('Add Product'),
                    ),
                    TempListProducts(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidDate(String dateStr) {
    // Regular expression to match YYYY-MM-DD format
    RegExp regex = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})$',
    );

    if (!regex.hasMatch(dateStr)) {
      return false;
    }

    // Parse the date parts to integers
    List<String?> matches =
        regex.firstMatch(dateStr)?.groups([1, 2, 3])?.toList() ?? [];
    int year = int.parse(matches[0]!);
    int month = int.parse(matches[1]!);
    int day = int.parse(matches[2]!);

    // Check if month is between 1 and 12
    if (month < 1 || month > 12) {
      return false;
    }

    // Check if day is valid for the given month
    if (day < 1 || day > 31) {
      return false;
    }

    return true;
  }

  String decorateDate(String inputDate) {
    // Remove any non-numeric characters
    String cleanedDate = inputDate.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedDate.length == 8) {
      return '${cleanedDate.substring(0, 4)}-${cleanedDate.substring(4, 6)}-${cleanedDate.substring(6)}';
    } else if (cleanedDate.length >= 6) {
      // Assuming YY-MM-DD or YYYY-M-D or similar
      String yearPart = cleanedDate.substring(0, cleanedDate.length - 4);
      String monthPart =
          cleanedDate.substring(yearPart.length, cleanedDate.length - 2);
      String dayPart =
          cleanedDate.substring(yearPart.length + monthPart.length);

      // Adjust year format
      if (yearPart.length == 2) {
        yearPart = '20$yearPart'; // Convert YY to YYYY
      }

      // Return formatted date
      return '$yearPart-$monthPart-$dayPart';
    }

    // Return original if unable to parse
    return inputDate;
  }
}
