import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_profile_list_view_model.dart';
import 'search_profile_edit_page.dart';
import 'package:date_o_matic/data/model/search_profile.dart';

/// A StatefulWidget that manages the ViewModel internally and provides it
/// to the widget tree using ChangeNotifierProvider.value.
class SearchProfileListPage extends StatefulWidget {
  /// Creates an instance of [SearchProfileListPage].
  const SearchProfileListPage({super.key});

  @override
  State<SearchProfileListPage> createState() => _SearchProfileListPageState();
}

class _SearchProfileListPageState extends State<SearchProfileListPage> {
  late SearchProfileListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SearchProfileListViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<SearchProfileListViewModel>(
        builder: (context, viewModel, child) {
          DateOMaticLocalizations localizations =
              DateOMaticLocalizations.of(context)!;

          return Scaffold(
            appBar: AppBar(
              title: Text(localizations.searchProfileListPageTitle),
            ),
            body: viewModel.profiles.isEmpty
                ? Center(
                    child: Text(localizations
                        .searchProfileListPageNoSearchProfilesFound))
                : ListView.builder(
                    itemCount: viewModel.profiles.length,
                    itemBuilder: (context, index) {
                      final profile = viewModel.profiles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.person_search,
                              color: Colors.blueGrey),
                          title: Text(
                            profile.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              localizations.searchProfileListPageLookingFor(
                                  profile.gender.name,
                                  profile.relationshipType.name,
                                  profile.bornFrom,
                                  profile.bornTill)),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editProfile(context, profile),
                          ),
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _createNewProfile(context, SearchProfile.createNewProfile());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New profile added.')),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  /// Handles the navigation to the edit page and sets up the onSave callback.
  void _createNewProfile(BuildContext context, SearchProfile profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SearchProfileEditPage(
          initialProfile: profile,
          onSave: (newProfile) {
            Provider.of<SearchProfileListViewModel>(context, listen: false)
                .addProfile(newProfile);
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  /// Handles the navigation to the edit page and sets up the onSave callback.
  void _editProfile(BuildContext context, SearchProfile profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SearchProfileEditPage(
          initialProfile: profile,
          onSave: (updatedProfile) {
            Provider.of<SearchProfileListViewModel>(context, listen: false)
                .updateProfile(updatedProfile);
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }
}
