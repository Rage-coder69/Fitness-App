import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app/components/drawerOption.dart';
import 'package:app/screens/available_workouts_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/statistics_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'explore_screen.dart';
import 'home_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  static String id = '/dashboard';

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _auth = FirebaseAuth.instance;

  int activeIndex = 0;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final _screens = [
    HomeScreen(),
    ExploreScreen(),
    StatisticsScreen(),
    ProfileScreen(),
  ];

  void switchScreen(int index) {
    setState(() {
      _key.currentState!.closeDrawer();
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70.0,
        title: const Text('Pump'),
        titleTextStyle: const TextStyle(
          color: Color(0xFF244A4F),
          fontSize: 30.0,
          fontWeight: FontWeight.w900,
        ),
        /*leadingWidth: 90.0,*/
        leadingWidth: 70.0,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          /*Padding(
              padding: EdgeInsets.only(right: 10.0),
              child:
            ),*/
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: Colors.grey[400],
            ),
          ),
        ],
        leading: RawMaterialButton(
          shape: const CircleBorder(),
          constraints: const BoxConstraints.tightFor(
            width: 20.0,
            height: 20.0,
          ),
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          child: CircleAvatar(
            backgroundColor: Color(0xE8184045),
            child: Text(
              'H',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      drawer: Drawer(
          /*backgroundColor: Color(0xFF184045),*/
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Color(0xE8184045),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/drawerImage.png'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Text(
                        'Pump',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    DrawerOption(
                      text: 'Home',
                      icon: CupertinoIcons.house,
                      onTap: () {
                        switchScreen(0);
                      },
                    ),
                    DrawerOption(
                      text: 'Explore',
                      icon: CupertinoIcons.search,
                      onTap: () {
                        switchScreen(1);
                      },
                    ),
                    DrawerOption(
                      text: 'Statistics',
                      icon: CupertinoIcons.chart_bar_square,
                      onTap: () {
                        switchScreen(2);
                      },
                    ),
                    DrawerOption(
                      text: 'Profile',
                      icon: CupertinoIcons.person,
                      onTap: () {
                        switchScreen(3);
                      },
                    ),
                    DrawerOption(
                      text: 'Logout',
                      icon: Icons.logout_rounded,
                      onTap: () {
                        // Update the state of the app.
                        _auth.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            ModalRoute.withName(HomeScreen.id));
                      },
                    ),
                    /*ListTile(
                      textColor: Color(0xFF184045),
                      leading: Icon(
                        Icons.logout_rounded,
                        color: Color(0xFF184045),
                      ),
                      title: const Text('Logout'),
                      onTap: () {
                        // Update the state of the app.
                        _auth.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            ModalRoute.withName(HomeScreen.id));
                      },
                    )*/
                  ],
                ),
              ),
            ],
          )),
      body: _screens[activeIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xE8184045),
        elevation: 4.0,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () {
          Navigator.pushNamed(context, AvailableWorkouts.id);
        },
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Color(0xFF244A4F),
        inactiveColor: Colors.grey[400],
        icons: [
          CupertinoIcons.house_fill,
          CupertinoIcons.compass,
          CupertinoIcons.chart_bar_square,
          CupertinoIcons.person,
        ],
        activeIndex: activeIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.sharpEdge,
        notchMargin: 20.0,
        gapWidth: 90.0,
        height: 65.0,
        elevation: 0.0,
        leftCornerRadius: 0.0,
        rightCornerRadius: 0.0,
        onTap: (index) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
    );
  }
}

/*ListView(
          children: [
            ListTile(
              /*contentPadding: EdgeInsets.only(left: 20.0),
                tileColor: Color(0xFFFFFFFF),
                textColor: Color(0xFF184045),*/
              title: const Text('Logout'),
              onTap: () {
                // Update the state of the app.
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    ModalRoute.withName(HomeScreen.id));
              },
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                setState(() {
                  activeIndex = 0;
                });
              },
            ),
          ],
        ),*/

//similar design to the floating action button
/*
* Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF184045),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),*/

/*BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 15.0,
          elevation: 0.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        )*/
