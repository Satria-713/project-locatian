import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokasi App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _location = "Belum ada lokasi";

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek service
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = "Service lokasi tidak aktif";
      });
      return;
    }

    // Cek izin
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = "Izin lokasi ditolak";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = "Izin lokasi ditolak permanen, ubah di pengaturan";
      });
      return;
    }

    // Ambil posisi
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _location = "Lat: ${pos.latitude}, Lon: ${pos.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lokasi Kamu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_location, textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text("Ambil Lokasi"),
            ),
          ],
        ),
      ),
    );
  }
}
