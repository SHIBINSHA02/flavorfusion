import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SocialPostList extends StatefulWidget {
  SocialPostList({super.key});

  final List<Map<String, dynamic>> posts = [
    {
      'username': 'FoodieLover',
      'avatarUrl':
          'https://media.licdn.com/dms/image/v2/D5622AQGcW8rGzMJHaw/feedshare-shrink_800/feedshare-shrink_800/0/1699469518272?e=2147483647&v=beta&t=dow9E9BTBrvviZlX7aHBfEaLK4IwLxKfDnyc6RcB3k0',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpBem-akHNnp05MZdk3wDbYmtDsM0aVQq-Dw&s',
      'description': 'Amazing homemade pasta!',
      'dishName': 'Homemade Pasta',
      'isLiked': false,
      'showLikeAnimation': false, // Add animation flag to each post
    },
    {
      'username': 'CookingMaster',
      'avatarUrl':
          'https://media.gq.com/photos/55828d9f1177d66d68d5334a/master/w_1600%2Cc_limit/blogs-the-feed-chelsealaurengrime.jpg',
      'imageUrl':
          'https://saltedmint.com/wp-content/uploads/2024/01/Simple-Thai-yellow-chicken-curry-500x375.jpg',
      'description': 'Tried a new recipe today.',
      'dishName': 'Thai Curry',
      'isLiked': false,
      'showLikeAnimation': false,
    },
    {
      'username': 'DeliciousDishes',
      'avatarUrl':
          'https://danielandsonfuneral.com/wp-content/uploads/2018/04/img002.jpg',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu6mEn2S-XQ9jxSWuQutBdKpEjNrXx-GhvUw&s',
      'description': 'Yummy dessert time!',
      'dishName': 'Chocolate Lava Cake',
      'isLiked': false,
      'showLikeAnimation': false,
    },
  ];

  @override
  SocialPostListState createState() => SocialPostListState();
}

class SocialPostListState extends State<SocialPostList> {
  void _toggleLike(int index) {
    setState(() {
      if (widget.posts[index]['isLiked'] == false) {
        widget.posts[index]['showLikeAnimation'] = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            widget.posts[index]['showLikeAnimation'] = false;
          });
        });
      }
      widget.posts[index]['isLiked'] = !widget.posts[index]['isLiked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.posts.length, (index) {
        final post = widget.posts[index];
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        post['avatarUrl'],
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      post['username'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onDoubleTap: () {
                  _toggleLike(index);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      child: Image.network(
                        post['imageUrl'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['dishName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                  5,
                                  (index) => const Icon(Icons.star,
                                      size: 16, color: Colors.amber)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (post['showLikeAnimation'])
                      Lottie.asset(
                        'assets/animations/like.json', // Replace with your json path
                        width: 150,
                        height: 150,
                        repeat: false,
                        frameRate: FrameRate.max,
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        _toggleLike(index);
                      },
                      icon: Icon(
                        post['isLiked']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: post['isLiked'] ? Colors.red : null,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        post['description'],
                        style: const TextStyle(fontSize: 14),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
