import 'package:flutter/material.dart';
import 'package:my_medicine_app/barcode_screen.dart';
import 'package:my_medicine_app/medicine_recommender_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Medicine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/barcode': (context) => BarcodeScreen(),
        '/medicine_recommender': (context) => MedicineRecommenderScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
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
              'MY Medicine App',
              style: GoogleFonts.dancingScriptTextTheme().headline6?.copyWith(
                color: Color(0xFF5EB090),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true, // Center the title vertically
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
                image: AssetImage('assets/background_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/barcode');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF5EB090)),
                      foregroundColor: MaterialStateProperty.all(Color(0xFF14395D)),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                    ),
                    child: Text('Barcode Scan / Serial Number Search'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/medicine_recommender');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF5EB090)),
                      foregroundColor: MaterialStateProperty.all(Color(0xFF14395D)),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                    ),
                    child: Text('Search Medicine Recommendations'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
