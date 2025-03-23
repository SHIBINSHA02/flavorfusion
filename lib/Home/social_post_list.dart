import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

class SocialPostList extends StatefulWidget {
  final List<Map<String, dynamic>> posts = [
    {
      'username': 'FoodieLover',
      'avatarUrl': 'https://media.licdn.com/dms/image/v2/D5622AQGcW8rGzMJHaw/feedshare-shrink_800/feedshare-shrink_800/0/1699469518272?e=2147483647&v=beta&t=dow9E9BTBrvviZlX7aHBfEaLK4IwLxKfDnyc6RcB3k0',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpBem-akHNnp05MZdk3wDbYmtDsM0aVQq-Dw&s',
      'description': 'Amazing homemade pasta!',
      'dishName': 'Homemade Pasta',
      'isLiked': false,
    },
    {
      'username': 'CookingMaster',
      'avatarUrl': 'https://media.gq.com/photos/55828d9f1177d66d68d5334a/master/w_1600%2Cc_limit/blogs-the-feed-chelsealaurengrime.jpg',
      'imageUrl': 'https://saltedmint.com/wp-content/uploads/2024/01/Simple-Thai-yellow-chicken-curry-500x375.jpg',
      'description': 'Tried a new recipe today.',
      'dishName': 'Thai Curry',
      'isLiked': false,
    },
    {
      'username': 'DeliciousDishes',
      'avatarUrl': 'https://danielandsonfuneral.com/wp-content/uploads/2018/04/img002.jpg',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu6mEn2S-XQ9jxSWuQutBdKpEjNrXx-GhvUw&s',
      'description': 'Yummy dessert time!',
      'dishName': 'Chocolate Lava Cake',
      'isLiked': false,
    },
    // Add more posts as needed
  ];

  @override
  _SocialPostListState createState() => _SocialPostListState();
}

class _SocialPostListState extends State<SocialPostList> {
  int? _likedIndex; // Track which post was liked
  bool _showAnimation = false;

  void _toggleLike(int index) {
    setState(() {
      widget.posts[index]['isLiked'] = !widget.posts[index]['isLiked'];
      _likedIndex = index;
      _showAnimation = true;

      // Reset animation after a short delay
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showAnimation = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.posts.length, (index) {
        final post = widget.posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post['avatarUrl']),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      post['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  post['dishName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onDoubleTap: () {
                    _toggleLike(index);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              post['imageUrl'],
                              width: constraints.maxWidth,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      if (_showAnimation && _likedIndex == index)
                        Lottie.asset(
                          'assets/animations/like.json', // Replace with your Lottie file path
                          width: 150, // Adjust size as needed
                          height: 150,
                          repeat: false,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(post['description']),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                        color: post['isLiked'] ? Colors.red : null,
                      ),
                      onPressed: () {
                        _toggleLike(index);
                      },
                    ),
                    // Add more icons as needed (comment, share, etc.)
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}