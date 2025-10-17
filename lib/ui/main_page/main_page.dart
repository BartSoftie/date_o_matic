import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:date_o_matic/ui/debug_page/log_page.dart';
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
                  Expanded(
                    // SingleChildScrollView makes its child scrollable if the content
                    // overflows its available space.
                    child: SingleChildScrollView(
                      // Padding added for better visual spacing of the log text.
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        viewModel.discoveredProfiles
                            .map((profile) => profile.toString())
                            .join('\n\n'),
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
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: DateOMaticLocalizations.of(context)!.home),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.bug_report),
                    label: DateOMaticLocalizations.of(context)!.debug),
              ],
              onTap: (value) {
                switch (value) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(
                                  title: DateOMaticLocalizations.of(context)!
                                      .mainPageTitle,
                                )));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogPage(
                                title: DateOMaticLocalizations.of(context)!
                                    .debugPageTitle)));
                    break;
                  default:
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                viewModel.toggleOnline();
              },
              tooltip: 'Toggle Online/Offline',
              //TODO: change icon based on online/offline state and do some nice animation
              child: Icon(Icons.favorite,
                  color: viewModel.isOnline ? Colors.red : Colors.grey),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
