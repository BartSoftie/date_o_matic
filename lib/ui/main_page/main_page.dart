import 'package:flutter/material.dart';
import 'package:date_o_matic/ui/main_page/main_page_view_model.dart';
import 'package:provider/provider.dart';

/// The main page of this application
class MainPage extends StatelessWidget {
  final MainPageViewModel _viewModel = MainPageViewModel();

  /// Creates an instance of this class
  MainPage({super.key, required this.title});

  /// The title that is shown in the app bar
  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<MainPageViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(title),
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
            // floatingActionButton: const FloatingActionButton(
            //   onPressed: null,
            //   tooltip: 'Increment',
            //   child: Icon(Icons.add),
            // ),
          );
        },
      ),
    );
  }
}
