import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/screens/main_screens/feed%20screen/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        centerTitle: false,
        title: SvgPicture.asset(
          'images/ic_instagram.svg',
          // ignore: deprecated_member_use
          color: Colors.white,
          height: 32,
        ),
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('posts')
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
