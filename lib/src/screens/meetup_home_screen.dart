import 'package:flutter/material.dart';
import 'package:meetup/src/blocks/block_provider.dart';
import 'package:meetup/src/blocks/meetup_bloc.dart';
import 'package:meetup/src/models/meetup.dart';
import 'package:meetup/src/screens/meetup_detail_screen.dart';
import 'package:meetup/src/services/auth_api_service.dart';

class MeetupDetailArguments {
  final String id;
  MeetupDetailArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  static final String route = '/meetups';

  @override
  MeetupHomeScreenState createState() {
    // TODO: implement createState
    return MeetupHomeScreenState();
  }
}

class MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final meetupBloc = BlocProvider.of<MeetupBloc>(context);
    meetupBloc.fetchMeetups();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(children: [_MeetupTitle(), _MeetupList()]),
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  final AuthApiService auth = AuthApiService();
  Widget _buildUserWelcome() {
    return FutureBuilder<bool>(
      future: auth.isAuthenticated(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          final user = auth.authUser;
          return Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  user.avatar != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        ),
                  Text('Welcome ${user.username}'),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      auth.logout().then((data) =>
                          Navigator.pushNamedAndRemoveUntil(context, '/login',
                              (Route<dynamic> route) => false));
                    },
                    child: Text('Logout',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  )
                ],
              ));
        } else {
          return Container(width: 0, height: 0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Featured meetups',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            _buildUserWelcome()
          ],
        ));
  }
}

class MeetupCard extends StatelessWidget {
  final Meetup meetup;
  MeetupCard({@required this.meetup});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                radius: 25.0, backgroundImage: NetworkImage(meetup.image)),
            title: Text(meetup.title),
            subtitle: Text(meetup.description),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Visit meetup'),
                  onPressed: () {
                    Navigator.pushNamed(context, MeetupDetailScreen.route,
                        arguments: MeetupDetailArguments(id: meetup.id));
                  },
                ),
                FlatButton(
                  child: Text('Favorite'),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MeetupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<List<Meetup>>(
            stream: BlocProvider.of<MeetupBloc>(context).meetups,
            initialData: [],
            builder:
                (BuildContext context, AsyncSnapshot<List<Meetup>> snapshot) {
              var meetups = snapshot.data;
              return ListView.builder(
                itemCount: meetups.length * 2,
                itemBuilder: (BuildContext context, int i) {
                  if (i.isOdd) return Divider();
                  final index = i ~/ 2;
                  return MeetupCard(meetup: meetups[index]);
                },
              );
            }));
  }
}
