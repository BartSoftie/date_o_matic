import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:date_o_matic/ui/debug_page/log_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page that shows log messages
class LogPage extends StatelessWidget {
  final LogPageViewModel _viewModel = LogPageViewModel();

  /// The title that is shown in the app bar
  final String title;

  /// Creates an instance of this class
  LogPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<LogPageViewModel>(
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
                          onPressed: () => viewModel.clearLog(),
                          child: Text(
                              DateOMaticLocalizations.of(context)!.clearLog)),
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
