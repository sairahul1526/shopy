import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

class SingleScanActivity extends StatefulWidget {
  SingleScanActivity();
  @override
  State<StatefulWidget> createState() {
    return new SingleScanActivityState();
  }
}

class SingleScanActivityState extends State<SingleScanActivity> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool scanned = false;

  @override
  void initState() {
    super.initState();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData != null && scanData.length > 0 && !scanned) {
        scanned = true;
        if (scanned) {
          Navigator.pop(context, scanData);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: new QrScannerOverlayShape(),
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                margin: EdgeInsets.only(bottom: 20),
                child: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("Cancel"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
