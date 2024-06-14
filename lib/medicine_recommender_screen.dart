import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class MedicineRecommenderScreen extends StatefulWidget {
  @override
  _MedicineRecommenderScreenState createState() =>
      _MedicineRecommenderScreenState();
}

class _MedicineRecommenderScreenState extends State<MedicineRecommenderScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _inputText = '';
  List<dynamic> _medicines = [];
  String _errorMessage = '';

  Future<void> _findMedicines() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var requestBody = {'reason': _inputText};

    var uri = Uri.parse('http://203.241.228.97:3343/result');
    var response = await http.post(uri, headers: headers, body: requestBody);


    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _medicines = responseData['res'];
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to fetch data: ${response.reasonPhrase}';
        _medicines = [];
      });
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
              'Medicine Recommender',
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
                      TextField(
                        controller: _inputController,
                        decoration: InputDecoration(
                          labelText: 'Enter Reason',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _inputText = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _findMedicines,
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
                        child: Text('Find Medicines'),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _medicines.length,
                    itemBuilder: (context, index) {
                      var medicine = _medicines[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Medicine Name: ${medicine['Drug_Name']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Reason: ${medicine['Reason']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Description: ${medicine['Description']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Similarity Score: ${medicine['Similarity_Score'].toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
