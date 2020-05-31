import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskreminderapp/bloc/reminder_bloc.dart';
import 'package:taskreminderapp/config/assets.dart';
import 'package:taskreminderapp/models/remind.dart';
import 'package:taskreminderapp/widgets/dialogs/add_edit_remind.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final bloc = RemindersBloc();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder<List<Remind>>(
          stream: bloc.reminders,
          builder:
              (BuildContext context, AsyncSnapshot<List<Remind>> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Remind item = snapshot.data[index];
                  return ListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(fontSize: 40.0),
                    ),
                    subtitle: Text(
                      item.description,
                      style: TextStyle(fontSize: 40.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Text(
                      item.id.toString(),
                      style: TextStyle(fontSize: 40.0),
                    ),
                    trailing: GestureDetector(
                      onTap: () => bloc.delete(item.id),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            Assets.trash,
                            width: 50.0,
                            height: 50.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
//                trailing: Checkbox(
//                  onChanged: (bool value) {
//                    DBProvider.db.blockClient(item);
//                    setState(() {});
//                  },
//                  value: item.blocked,
//                ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => AddEdit(
                          remindBloc: bloc,
                          edit: true,
                          remindObject: item,
                        ),
                      );
                      setState(() {});
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 2.0,
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Positioned(
          right: 25,
          bottom: 25,
          child: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(35.0),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(35.0),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AddEdit(
                      remindBloc: bloc,
                      edit: false,
                    ),
                  );
                  setState(() {});
                },
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
