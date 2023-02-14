import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/model/DrawItem.dart';
import 'package:todo_app_flutter/provider/navigation_provider.dart';

import '../screens/CompletePage.dart';
import '../screens/InCompletePage.dart';
import '../screens/home.dart';

class NavigationDrawerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationProvider>(context);
    final bool isCollapsed = provider.isCollapsed;
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: Color(0xFF1a2f45),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                color: Colors.white12,
                child: buildHeader(isCollapsed),
              ),
              buildList(
                  items: DrawItem.listDrawItem(), isCollapsed: isCollapsed),
              Spacer(),
              buildCollapedIcon(context, isCollapsed),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({required bool isCollapsed, required List<DrawItem> items}) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shrinkWrap: true,
      primary: false,
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];

        return buildMenuItem(
          isCollapsed: isCollapsed,
          text: item.title,
          icon: item.icon,
          onClicked: () => selectItem(context, index),
        );
      },
    );
  }

  void selectItem(BuildContext context, index){
    final navigateTo = (page) => Navigator.of(context).
    push(MaterialPageRoute(builder: (context) => page));
    switch(index){
      case 0:
        navigateTo(Home());
        break;
      case 1:
        navigateTo(CompletedPage());
        break;
      case 2:
        navigateTo(InCompletePage());
    }
  }

  Widget buildMenuItem(
      {required bool isCollapsed,
      required String text,
      required IconData icon,
      VoidCallback? onClicked}) {
    final color = Colors.white;
    final leading = Icon(
      icon,
      color: color,
    );

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              leading: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(
                text,
                style: TextStyle(color: color, fontSize: 16),
              ),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapedIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: isCollapsed ? Alignment.center : Alignment.centerRight,
      margin: isCollapsed ? null : EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);
            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) {
    return isCollapsed
        ? FlutterLogo(
            size: 48,
          )
        : Row(
            children: [
              const SizedBox(width: 24),
              FlutterLogo(size: 48),
              const SizedBox(width: 16),
              Text('Todo App',
                  style: TextStyle(fontSize: 32, color: Colors.white))
            ],
          );
  }
}

