import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:date_o_matic/ui/debug_page/debug_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page that shows log messages
class DebugPage extends StatelessWidget {
  final DebugPageViewModel _viewModel = DebugPageViewModel();

  /// The title that is shown in the app bar
  final String title;

  /// Creates an instance of this class
  DebugPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<DebugPageViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
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
                          child: Text(DateOMaticLocalizations.of(context)!
                              .startAdvertising)),
                      TextButton(
                          onPressed: () => viewModel.stopAdvertising(),
                          child: Text(DateOMaticLocalizations.of(context)!
                              .stopAdvertising)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          onPressed: () => viewModel.startDiscovery(),
                          child: Text(DateOMaticLocalizations.of(context)!
                              .startDiscovery)),
                      TextButton(
                          onPressed: () => viewModel.stopDiscovery(),
                          child: Text(DateOMaticLocalizations.of(context)!
                              .stopDiscovery)),
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
