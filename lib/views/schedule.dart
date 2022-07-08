import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var _qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Convert Text to QR Code',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        label: Text('Insert Text'), border: InputBorder.none),
                    onChanged: (value) {
                      setState(() {});
                      _qrText = value;
                    },
                  ),
                ),
              ),
              if (_qrText != '')
                QrImage(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  data: _qrText,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
