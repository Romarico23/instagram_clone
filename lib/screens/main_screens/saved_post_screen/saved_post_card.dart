import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/screens/main_screen.dart';
import 'package:provider/provider.dart';

class SavedPostCard extends StatelessWidget {
  final dynamic snap;
  const SavedPostCard({
    super.key,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Image.network(
            snap['postUrl'],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  snap['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await FirestoreMethods().savedPostUsers(
                  snap['postId'],
                  user.uid,
                  snap['savedPostUsers'],
                );
                await FirestoreMethods().savedPosts(snap['postId']);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                    (route) => false);
              },
              icon: const Icon(
                Icons.bookmark,
                color: Colors.red,
              ),
            )
          ],
        )
      ],
    );
  }
}
