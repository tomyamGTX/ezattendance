import 'package:flutter/material.dart';

class DetailSchedule extends StatefulWidget {
  final String title;

  const DetailSchedule({required this.title, Key? key}) : super(key: key);

  @override
  State<DetailSchedule> createState() => _DetailScheduleState();
}

class _DetailScheduleState extends State<DetailSchedule> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: TabBar(
                tabs: [Tab(text: 'Today'), Tab(text: 'All Time')],
              ),
            ),
          ),
          body: const TabBarView(children: [
            Center(child: Text('Today')),
            Center(child: Text('All Time')),
          ])),
    );
  }
}
