import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/pages/data-collection-analysis/data_view.dart';
import 'package:mustang_app/pages/onboarding/create_team.dart';
import 'package:mustang_app/pages/onboarding/forgot_password.dart';
import 'package:mustang_app/pages/onboarding/handle_verification.dart';
import 'package:mustang_app/pages/onboarding/join_team.dart';
import 'package:mustang_app/pages/onboarding/register.dart';
import 'package:mustang_app/pages/onboarding/verify_email.dart';
import 'package:mustang_app/pages/profile.dart';
import 'package:mustang_app/services/setup_service.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'pages/pages.dart';
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
  final GlobalKey<MapScoutingState> mapScoutingKey =
      GlobalKey<MapScoutingState>();

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
      case Register.route:
        nextPage = Register(
          method: args['method'],
        );
        orientation = ScreenOrientation.portraitOnly;
        break;
      case HandleVerification.route:
        nextPage = HandleVerification(
          queryParams: args,
        );
        orientation = ScreenOrientation.portraitOnly;
        break;
      case VerifyEmail.route:
        nextPage = VerifyEmail();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case JoinTeam.route:
        nextPage = JoinTeam();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case CreateTeam.route:
        nextPage = CreateTeam();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case ForgotPassword.route:
        nextPage = ForgotPassword();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case Home.route:
        nextPage = Home();
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
      case Glossary.route:
        nextPage = Glossary();
        orientation = ScreenOrientation.portraitOnly;
        break;
      case Profile.route:
        nextPage = Profile();
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
      case DataViewScreen.route:
        nextPage = DataViewScreen();
        orientation = ScreenOrientation.portraitOnly;
        break;
      default:
        nextPage = Home();
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
        StreamProvider<User>.value(
          value: AuthService.onAuthStateChanged(),
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Mustang App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Home(),
        debugShowCheckedModeBanner: false,
        initialRoute: Splash.route,
        navigatorObservers: [_observer],
        onGenerateRoute: (settings) => _onGenerateRoute(settings),
      ),
    );
  }
}
