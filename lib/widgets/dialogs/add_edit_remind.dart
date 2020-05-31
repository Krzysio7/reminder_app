import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:taskreminderapp/bloc/reminder_bloc.dart';
import 'package:taskreminderapp/config/strings.dart';
import 'package:taskreminderapp/config/text_styles.dart';
import 'package:taskreminderapp/models/remind.dart';
import 'package:taskreminderapp/utils/validators.dart';

class AddEdit extends StatefulWidget {
  final bool edit;
  final Remind remindObject;
  final RemindersBloc remindBloc;
  static DateFormat buttonDateFormat = DateFormat('yyyy-MM-dd');

  AddEdit({
    this.edit,
    this.remindBloc,
    this.remindObject,
  });

  @override
  _AddEditState createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  String _date;
  String _time;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _enabledState = true;
  DateTime _dateTime;

  void handleSaveRemind(String title, String description, bool enabled) async {
    print(_date);
    print(_time);

    if (_formKey.currentState.validate()) {
      if (widget.edit) {
        widget.remindBloc.update(
          Remind(
            id: widget.remindObject.id,
            title: title,
            description: description,
            enabled: enabled,
            dateTime: _date + ' ' + _time,
          ),
        );
      } else {
        widget.remindBloc.add(
          Remind(
            title: title,
            description: description,
            enabled: enabled,
            dateTime: _date + ' ' + _time,
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
      _dateTime = DateTime.parse(remind.dateTime);
      _titleEditingController.text = remind.title;
      _descriptionEditingController.text = remind.description;
      _enabledState = remind.enabled;
      _date = AddEdit.buttonDateFormat.format(_dateTime);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _time = TimeOfDay.fromDateTime(_dateTime).format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0.0,
                    50.0,
                    0.0,
                    25.0,
                  ),
                  child: DateTimePickerButtonFormField(
                    initialValue: _dateTime != null
                        ? AddEdit.buttonDateFormat.format(_dateTime)
                        : '',
                    isDate: true,
                    leadingIcon: Icons.date_range,
                    validator: (String date) => Validators.dateValid(
                      context,
                      date,
                    ),
                    onChange: (String date) {
                      _date = date;
                    },
                  ),
                ),
                DateTimePickerButtonFormField(
                  initialValue: _dateTime != null
                      ? TimeOfDay.fromDateTime(_dateTime).format(context)
                      : '',
                  isDate: false,
                  leadingIcon: Icons.alarm,
                  validator: (String date) => Validators.timeValid(
                    context,
                    date,
                  ),
                  onChange: (String time) {
                    _time = time;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 20.0),
                  child: Container(
                    height: 100,
                    width: 250,
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
        errorStyle: TextStyle(
          fontSize: 20.0,
        ),
      ),
      style: TextStyles.textField,
    );
  }
}

class DateTimePickerButton extends StatefulWidget {
  final IconData leadingIcon;
  final Function(String) onChange;
  final bool hasError;
  final String errorText;
  final EdgeInsets margin;
  final bool isDate;
  final String initialValue;

  DateTimePickerButton({
    this.leadingIcon,
    this.onChange,
    this.errorText,
    this.hasError,
    this.margin,
    this.isDate,
    this.initialValue,
  });

  @override
  _DateTimePickerButtonState createState() => _DateTimePickerButtonState();
}

class _DateTimePickerButtonState extends State<DateTimePickerButton> {
  String _dateTime = '-';

  Future<DateTime> pickDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 365),
      ),
    );
  }

  Future<TimeOfDay> pickTime() {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  @override
  void initState() {
    super.initState();
    _dateTime = widget.initialValue.isNotEmpty ? widget.initialValue : '-';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: widget.margin ?? const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(
                4.0,
              ),
            ),
            border: Border.all(
              width: 1,
              color: widget.hasError != null && widget.hasError
                  ? Theme.of(context).errorColor
                  : Theme.of(context).backgroundColor,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      widget.leadingIcon,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      _dateTime,
                      style: TextStyles.textField,
                    ),
                    Spacer(),
                    Text(
                      FlutterI18n.translate(
                        context,
                        Strings.change,
                      ),
                      style: TextStyles.textField,
                    ),
                  ],
                ),
              ),
              onTap: () async {
                final pickedDateTime =
                    widget.isDate ? await pickDate() : await pickTime();
                if (pickedDateTime != null) {
                  setState(() {
                    if (pickedDateTime is TimeOfDay) {
                      _dateTime = pickedDateTime.format(context);
                    } else if (pickedDateTime is DateTime) {
                      _dateTime =
                          AddEdit.buttonDateFormat.format(pickedDateTime);
                    }
                  });
                  widget.onChange(_dateTime);
                }
              },
            ),
          ),
        ),
        widget.hasError != null && widget.hasError
            ? Padding(
                padding: const EdgeInsets.fromLTRB(13, 8, 0, 0),
                child: Text(
                  widget.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontSize: 20.0,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class DateTimePickerButtonFormField extends FormField<String> {
  DateTimePickerButtonFormField({
    Key key,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    Function(String) onChange,
    IconData leadingIcon,
    bool isDate,
    String initialValue = '',
    bool autoValidate = false,
    FormFieldBuilder<bool> builder,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autoValidate,
          builder: builder ??
              (FormFieldState<String> state) => _builder(
                    state,
                    onChange,
                    leadingIcon,
                    isDate,
                    initialValue,
                  ),
        );

  static Widget _builder(
    FormFieldState<String> state,
    Function(String) onChanged,
    leadingIcon,
    isDate,
    initialValue,
  ) {
    return DateTimePickerButton(
      leadingIcon: leadingIcon,
      isDate: isDate,
      hasError: state.hasError,
      errorText: state.errorText,
      initialValue: initialValue,
      onChange: (String value) {
        state.didChange(value);
        if (onChanged != null) onChanged(value);
      },
    );
  }
}
