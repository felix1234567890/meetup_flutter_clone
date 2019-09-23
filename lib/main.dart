import 'package:flutter/material.dart';
import 'package:meetup/src/blocks/auth_bloc/auth_bloc.dart';
import 'package:meetup/src/blocks/block_provider.dart';
import 'package:meetup/src/blocks/meetup_bloc.dart';
import 'package:meetup/src/screens/login_screen.dart';
import 'package:meetup/src/screens/meetup_detail_screen.dart';
import 'package:meetup/src/screens/meetup_home_screen.dart';
import 'package:meetup/src/screens/register_screen.dart';

void main() {
  return runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider<AuthBloc>(
      bloc: AuthBloc(),
      child: MeetupApp(),
    );
  }
}

class MeetupApp extends StatefulWidget {
  @override
  _MeetupAppState createState() => _MeetupAppState();
}

class _MeetupAppState extends State<MeetupApp> {
  final String appTitle = "Meetuper app";

  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        //home: CounterHomeScreen(title: appTitle),
        home: LoginScreen(),
        routes: {
          RegisterScreen.route: (context) => RegisterScreen(),
          MeetupHomeScreen.route: (context) => BlocProvider<MeetupBloc>(
                bloc: MeetupBloc(),
                child: MeetupHomeScreen(),
              )
        },
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == MeetupDetailScreen.route) {
            final MeetupDetailArguments arguments = settings.arguments;

            return MaterialPageRoute(
                builder: (context) => BlocProvider<MeetupBloc>(
                      child: MeetupDetailScreen(
                        meetupId: arguments.id,
                      ),
                      bloc: MeetupBloc(),
                    ));
          }
        });
  }
}
