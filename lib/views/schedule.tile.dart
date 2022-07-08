import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'detail.schedule.dart';

class ScheduleTile extends StatefulWidget {
  const ScheduleTile({Key? key}) : super(key: key);

  @override
  State<ScheduleTile> createState() => _ScheduleTileState();
}

class _ScheduleTileState extends State<ScheduleTile> {
  final key = GlobalKey();
  String textdata = 'Schedule Name';
  var timedata;
  File? file;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).secondaryHeaderColor,
      enabled: true,
      onTap: () => Get.to(DetailSchedule(
        title: textdata,
      )),
      title: Text(textdata),
      subtitle: Text(timedata ?? 'Schedule Time'),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            Flexible(
              child: IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Done'))
                          ],
                          title: const Text('Edit Schedule Attendance'),
                          content: SizedBox(
                            height: 160,
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                padding: const EdgeInsets.all(8),
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                        label: Text('Schedule Name'),
                                        icon: Icon(Icons.text_snippet)),
                                    onChanged: (value) {
                                      setState(() {});
                                      textdata = value;
                                    },
                                  ),
                                  DateTimePicker(
                                    type: DateTimePickerType.time,
                                    //timePickerEntryModeInput: true,
                                    //controller: _controller4,
                                    initialValue: '',
                                    //_initialValue,
                                    icon: const Icon(Icons.access_time),
                                    timeLabelText: "Time",
                                    use24HourFormat: false,
                                    locale: const Locale('en', 'US'),
                                    onChanged: (val) =>
                                        setState(() => timedata = val),
                                    validator: (val) {
                                      setState(() => timedata = val ?? '');
                                      return null;
                                    },
                                    onSaved: (val) =>
                                        setState(() => timedata = val ?? ''),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit)),
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
                                    RenderRepaintBoundary boundary =
                                        key.currentContext!.findRenderObject()
                                            as RenderRepaintBoundary;
//captures qr image
                                    var image = await boundary.toImage();

                                    ByteData? byteData = await image.toByteData(
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
                                      text: "Scan the QR Code for attendance",
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
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
                                          data: jsonEncode({
                                            "name": textdata,
                                            "time": timedata
                                          }), //textdata used to create QR code
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
    );
  }
}
