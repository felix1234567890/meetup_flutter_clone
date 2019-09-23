import 'package:flutter/material.dart';
import 'package:meetup/src/models/Post.dart';
import 'package:meetup/src/scoped_model/post_model.dart';
import 'package:meetup/src/state/app_state.dart';
import 'package:meetup/src/widgets/botom_navigation.dart';
import 'package:scoped_model/scoped_model.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() {
    return _PostScreenState();
  }
}

class _PostScreenState extends State<PostScreen> {
  Widget build(BuildContext context) {
    return ScopedModel<PostModel>(
      model: PostModel(),
      child: _PostList(),
    );
  }
}

class _InheritedPost extends InheritedWidget {
  final Widget child;
  final List<Post> posts;
  final Function createPost;
  _InheritedPost(
      {@required this.child, @required this.posts, @required this.createPost})
      : super(child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static _InheritedPost of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedPost)
        as _InheritedPost);
  }
}

class _PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final posts = _InheritedPost.of(context).posts;
    // final testingData = AppStore.of(context).testingData;
    return ScopedModelDescendant<PostModel>(
      builder: (context, _, model) {
        return Scaffold(
            body: ListView.builder(
              itemCount: model.posts.length * 2,
              itemBuilder: (BuildContext context, int i) {
                if (i.isOdd) {
                  return Divider();
                }
                final index = i ~/ 2;
                return ListTile(
                  title: Text(model.posts[index].title),
                  subtitle: Text(model.posts[index].body),
                );
              },
            ),
            appBar: AppBar(
              title: Text(
                model.testingState,
              ),
              centerTitle: true,
            ),
            floatingActionButton: _PostButton(),
            bottomNavigationBar: BottomNavigation());
      },
    );
  }
}

class _PostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postModel = ScopedModel.of<PostModel>(context, rebuildOnChange: true);
    // TODO: implement build
    return FloatingActionButton(
        onPressed: postModel.addPost,
        tooltip: 'Add post',
        child: Icon(Icons.add));
  }
}
