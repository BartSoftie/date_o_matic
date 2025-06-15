import 'dart:async';

import 'package:date_o_matic/services/bt_advertising_service.dart';
import 'package:date_o_matic/services/bt_discovery_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

//TODO: rename me
/// The main page of this application
class MyHomePage extends StatefulWidget {
  /// Creates an instance of this class
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _log = Logger('BtState');
  late StreamSubscription _streamSubscription;
  final _advertisingService = BtAdvertisingService();
  final _discoveryService = BtDiscoveryService();
  String _logText = '';

  @override
  void initState() {
    Logger.root.level = Level.WARNING;
    _streamSubscription = _log.onRecord.listen((record) => setState(() {
          _logText +=
              '${record.level.name}: ${record.time}: ${record.message}\n';
        }));
    super.initState();
  }

  @override
  void dispose() {
    _advertisingService.dispose();
    _discoveryService.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () => _advertisingService.startAdvertising(),
                    child: const Text('Start Advertising')),
                TextButton(
                    onPressed: () => _advertisingService.stopAdvertising(),
                    child: const Text('Stop Advertising')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () => _discoveryService.startListening(),
                    child: const Text('Start Discovery')),
                TextButton(
                    onPressed: () => _discoveryService.stopListening(),
                    child: const Text('Stop Discovery')),
              ],
            ),
            Expanded(
              // SingleChildScrollView makes its child scrollable if the content
              // overflows its available space.
              child: SingleChildScrollView(
                // Padding added for better visual spacing of the log text.
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _logText,
                  // maxLines: null allows the Text widget to use as many lines
                  // as needed, combined with SingleChildScrollView for scrolling.
                  maxLines: null,
                  // softWrap: true ensures that the text wraps to the next line
                  // instead of overflowing horizontally.
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: const FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
