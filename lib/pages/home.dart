import 'package:flutter/material.dart';
import 'package:efteling/pages/gijs.dart';
import 'package:efteling/pages/sprookjesbos.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GijsPage()),
                );
              },
              child: Image.asset('assets/images/gijs.jpg', width: 150),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SprookjesbosPage()),
                );
              },
              child: Image.asset('assets/images/sprookjesbos.jpg', width: 150),
            ),
          ],
        ),
      ),
    );
  }
}
