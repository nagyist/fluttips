import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/theme/app_theme.dart';
import 'package:flutter_template/ui/home/drawer.dart';

import 'package:flutter_template/ui/common/fab.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var hideFab = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: HomeNavOptions.values.map((e) => e.route).toList(),
      builder: (context, child, tabsController) {
        return Scaffold(
          onDrawerChanged: (stateDrawer) => setState(() {
            hideFab = stateDrawer;
          }),
          extendBody: true,
          extendBodyBehindAppBar: true,
          key: _scaffoldKey,
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: buildFab(context),
          backgroundColor: context.theme.colors.background,
          body: SafeArea(child: child),
          drawer: AppDrawer(
            tabsController: AutoTabsRouter.of(context),
            action: () => _scaffoldKey.currentState!.closeDrawer(),
          ),
        );
      },
    );
  }

  Widget buildFab(BuildContext context) {
    return Visibility(
      visible: !hideFab,
      child: Fab(
        state: FabState.notSelected(),
        iconNotSelected: Icons.arrow_forward_ios,
        action: () => _scaffoldKey.currentState!.openDrawer(),
      ),
    );
  }
}
