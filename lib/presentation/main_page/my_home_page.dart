import 'package:date_o_matic/services/bt_advertising_service.dart';
import 'package:date_o_matic/services/bt_discovery_service.dart';
import 'package:flutter/material.dart';

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
  final _advertisingService = BtAdvertisingService();
  final _discoveryService = BtDiscoveryService();

  @override
  void dispose() {
    _advertisingService.dispose();
    _discoveryService.dispose();
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
