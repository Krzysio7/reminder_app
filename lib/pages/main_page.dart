import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskreminderapp/app_scaffold.dart';
import 'package:taskreminderapp/config/assets.dart';
import 'package:taskreminderapp/config/strings.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        mainMenuItems.length,
        (index) => ActivityBlock(
          color: mainMenuItems[index].color,
          title: mainMenuItems[index].title,
          imageUrl: mainMenuItems[index].imageUrl,
          route: mainMenuItems[index].route,
        ),
      ),
    );
  }
}

class ActivityBlock extends StatelessWidget {
  final Color color;
  final String title;
  final String imageUrl;
  final String route;

  ActivityBlock({
    this.color,
    this.title,
    this.imageUrl,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  Assets.weather,
                  color: Colors.white,
                  width: 50,
                  height: 50,
                ),
                Text(
                  FlutterI18n.translate(
                    context,
                    title,
                  ),
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
            onTap: () => Navigator.of(context).pushNamed(route),
          ),
        ),
      ),
    );
  }
}

class MainMenuItem {
  final String route;
  final Color color;
  final String title;
  final String imageUrl;

  MainMenuItem({
    this.color,
    this.title,
    this.imageUrl,
    this.route,
  });
}

final List<MainMenuItem> mainMenuItems = <MainMenuItem>[
  MainMenuItem(
    color: Colors.blue,
    title: Strings.weather,
    imageUrl: Assets.weather,
    route: AppRoutes.WEATHER,
  ),
  MainMenuItem(
    color: Colors.redAccent,
    title: Strings.reminder,
    imageUrl: Assets.weather,
    route: AppRoutes.REMINDER,
  ),
];
