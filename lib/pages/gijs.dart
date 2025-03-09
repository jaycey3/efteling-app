import 'package:flutter/material.dart';

class GijsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(child: Text('plceholder')),
    );
  }
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
              CrossAxisAlignment.start, 
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
              "Welkom bij",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF3C3C3C)),
            ),
            Text(
              "Holle Bolle GIJS",
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