import 'package:flutter/material.dart';
import 'exports/pages.dart';
import 'utils/orientation_helpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final _observer = NavigatorObserverWithOrientation();

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments;
    switch(settings.name) {
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
      case AutonScouter.route:
        return MaterialPageRoute(
          builder: (context) => AutonScouter(
            teamNumber: args['teamNumber'],
            matchNumber: args['matchNumber'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case TeleopScouter.route:
        return MaterialPageRoute(
          builder: (context) => TeleopScouter(
            teamNumber: args['teamNumber'],
            matchNumber: args['matchNumber'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case EndgameScouter.route:
        return MaterialPageRoute(
          builder: (context) => EndgameScouter(
            teamNumber: args['teamNumber'],
            matchNumber: args['matchNumber'],
          ),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case MatchEndScouter.route:
        return MaterialPageRoute(
          builder: (context) => MatchEndScouter(
            teamNumber: args['teamNumber'],
            matchNumber: args['matchNumber'],
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
          builder: (context) => MapScouting(),
          settings: rotationSettings(settings, ScreenOrientation.landscapeOnly),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mustang App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
      navigatorObservers: [_observer],
      onGenerateRoute: (settings) => _onGenerateRoute(settings),
    );
  }
}
