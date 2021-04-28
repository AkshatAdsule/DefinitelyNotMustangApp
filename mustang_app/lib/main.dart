import 'package:flutter/material.dart';
import 'package:mustang_app/backend/setup_service.dart';
import 'package:mustang_app/backend/auth_service.dart';
import 'exports/pages.dart';
import 'utils/orientation_helpers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SetupService.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _observer = NavigatorObserverWithOrientation();

  // AuthService _AuthService = AuthService();

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
      // case Calendar.route:
      //   return MaterialPageRoute(
      //     builder: (context) => Calendar(),
      //     settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
      //   );
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
            offenseOnRightSide: args['offenseOnRightSide'],
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
      case WrittenAnalysisDisplay.route:
        return MaterialPageRoute(
          builder: (context) => WrittenAnalysisDisplay(
            teamNumber: args['teamNumber'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case SketchPage.route:
        return MaterialPageRoute(
          builder: (context) => SketchPage(),
          settings: rotationSettings(settings, ScreenOrientation.landscapeOnly),
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
            offenseOnRightSide: args['offenseOnRightSide'],
            teamNumber: args['teamNumber'],
            matchNumber: args['matchNumber'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.landscapeOnly),
        );
      case InputScreen.route:
        return MaterialPageRoute(builder: (context) => InputScreen());
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<User>.value(
        //   value: FirebaseAuth.instance.authStateChanges(),
        // ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Mustang App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        initialRoute: Splash.route,
        navigatorObservers: [_observer],
        onGenerateRoute: (settings) => _onGenerateRoute(settings),
      ),
    );
  }
}
