import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:flutter/material.dart';
import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/user_profile.dart';

/// A StatefulWidget for displaying and editing a [UserProfile].
class UserProfileEditPage extends StatefulWidget {
  /// The initial profile data to be displayed and edited.
  final UserProfile initialProfile;

  /// Callback function called when the user saves the changes.
  final Function(UserProfile) onSave;

  ///
  const UserProfileEditPage({
    super.key,
    required this.initialProfile,
    required this.onSave,
  });

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _age;
  late Gender _gender;
  late double _height;
  late double _weight;
  late String _hobbies;

  @override
  void initState() {
    super.initState();
    _name = widget.initialProfile.name;
    _age = widget.initialProfile.age;
    _gender = widget.initialProfile.gender;
    _height = widget.initialProfile.height;
    _weight = widget.initialProfile.weight;
    _hobbies = widget.initialProfile.hobbies;
  }

  /// Validates the form, updates a new UserProfile object, and calls the onSave callback.
  void _saveForm(DateOMaticLocalizations localizations) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedProfile = UserProfile()
        ..name = _name
        ..age = _age
        ..gender = _gender
        ..height = _height
        ..weight = _weight
        ..hobbies = _hobbies;

      widget.onSave(updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.userProfileEditPageProfileSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DateOMaticLocalizations localizations =
        DateOMaticLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.userProfileEditPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveForm(localizations),
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
              // 👤 Name
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: localizations.labelTextName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.userProfileEditPagePleaseEnterName;
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: _age,
                decoration: InputDecoration(
                  labelText: localizations.labelTextAge,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return localizations.userProfileEditPagePleaseEnterAge;
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = value!;
                },
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<Gender>(
                decoration: InputDecoration(
                  labelText: localizations.labelTextGender,
                  border: OutlineInputBorder(),
                ),
                initialValue: _gender,
                items: Gender.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(getLocalizedGenderName(type, localizations)),
                  );
                }).toList(),
                onChanged: (Gender? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: _height.toString(),
                decoration: InputDecoration(
                  labelText: localizations.labelTextHeight,
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return localizations.userProfileEditPagePleaseEnterHeight;
                  }
                  return null;
                },
                onSaved: (value) {
                  _height = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: _weight.toString(),
                decoration: InputDecoration(
                  //TODO: gewicht und größe: Einheiten auf imperial/metric umstellen je nach einstellung
                  labelText: localizations.labelTextWeight,
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return localizations.userProfileEditPagePleaseEnterWeight;
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: _hobbies,
                decoration: InputDecoration(
                  labelText: localizations.userProfileEditPageHobbies,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                onSaved: (value) {
                  _hobbies = value!;
                },
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _saveForm(localizations),
                  icon: const Icon(Icons.save),
                  label: Text(localizations.userProfileEditPageSaveProfile),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
