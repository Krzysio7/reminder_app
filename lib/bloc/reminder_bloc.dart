import 'dart:async';

import 'package:taskreminderapp/models/remind.dart';
import 'package:taskreminderapp/utils/db_provider.dart';

class RemindersBloc {
  RemindersBloc() {
    getReminders();
  }

  final _reminderController = StreamController<List<Remind>>.broadcast();

  get reminders => _reminderController.stream;

  dispose() {
    _reminderController.close();
  }

  getReminders() async {
    _reminderController.sink.add(await DBProvider.db.getAllReminds());
  }

  delete(int id) {
    DBProvider.db.deleteRemind(id);
    getReminders();
  }

  add(Remind remind) {
    DBProvider.db.addRemind(remind);
    getReminders();
  }

  update(Remind remind) {
    DBProvider.db.updateRemind(remind);
    getReminders();
  }
}
