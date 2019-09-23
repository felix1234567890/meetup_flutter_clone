import 'package:http/http.dart' as http;
import 'package:meetup/src/models/Post.dart';
import 'dart:convert';

class PostApiProvider {
  static final PostApiProvider _singleton = PostApiProvider._internal();
  factory PostApiProvider() {
    return _singleton;
  }
  PostApiProvider._internal();
  Future<List<Post>> fetchPosts() async {
    final res = await http.get('https://jsonplaceholder.typicode.com/posts');
    final List<dynamic> parsedPosts = json.decode(res.body);
    return parsedPosts
        .map((parsedPost) {
          return Post.fromJSON(parsedPost);
        })
        .take(2)
        .toList();
  }
}
