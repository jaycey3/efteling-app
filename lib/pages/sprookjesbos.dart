import 'package:flutter/material.dart';
import 'package:efteling/models/princess_model.dart';
import 'package:efteling/services/bluetooth_service.dart';

class SprookjesbosPage extends StatefulWidget {
  @override
  _SprookjesbosPageState createState() => _SprookjesbosPageState();
}

class _SprookjesbosPageState extends State<SprookjesbosPage> {
  late BluetoothService _bluetoothService;
  final Character _character = Character(
    id: 'princess',
    name: 'Prinses',
    imagePath: 'assets/images/RedRidingHood.png',
    silhouettePath: 'assets/images/RedRidingHoodSilhoutte.PNG',
    beaconUUID: 'e584fbcb-829c-48b2-88cc-f7142b926aea',
    beaconMajor: 10,
    beaconMinor: 1,
  );
  bool _characterUnlocked = false;
  bool _matched = false;

  @override
  void initState() {
    super.initState();
    _bluetoothService = BluetoothService(
      onCharacterDetected: _handleCharacterDetected,
    );
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await _bluetoothService.requestPermission();
    await _bluetoothService.startScanning([_character]);
  }

  void _handleCharacterDetected(Character character) {
    if (!_characterUnlocked) {
      setState(() {
        _characterUnlocked = true;
      });
      _showCharacterFoundDialog(character);
    }
  }

  void _showCharacterFoundDialog(Character character) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Je hebt een prinses gevonden!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              character.imagePath,
              height: 200,
            ),
            SizedBox(height: 10),
            Text("Sleep de prinses naar de juiste plek op het scherm."),
          ],
        ),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _checkMatch(Character character) {
    setState(() {
      _matched = true;
    });
  }

  @override
  void dispose() {
    _bluetoothService.stopScanning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          if (_characterUnlocked && !_matched)
            Container(
              height: 150,
              color: Colors.grey[200],
              child: Center(
                child: Draggable<Character>(
                  data: _character,
                  feedback: Image.asset(
                    _character.imagePath,
                    height: 130,
                    width: 130,
                  ),
                  childWhenDragging: Container(),
                  child: Image.asset(
                    _character.imagePath,
                    height: 130,
                    width: 130,
                  ),
                ),
              ),
            ),
          
          Expanded(
            child: Center(
              child: DragTarget<Character>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 250,
                    height: 250,
                    child: _matched
                      ? Image.asset(_character.imagePath, fit: BoxFit.contain)
                      : Image.asset(_character.silhouettePath, fit: BoxFit.contain),
                  );
                },
                onWillAccept: (data) => !_matched,
                onAccept: (droppedCharacter) {
                  _checkMatch(droppedCharacter);
                },
              ),
            ),
          ),
        ],
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              "het Sprookjesbos",
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
}
