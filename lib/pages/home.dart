import 'package:flutter/material.dart';
import 'package:efteling/pages/gijs.dart';
import 'package:efteling/pages/sprookjesbos.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ImageCard(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 200,
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns text to the left
          children: [
            Center(
              child: Image.asset(
                'assets/images/efteling.png',
                height: 80,
                width: 200,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Welkom in",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF3C3C3C)),
            ),
            Text(
              "De wereld vol wonderen",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0XFFAC162C)),
            )
          ],
        ),
      ),
    );
  }

  Center ImageCard(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImageCard(
            context,
            imagePath: 'assets/images/gijs.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GijsPage()),
              );
            },
          ),
          SizedBox(height: 20),
          _buildImageCard(
            context,
            imagePath: 'assets/images/sprookjesbos.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SprookjesbosPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context,
      {required String imagePath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            width: 380,
            height: 225,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
