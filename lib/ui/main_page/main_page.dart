import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:date_o_matic/ui/debug_page/log_page.dart';
import 'package:date_o_matic/ui/search_profile/search_profile_list_page.dart';
import 'package:date_o_matic/ui/user_profile/user_profile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:date_o_matic/ui/main_page/main_page_view_model.dart';
import 'package:provider/provider.dart';

/// The main page of this application
class MainPage extends StatefulWidget {
  /// Creates an instance of this class
  const MainPage({super.key, required this.title});

  /// The title that is shown in the app bar
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final MainPageViewModel _viewModel = MainPageViewModel();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Animation Controller initialisieren
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Eine Pulswelle dauert 1 Sekunde
    )..repeat(
        reverse: true); // Wiederholt die Animation hin und her (pulsierend)

    // 2. Animation für die Skalierung (Pulsieren) von 1.0 zu 1.1 erstellen
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Wichtig: Animation Controller entsorgen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: if no profiles added yet, take other route and let the user create profiles first
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<MainPageViewModel>(
        builder: (context, viewModel, child) {
          DateOMaticLocalizations localizations =
              DateOMaticLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        viewModel.discoveredProfiles
                            .map((profile) => profile.toString())
                            .join('\n\n'),
                        maxLines: null,
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
                    icon: const Icon(Icons.home), label: localizations.home),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.bug_report),
                    label: localizations.debug),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    label: localizations.myProfile),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.person_search),
                    label: localizations.profiles),
              ],
              onTap: (value) {
                switch (value) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(
                                  title: localizations.mainPageTitle,
                                )));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LogPage(title: localizations.debugPageTitle)));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileEditPage(
                                initialProfile: viewModel.userProfile,
                                onSave: (updatedProfile) {
                                  viewModel.updateUserProfile(updatedProfile);
                                  Navigator.of(context).pop();
                                })));
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchProfileListPage()));
                    break;
                  default:
                }
              },
            ),
            floatingActionButton: viewModel.isOnline
                ? ScaleTransition(
                    scale: _pulseAnimation,
                    child: _buildFloatingActionButton(viewModel, localizations),
                  )
                : _buildFloatingActionButton(viewModel, localizations),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(
      MainPageViewModel viewModel, DateOMaticLocalizations localizations) {
    return SizedBox(
      width: 72.0,
      height: 72.0,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          viewModel.toggleOnline();
        },
        tooltip: localizations.toggleOnlineOfflineTooltip,
        child: Icon(
          Icons.favorite,
          size: 36,
          color: viewModel.isOnline ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}
