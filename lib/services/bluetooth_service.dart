import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'package:efteling/models/princess_model.dart';

class BluetoothService {
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  bool _isScanning = false;
  bool _hasDetectedCharacter = false;
  final Function(Character) onCharacterDetected;
  
  final Set<String> _detectedDevices = {};
  
  BluetoothService({required this.onCharacterDetected});

  Future<void> requestPermission() async {
    try {
      await FlutterBluePlus.adapterState.first;
      debugPrint("Bluetooth permissions handled by FlutterBluePlus");
    } catch (e) {
      debugPrint("Error checking Bluetooth $e");
    }
  }

  Future<void> startScanning(List<Character> characters) async {
    try {
      if (await FlutterBluePlus.isSupported == false) {
        debugPrint("Bluetooth not supported");
        return;
      }

      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        debugPrint("Bluetooth is not turned on");
        return;
      }

      debugPrint("Starting scan for beacon");
      _isScanning = true;

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        if (!_isScanning || _hasDetectedCharacter) return;

        for (ScanResult result in results) {
          if (_detectedDevices.contains(result.device.remoteId.str)) {
            continue;
          }

          if (result.rssi > -50) {  
            debugPrint("device found: ${result.device.remoteId}, RSSI: ${result.rssi}");
            
            String? deviceName = result.device.platformName;
            bool isLikelyBeacon = 
                deviceName.toLowerCase().contains("beacon") || 
                deviceName.toLowerCase().contains("altbeacon") || 
                deviceName.toUpperCase().contains("RBUSB") ||
                result.rssi > -35;  
                
            if (isLikelyBeacon || result.rssi > -35) {
              debugPrint("beacon is close");
              
              _detectedDevices.add(result.device.remoteId.str);
              
              if (characters.isNotEmpty && !_hasDetectedCharacter) {
                _hasDetectedCharacter = true;
                onCharacterDetected(characters[0]);
                
                _pauseScanning();
              }
            }
          }
        }
      });

      _startContinuousScan();
    } catch (e) {
      debugPrint("Error in Bluetooth scanning: $e");
    }
  }

  Future<void> _pauseScanning() async {
    try {
      await FlutterBluePlus.stopScan();
      debugPrint("Pausing scan after detection");
      
      Future.delayed(Duration(seconds: 20), () {
        if (_isScanning) {
          _hasDetectedCharacter = false;
          _startContinuousScan();
        }
      });
    } catch (e) {
      debugPrint("Error pausing scan: $e");
    }
  }

  Future<void> _startContinuousScan() async {
    if (!_isScanning) return;
    
    try {
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 5),
        androidScanMode: AndroidScanMode.lowLatency,
      );

      Future.delayed(Duration(seconds: 6), () {
        if (_isScanning && !_hasDetectedCharacter) {
          _startContinuousScan();
        }
      });
    } catch (e) {
      debugPrint("Scan error: $e");
      Future.delayed(Duration(seconds: 3), () {
        if (_isScanning && !_hasDetectedCharacter) {
          _startContinuousScan();
        }
      });
    }
  }

  void stopScanning() {
    _isScanning = false;
    _hasDetectedCharacter = false;
    _scanSubscription?.cancel();
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      debugPrint("Error stopping scan: $e");
    }
    debugPrint("Stopped scanning for beacons.");
  }
  
  void resetDetection() {
    _hasDetectedCharacter = false;
    _detectedDevices.clear();

    if (_isScanning) {
      _startContinuousScan();
    }
  }
}