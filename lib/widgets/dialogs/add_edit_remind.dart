import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:taskreminderapp/config/strings.dart';
import 'package:taskreminderapp/config/text_styles.dart';
import 'package:taskreminderapp/models/remind.dart';
import 'package:taskreminderapp/utils/db_provider.dart';
import 'package:taskreminderapp/utils/validators.dart';

class AddEdit extends StatefulWidget {
  final bool edit;
  final Remind remindObject;

  AddEdit({
    this.edit,
    this.remindObject,
  });

  @override
  _AddEditState createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _enabledState = true;

  void handleSaveRemind(String title, String description, bool enabled) async {
    if (_formKey.currentState.validate()) {
      if (widget.edit) {
        await DBProvider.db.updateRemind(
          Remind(
            id: widget.remindObject.id,
            title: title,
            description: description,
            enabled: enabled,
          ),
        );
      } else {
        await DBProvider.db.addRemind(
          Remind(
            title: title,
            description: description,
            enabled: enabled,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    Remind remind = widget.remindObject;
    if (widget.edit) {
      _titleEditingController.text = remind.title;
      _descriptionEditingController.text = remind.description;
      _enabledState = remind.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Icon(
                Icons.alarm,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 50.0),
                child: OutlinedTextInput(
                  validator: (String title) =>
                      Validators.titleValid(context, title),
                  text: Strings.enterRemindTitle,
                  controller: _titleEditingController,
                ),
              ),
              OutlinedTextInput(
                validator: (String description) =>
                    Validators.descriptionValid(context, description),
                text: Strings.enterRemindDescription,
                controller: _descriptionEditingController,
              ),
              Visibility(
                visible: widget.edit,
                child: CheckboxListTile(
                  title: Text(
                    FlutterI18n.translate(context, Strings.enabled),
                  ),
                  value: _enabledState,
                  onChanged: (bool value) {
                    setState(() {
                      _enabledState = value;
                    });
                  },
                  secondary: const Icon(
                    Icons.add_alert,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    Strings.chooseDate,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          Duration(days: 365),
                        ),
                      );
                      print(pickedDate.toString());
                    },
                  ),
                  Text(
                    Strings.chooseTime,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      TimeOfDay pickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 20.0),
                child: Container(
                  height: 100,
                  width: 200,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () => handleSaveRemind(
                      _titleEditingController.text,
                      _descriptionEditingController.text,
                      _enabledState,
                    ),
                    child: Text(
                      FlutterI18n.translate(
                        context,
                        Strings.save,
                      ),
                      style: TextStyles.buttonText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutlinedTextInput extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final Function(String) validator;

  OutlinedTextInput({
    @required this.text,
    @required this.controller,
    @required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        hintText: FlutterI18n.translate(
          context,
          FlutterI18n.translate(context, text),
        ),
        labelText: FlutterI18n.translate(
          context,
          FlutterI18n.translate(context, text),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.zero,
        ),
      ),
      style: TextStyles.textField,
    );
  }
}
