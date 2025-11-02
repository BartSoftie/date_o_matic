import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/matched_profile.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:date_o_matic/data/model/user_profile.dart';
import 'package:date_o_matic/ui/chat/chat_page.dart';
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

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            body: ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 80), // To avoid FAB overlapping last item
              itemBuilder: (context, index) {
                var item = viewModel.discoveredProfiles[index];
                return _buildProfileCard(item, localizations);
              },
              itemCount: viewModel.discoveredProfiles.length,
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

  Card _buildProfileCard(
      MatchedProfile item, DateOMaticLocalizations localizations) {
    //TODO: make clear that this is was the other side is searching for
    //not what the other side is
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_search, color: Colors.indigo, size: 28),
                const SizedBox(width: 10),
                //TODO: introdude new type for disovered profiles
                //give them a name as well.
                //make the name editable so the user can give that profile a custom name
                Text(
                  'blah',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            // Chat-Button
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.chat, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                            matchedProfile: item,
                            currentUserId: UserProfile.userId)),
                  );
                },
              ),
            ),
            const Divider(height: 20),
            _buildDetailRow(
              icon: Icons.favorite_border,
              label: 'Beziehungsziel:',
              value: getLocalizedRelationshipTypeName(
                  item.profile.relationshipType, localizations),
            ),
            _buildDetailRow(
              icon: Icons.person_outline,
              label: 'Gesucht wird:',
              value: getLocalizedGenderName(item.profile.gender, localizations),
            ),
            _buildDetailRow(
              icon: Icons.cake_outlined,
              label: 'Altersspanne:',
              value:
                  '${item.profile.bornTill.year} - ${item.profile.bornFrom.year}',
            ),
          ],
        ),
      ),
    );
  }

  /// Helper-Methode zum Bauen einer detaillierten Zeile.
  Widget _buildDetailRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          SizedBox(
            width: 120, // Feste Breite für das Label
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.normal),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
