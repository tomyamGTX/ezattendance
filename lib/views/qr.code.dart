import 'dart:async';

import 'package:ez_attendance/views/qrcode.reader.view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _flashlightState = false;
  bool _showScanView = false;
  QrReaderViewController? _controller;

  @override
  void initState() {
    super.initState();
  }

  void alert(String tip) {
    ScaffoldMessenger.of(scaffoldKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(tip)));
  }

  Future<void> openScanUI(BuildContext context) async {
    if (_showScanView) {
      await stopScan();
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return MaterialApp(
          home: Scaffold(
            body: QrcodeReaderView(
              onScan: (result) async {
                Navigator.of(context).pop();
                alert(result);
              },
              headerWidget: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
          ),
        );
      }));
    });
  }

  Future<bool> permission() async {
    if (_openAction) return false;
    _openAction = true;
    var status = await Permission.camera.status;
    if (kDebugMode) {
      print(status);
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.camera.request();
      if (kDebugMode) {
        print(status);
      }
    }

    if (status.isRestricted) {
      alert("Please authorize camera permission");
      await Future.delayed(const Duration(seconds: 3));
      openAppSettings();
      _openAction = false;
      return false;
    }

    if (!status.isGranted) {
      alert("Please authorize camera permission");
      _openAction = false;
      return false;
    }
    _openAction = false;
    return true;
  }

  bool _openAction = false;

  Future openScan(BuildContext context) async {
    if (false == await permission()) {
      return;
    }

    setState(() {
      _showScanView = true;
    });
  }

  Future startScan() async {
    assert(_controller != null);
    _controller?.startCamera((String result, _) async {
      await stopScan();
      RegExp exp =
          RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      Iterable<RegExpMatch> matches = exp.allMatches(result);
      showDialog(
          context: scaffoldKey.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: const Text('Scanning result'),
              content: matches.isEmpty
                  ? Text(result)
                  : Text('Navigate to $result ?'),
              actions: [
                matches.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          for (var match in matches) {
                            launchUrl(Uri.parse(
                                result.substring(match.start, match.end)));
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'))
                    : Container(),
                matches.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'))
                    : Container()
              ],
            );
          });
    });
  }

  Future stopScan() async {
    assert(_controller != null);
    await _controller?.stopCamera();
    setState(() {
      _showScanView = false;
    });
  }

  Future flashlight() async {
    assert(_controller != null);
    final state = await _controller?.setFlashlight();
    setState(() {
      _flashlightState = state ?? false;
    });
  }

  Future imgScan() async {
    await stopScan();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final rest = await FlutterQrReader.imgScan(image.path);
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(rest);
    showDialog(
      context: scaffoldKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scanning result'),
          content: matches.isEmpty ? Text(rest) : Text('Navigate to $rest ?'),
          actions: [
            matches.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      for (var match in matches) {
                        launchUrl(
                            Uri.parse(rest.substring(match.start, match.end)));
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'))
                : Container(),
            matches.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'))
                : Container()
          ],
        ).build(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Builder(builder: (context) {
        return Column(
          children: [
            _showScanView == false
                ? Container()
                : const SizedBox(
                    height: 350,
                  ),
            TextButton(
                onPressed: () => openScanUI(context),
                child: const Text('Open the scan interface')),
            TextButton(
              onPressed: imgScan,
              child: const Text("Identify pictures"),
            ),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 12),
              color: Theme.of(context).primaryColorLight,
            ),
            _showScanView == false
                ? TextButton(
                    onPressed: () => openScan(context),
                    child: const Text('Start scan view'))
                : const Text('Scan view has been activated'),
            TextButton(
                onPressed: flashlight,
                child: Text(_flashlightState == false
                    ? 'Turn on the flashlight'
                    : 'Turn off the flashlight')),
            _showScanView == true
                ? Flexible(
                    child: QrReaderView(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      callback: (container) {
                        _controller = container;
                        startScan();
                      },
                    ),
                  )
                : Container()
          ],
        );
      }),
    );
  }
}
