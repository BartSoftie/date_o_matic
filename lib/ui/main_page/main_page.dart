import 'package:date_o_matic/ui/log_page/log_page.dart';
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
                children: [],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.bug_report), label: 'Debug'),
              ],
              onTap: (value) {
                switch (value) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(
                                  title: 'DateOMatic App',
                                )));
                    break;
                  case 1:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogPage()));
                    break;
                  default:
                }
              },
            ),
          );
        },
      ),
    );
  }
}
