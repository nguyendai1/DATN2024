import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child('posts');
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [];
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _posts.clear();
          Map<dynamic, dynamic> values =
          event.snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            _posts.add(Post.fromMap(value));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài Viết',style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(post: _posts[index]),
                    ),
                  );
                },
                leading: Image.network(
                  _posts[index].imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(_posts[index].title),
                subtitle: Text(_posts[index].date),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Post {
  final String imageUrl;
  final String title;
  final String date;
  final String content;

  Post({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.content,
  });

  factory Post.fromMap(Map<dynamic, dynamic> map) {
    return Post(
      imageUrl: map['imageUrl'],
      title: map['title'],
      date: map['date'],
      content: map['content'],
    );
  }
}

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bài viết', style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                post.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                post.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 5),
              Text(
                post.date,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                post.content,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
