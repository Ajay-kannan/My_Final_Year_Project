import 'package:flutter/material.dart';
import 'package:plantify/Pages/account.dart';
import 'package:plantify/Pages/chat-bot.dart';
import 'package:plantify/Pages/chat-history.dart';
import 'package:plantify/Pages/disease-detect.dart';
import 'package:plantify/Pages/my-plants.dart';
import 'package:plantify/Provider/auth.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home>{
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
         const ChatBot(),
         const ChatHistory(),
        const DiseaseDetect(),
        const MyPlant(),
        const Account(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems(){
      return [

        PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat),
          title: ("Chat"),
          activeColorPrimary: Color(0xff00a86b),
          inactiveColorPrimary: Colors.grey,
        ), PersistentBottomNavBarItem(
          icon: const Icon(Icons.history),
          title: ("History"),
          activeColorPrimary: Color(0xff00a86b),
          inactiveColorPrimary: Colors.grey,
        ),

        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.white,
          ),
          inactiveIcon: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
          activeColorPrimary: Color(0xff00a86b),
          inactiveColorPrimary: Colors.grey,
        ),

        PersistentBottomNavBarItem(
          icon: const Icon(Icons.add_chart),
          title: ("My Plant"),
          activeColorPrimary: Color(0xff00a86b),
          inactiveColorPrimary: Colors.grey,
        ),PersistentBottomNavBarItem(
          icon: const Icon(Icons.account_box),
          title: ("Account"),
          activeColorPrimary: Color(0xff00a86b),
          inactiveColorPrimary: Colors.grey,
        ),

      ];


    }

    return PersistentTabView(
      context,
      screens:_buildScreens(),
      items: _navBarsItems(),
      controller: Provider.of<ThemeProvider>(context , listen: false).controller ,
      confineInSafeArea: true,
      backgroundColor: Color(0xff181a20),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Color(0xff181a20),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
      NavBarStyle.style16,


    );
  }
}

//