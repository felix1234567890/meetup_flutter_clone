import 'package:flutter/material.dart';
import 'package:meetup/src/blocks/block_provider.dart';
import 'package:meetup/src/blocks/meetup_bloc.dart';
import 'package:meetup/src/models/meetup.dart';
import 'package:meetup/src/services/auth_api_service.dart';
import 'package:meetup/src/services/meetup_api_service.dart';
import 'package:meetup/src/widgets/botom_navigation.dart';

class MeetupDetailScreen extends StatefulWidget {
  final MeetupApiService api = MeetupApiService();
  static final String route = '/meetupDetail';
  final String meetupId;
  MeetupDetailScreen({this.meetupId});

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<MeetupBloc>(context).fetchMeetup(widget.meetupId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder<Meetup>(
        stream: BlocProvider.of<MeetupBloc>(context).meetup,
        builder: (BuildContext context, AsyncSnapshot<Meetup> snapshot) {
          if (snapshot.hasData) {
            final meetup = snapshot.data;
            return ListView(
              children: <Widget>[
                HeaderSection(meetup),
                TitleSection(meetup),
                AdditionalInfoSection(meetup),
                Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(meetup.description),
                  ),
                ),
              ],
            );
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        },
      ),
      appBar: AppBar(
        title: Text('Meetup Detail'),
      ),
      floatingActionButton: _MeetupActionButton(),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class _MeetupActionButton extends StatelessWidget {
  final AuthApiService _auth = AuthApiService();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<bool>(
      future: _auth.isAuthenticated(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final isMember = true;
        if (snapshot.hasData && snapshot.data) {
          if (isMember) {
            return FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.cancel),
              backgroundColor: Colors.red,
              tooltip: 'Leave meetup',
            );
          } else {
            return FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.person_add),
              backgroundColor: Colors.green,
              tooltip: 'Join meetup',
            );
          }
        } else {
          return Container(
            width: 0,
            height: 0,
          );
        }
      },
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Meetup meetup;
  HeaderSection(this.meetup);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Image.network(
          meetup.image,
          width: width,
          height: 240.0,
          fit: BoxFit.cover,
        ),
        Container(
            width: width,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      'https://cdn1.vectorstock.com/i/thumb-large/82/55/anonymous-user-circle-icon-vector-18958255.jpg'),
                ),
                title: Text(meetup.title,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                subtitle: Text(
                  meetup.shortInfo,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ))
      ],
    );
  }
}

class TitleSection extends StatelessWidget {
  final Meetup meetup;
  TitleSection(this.meetup);
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.all(30.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    meetup.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    meetup.shortInfo,
                    style: TextStyle(color: color),
                  )
                ],
              ),
            ),
            Icon(
              Icons.people,
              color: Colors.blue[500],
            ),
            Text('${meetup.joinedPeopleCount} people')
          ],
        ));
  }
}

class AdditionalInfoSection extends StatelessWidget {
  final Meetup meetup;
  AdditionalInfoSection(this.meetup);
  _capitalize(String word) {
    if (word != null && word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    }
    return '';
  }

  _buildColumn(String label, String text, Color color) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 13.0, fontWeight: FontWeight.w400, color: color),
        ),
        Text(_capitalize(text),
            style: TextStyle(
                fontSize: 25.0, fontWeight: FontWeight.w500, color: color))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildColumn('CATEGORY', (meetup.category.name), color),
        _buildColumn('FROM', meetup.timeFrom, color),
        _buildColumn('TO', meetup.timeTo, color)
      ],
    );
  }
}
