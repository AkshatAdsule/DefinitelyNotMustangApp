import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/pages/pages.dart';

class Home extends StatefulWidget {
  static const String route = '/';
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class NavCard extends StatelessWidget {
  final String route, title;
  final IconData icon;

  const NavCard(
      {@required this.route, @required this.title, @required this.icon});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        enableFeedback: true,
      ),
      color: Colors.green,
      borderRadius: BorderRadius.circular(10),
      elevation: 10,
    );
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Home',
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "The Mustang Alliance",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/logo.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Image.asset(
            //     "assets/logo.png",
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: NavCard(
                            route: Scouter.route,
                            title: "Match Scouting",
                            icon: Icons.list,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: NavCard(
                            route: SearchPage.route,
                            title: "Data Analysis",
                            icon: Icons.search,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: NavCard(
                            route: InputScreen.route,
                            title: "Team Analysis",
                            icon: Icons.stacked_line_chart,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: NavCard(
                            route: SketchPage.route,
                            title: "Match Planning",
                            icon: Icons.edit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: GridView.count(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 10,
            //     mainAxisSpacing: 10,
            //     children: const [
            // NavCard(
            //   route: "",
            //   title: "Match Scouting",
            //   icon: Icons.list,
            // ),
            // NavCard(
            //   route: "",
            //   title: "Data Analysis",
            //   icon: Icons.search,
            // ),
            // NavCard(
            //   route: "",
            //   title: "Team Analysis",
            //   icon: Icons.stacked_line_chart,
            // ),
            // NavCard(
            //   route: "",
            //   title: "Match Planing",
            //   icon: Icons.edit,
            // ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
