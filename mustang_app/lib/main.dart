import 'package:flutter/material.dart';
import 'package:mustang_app/backend/setup_service.dart';
import 'package:mustang_app/backend/auth_service.dart';
import 'package:mustang_app/components/all_data_display_per_match.dart';
import 'package:mustang_app/pages/all_data_display.dart';
import 'exports/pages.dart';
import 'utils/orientation_helpers.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SetupService.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _observer = NavigatorObserverWithOrientation();
  final GlobalKey<MapScoutingState> mapScoutingKey =
      GlobalKey<MapScoutingState>();
  // AuthService _AuthService = AuthService();

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments;
    Widget nextPage;
    ScreenOrientation orientation;

    switch (settings.name) {
      case Splash.route:
        nextPage = Splash();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case Login.route:
        nextPage = Login();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case HomePage.route:
        nextPage = HomePage();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case Scouter.route:
        nextPage = Scouter();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case MatchEndScouter.route:
        nextPage = MatchEndScouter(
          teamNumber: args['teamNumber'],
          matchNumber: args['matchNumber'],
          actions: args['actions'],
          allianceColor: args['allianceColor'],
          offenseOnRightSide: args['offenseOnRightSide'],
          climbLocation: args['climbLocation'],
          matchType: args['matchType'],
        );
        orientation = ScreenOrientation.portraitOnly;
        break;
      case PostScouter.route:
        nextPage = PostScouter();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case MapAnalysisDisplay.route:
        nextPage = MapAnalysisDisplay(
          teamNumber: args['teamNumber'],
        );
        orientation = ScreenOrientation.landscapeOnly;
        break;
      case WrittenAnalysisDisplay.route:
        nextPage = WrittenAnalysisDisplay(
          teamNumber: args['teamNumber'],
        );
        orientation = ScreenOrientation.portraitOnly;
        break;
      case AllDataDisplayPerMatch.route:
        nextPage = AllDataDisplayPerMatch(
          // analyzer: args['analyzer'],
          teamNumber: args['teamNumber'],
          matchNum: args['matchNum'],
        );
        orientation = ScreenOrientation.portraitOnly;
        break;
      case AllDataDisplay.route:
        nextPage = AllDataDisplay(
          teamNumber: args['teamNumber'],
        );
        orientation = ScreenOrientation.portraitOnly;
        break;
      case SketchPage.route:
        nextPage = SketchPage();
        orientation = ScreenOrientation.landscapeOnly;
        break;
      case SearchPage.route:
        nextPage = SearchPage();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case GlossaryPage.route:
        nextPage = GlossaryPage();
        orientation = ScreenOrientation.portraitOnly;
        break;
      // case TeamInfoDisplay.route:
      //   nextPage = TeamInfoDisplay(teamNumber: args['teamNumber']);
      //   orientation = ScreenOrientation.portraitOnly;
      //   break;
      case PitScouter.route:
        nextPage = PitScouter(teamNumber: args['teamNumber']);
        orientation = ScreenOrientation.portraitOnly;
        break;
      case MapScouting.route:
        nextPage = MapScouting(
          allianceColor: args['allianceColor'],
          offenseOnRightSide: args['offenseOnRightSide'],
          teamNumber: args['teamNumber'],
          matchNumber: args['matchNumber'],
          key: mapScoutingKey,
          matchType: args['matchType'],
        );
        orientation = ScreenOrientation.landscapeOnly;
        break;
      case InputScreen.route:
        nextPage = InputScreen();
        orientation = ScreenOrientation.portraitOnly;
        break;
      default:
        nextPage = HomePage();
        orientation = ScreenOrientation.portraitOnly;
        break;
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      settings: orientation != null
          ? rotationSettings(settings, orientation)
          : settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
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
