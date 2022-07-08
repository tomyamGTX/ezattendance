import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final key = GlobalKey();
  String textdata = 'Schedule Name';
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            title: Text(textdata),
            subtitle: const Text('Schedule Time'),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  Flexible(
                    child: IconButton(
                        onPressed: () {
                          //   Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextField(
                          //     onChanged: (value) {
                          //       setState(() {});
                          //       textdata = value;
                          //     },
                          //   ),
                          // ),
                        },
                        icon: Icon(Icons.edit)),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text('QR Code for $textdata'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Back')),
                                  if (textdata != '')
                                    ElevatedButton(
                                      child: const Text('Share'),
                                      onPressed: () async {
                                        try {
                                          RenderRepaintBoundary boundary = key
                                                  .currentContext!
                                                  .findRenderObject()
                                              as RenderRepaintBoundary;
//captures qr image
                                          var image = await boundary.toImage();

                                          ByteData? byteData =
                                              await image.toByteData(
                                                  format: ImageByteFormat.png);

                                          Uint8List pngBytes =
                                              byteData!.buffer.asUint8List();
//app directory for storing images.
                                          final appDir =
                                              await getApplicationDocumentsDirectory();
//current time
                                          var datetime = DateTime.now();
//qr image file creation
                                          file = await File(
                                                  '${appDir.path}/$datetime.png')
                                              .create();
//appending data
                                          await file?.writeAsBytes(pngBytes);
//Shares QR image
                                          await Share.shareFiles(
                                            [file!.path],
                                            mimeTypes: ["image/png"],
                                            text:
                                                "Scan the QR Code for attendance",
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(e.toString())));
                                        }
                                      },
                                    )
                                ],
                                content: textdata != ''
                                    ? SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: Center(
                                          child: RepaintBoundary(
                                            key: key,
                                            child: Container(
                                              color: Colors.white,
                                              child: QrImage(
                                                size:
                                                    200, //size of the QrImage widget.
                                                data:
                                                    textdata, //textdata used to create QR code
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Text('No Data'));
                          },
                        );
                      },
                      icon: const Icon(Icons.qr_code),
                    ),
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
