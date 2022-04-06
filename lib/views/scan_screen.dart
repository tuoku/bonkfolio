import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  MobileScannerController? controller;
  bool foundQr = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              key: qrKey,
              allowDuplicates: false,
              controller: controller,
              onDetect: (barcode, args) {
                setState(() {
                  result = barcode;
                });
                if (result != null && !foundQr) {
                  foundQr = true;
                  if (kDebugMode) print(barcode.rawValue);
                  Navigator.of(context).pop(result!.rawValue!.split(":").last);
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.rawValue}')
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
