import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:flutter/material.dart';
import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:date_o_matic/data/model/search_profile.dart';

/// A StatefulWidget for displaying and editing a [SearchProfile].
class SearchProfileEditPage extends StatefulWidget {
  /// The initial profile data to be displayed and edited.
  final SearchProfile initialProfile;

  /// Callback function called when the user saves the changes.
  final Function(SearchProfile) onSave;

  /// Creates an instance of [SearchProfileEditPage].
  const SearchProfileEditPage({
    super.key,
    required this.initialProfile,
    required this.onSave,
  });

  @override
  State<SearchProfileEditPage> createState() => _SearchProfileEditPageState();
}

class _SearchProfileEditPageState extends State<SearchProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late RelationshipType _relationshipType;
  late Gender _gender;
  late DateTime _bornFrom;
  late DateTime _bornTill;

  @override
  void initState() {
    super.initState();
    _name = widget.initialProfile.name;
    _relationshipType = widget.initialProfile.relationshipType;
    _gender = widget.initialProfile.gender;
    _bornFrom = widget.initialProfile.bornFrom;
    _bornTill = widget.initialProfile.bornTill;
  }

  @override
  Widget build(BuildContext context) {
    DateOMaticLocalizations localizations =
        DateOMaticLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.searchProfileEditPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: localizations.searchProfileEditPageProfileName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.searchProfileEditPagePleaseEnterName;
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<RelationshipType>(
                decoration: InputDecoration(
                  labelText: localizations
                      .searchProfileEditPageDesiredRelationshipType,
                  border: OutlineInputBorder(),
                ),
                initialValue: _relationshipType,
                items: RelationshipType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (RelationshipType? newValue) {
                  setState(() {
                    _relationshipType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Gender>(
                decoration: InputDecoration(
                  labelText: localizations.searchProfileEditPageDesiredGender,
                  border: OutlineInputBorder(),
                ),
                initialValue: _gender,
                items: Gender.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Gender? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(localizations.searchProfileEditPageBornFrom,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                title: Text(
                    '${_bornFrom.year}-${_bornFrom.month}-${_bornFrom.day}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              const Divider(),
              Text(localizations.searchProfileEditPageBornTill,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                title: Text(
                    '${_bornTill.year}-${_bornTill.month}-${_bornTill.day}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              const Divider(),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveForm,
                  icon: const Icon(Icons.save),
                  label: Text(localizations.saveChanges),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedProfile = SearchProfile(
        profileId: widget.initialProfile.profileId,
        userId: widget.initialProfile.userId,
        name: _name,
        relationshipType: _relationshipType,
        gender: _gender,
        bornFrom: _bornFrom,
        bornTill: _bornTill,
      );

      widget.onSave(updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isBornFrom) async {
    final DateTime initialDate = isBornFrom ? _bornFrom : _bornTill;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        if (isBornFrom) {
          _bornFrom = picked;
          if (_bornFrom.isAfter(_bornTill)) {
            _bornTill = _bornFrom;
          }
        } else {
          _bornTill = picked;
          if (_bornTill.isBefore(_bornFrom)) {
            _bornFrom = _bornTill;
          }
        }
      });
    }
  }
}
