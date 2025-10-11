import 'package:date_o_matic/ui/log_page/log_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page that shows log messages
class LogPage extends StatelessWidget {
  final LogPageViewModel _viewModel = LogPageViewModel();

  /// Creates an instance of this class
  LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<LogPageViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Log'),
            ),
            body: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          onPressed: () => viewModel.startAdvertising(),
                          child: const Text('Start Advertising')),
                      TextButton(
                          onPressed: () => viewModel.stopAdvertising(),
                          child: const Text('Stop Advertising')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          onPressed: () => viewModel.startDiscovery(),
                          child: const Text('Start Discovery')),
                      TextButton(
                          onPressed: () => viewModel.stopDiscovery(),
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
                        viewModel.logText,
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
          );
        },
      ),
    );
  }
}
