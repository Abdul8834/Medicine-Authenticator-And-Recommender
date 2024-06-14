import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_medicine_app/dbhelper.dart';

class BarcodeScreen extends StatefulWidget {
  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  TextEditingController _serialNumberController = TextEditingController();
  String _medicineInfo = '';

  @override
  void dispose() {
    _serialNumberController.dispose();
    super.dispose();
  }

  Future<void> _searchMedicineInfo(String serialNumber) async {
    try {
      var medicineInfo = await DbHelper().getMedicineInfo(serialNumber);
      if (medicineInfo != null && medicineInfo.isNotEmpty) {
        setState(() {
          _medicineInfo =
          'Medicine Name: ${medicineInfo['name']}\n'
              'Authenticity: ${medicineInfo['authenticity']}\n'
              'Expiration Date: ${medicineInfo['expiration_date']}\n'
              'Registration Status: ${medicineInfo['registration_status']}\n'
              'Recall Status: ${medicineInfo['recall_status']}\n'
              'Formula: ${medicineInfo['formula']}\n'
              'Price: ${medicineInfo['price']}\n'
              'Manufacturer: ${medicineInfo['manufacturer']}';
        });
      } else {
        setState(() {
          _medicineInfo = 'Medicine not found in the database';
        });
      }
    } catch (e) {
      print('Error searching medicine info: $e');
      setState(() {
        _medicineInfo = 'Error searching medicine info';
      });
    }
  }

  Future<void> _scanBarcode() async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print('Scanned Barcode Result: $barcodeScanResult');
      if (barcodeScanResult != null && barcodeScanResult != '-1') {
        // Call method to fetch medicine info based on scanned serial number
        var medicineInfo =
        await DbHelper().getMedicineInfo(barcodeScanResult);
        if (medicineInfo != null && medicineInfo.isNotEmpty) {
          setState(() {
            _medicineInfo =
            'Medicine Name: ${medicineInfo['name']}\n'
                'Authenticity: ${medicineInfo['authenticity']}\n'
                'Expiration Date: ${medicineInfo['expiration_date']}\n'
                'Registration Status: ${medicineInfo['registration_status']}\n'
                'Recall Status: ${medicineInfo['recall_status']}\n'
                'Formula: ${medicineInfo['formula']}\n'
                'Price: ${medicineInfo['price']}\n'
                'Manufacturer: ${medicineInfo['manufacturer']}';
          });
        } else {
          setState(() {
            _medicineInfo = 'Medicine not found in the database';
          });
        }
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: AppBar(
            title: Text(
              'Barcode Scanner',
              style: GoogleFonts.dancingScriptTextTheme().headline6?.copyWith(
                color: Color(0xFF5EB090),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 170.0, left: 16.0, right: 16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        color: Color(0xFF5EB090),
                        child: InkWell(
                          onTap: _scanBarcode,
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_camera),
                                SizedBox(width: 15),
                                Text(
                                  'Scan Barcode',
                                  style: TextStyle(fontSize: 25, color: Color(0xFF14395D)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _serialNumberController,
                        decoration: InputDecoration(
                          labelText: 'Enter Serial Number',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onSubmitted: (value) {
                          _searchMedicineInfo(value);
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          String serialNumber = _serialNumberController.text;
                          _searchMedicineInfo(serialNumber);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5EB090),
                          foregroundColor: Color(0xFF14395D),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 8),
                            Text('Search'),
                          ],
                        ),
                      ),
                      if (_medicineInfo.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[50],
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              _medicineInfo,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
