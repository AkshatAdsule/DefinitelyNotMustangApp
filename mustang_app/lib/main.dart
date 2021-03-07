import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/user.dart';
import 'package:mustang_app/backend/user_service.dart';
import 'exports/pages.dart';
import 'utils/orientation_helpers.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  final _observer = NavigatorObserverWithOrientation();

  // UserService _userService = UserService();

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments;
    switch (settings.name) {
      case Splash.route:
        return MaterialPageRoute(
          builder: (context) => Splash(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case Login.route:
        return MaterialPageRoute(
          builder: (context) => Login(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case HomePage.route:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case Calendar.route:
        return MaterialPageRoute(
          builder: (context) => Calendar(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case Scouter.route:
        return MaterialPageRoute(
          builder: (context) => Scouter(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case MatchEndScouter.route:
        return MaterialPageRoute(
          builder: (context) => MatchEndScouter(
            teamNumber: args['teamNumber'],
            matchNumber: args['matchNumber'],
            actions: args['actions'],
            allianceColor: args['allianceColor'],
            climbLocation: args['climbLocation'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case PostScouter.route:
        return MaterialPageRoute(
          builder: (context) => PostScouter(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case MapAnalysisDisplay.route:
        return MaterialPageRoute(
          builder: (context) => MapAnalysisDisplay(
            teamNumber: args['teamNumber'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.landscapeOnly),
        );
      case SketchPage.route:
        return MaterialPageRoute(
          builder: (context) => SketchPage(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case SearchPage.route:
        return MaterialPageRoute(
          builder: (context) => SearchPage(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case TeamInfoDisplay.route:
        return MaterialPageRoute(
          builder: (context) => TeamInfoDisplay(teamNumber: args['teamNumber']),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case PitScouter.route:
        return MaterialPageRoute(
          builder: (context) => PitScouter(teamNumber: args['teamNumber']),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case MapScouting.route:
        return MaterialPageRoute(
          builder: (context) => MapScouting(
            allianceColor: args['allianceColor'],
            teamNumber: args['teamNumber'],
            matchNumber: args['matchNumber'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.landscapeOnly),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider<User>.value(
                value: FirebaseAuth.instance.authStateChanges(),
              ),
              Provider<UserService>(
                create: (_) => UserService(),
              ),
            ],
            child: MaterialApp(
              title: 'Mustang App',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home: HomePage(),
              initialRoute: Splash.route,
              navigatorObservers: [_observer],
              onGenerateRoute: (settings) => _onGenerateRoute(settings),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          title: 'Mustang App',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Splash(
            useFirebase: false,
          ),
        );
      },
    );
  }
}
