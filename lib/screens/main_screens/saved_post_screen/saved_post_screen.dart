import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/screens/main_screens/saved_post_screen/saved_post_card.dart';

class SavedPostScreen extends StatefulWidget {
  const SavedPostScreen({super.key});

  @override
  State<SavedPostScreen> createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends State<SavedPostScreen> {
  bool isPostSaved = true;
  List<String> savedPostList = [];
  List savedPostsList = [];

  getSavedPostIdList() async {
    if (isPostSaved) {
      var savedPostDoc = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('savedPosts')
          .get();

      for (var i = 0; i < savedPostDoc.docs.length; i++) {
        savedPostList.add(savedPostDoc.docs[i].id);
      }
      getKeysDataFromPostsCollection(savedPostList);
    }
  }

  getKeysDataFromPostsCollection(List<String> postIdList) async {
    var allPostsDoc = await firestore.collection('posts').get();
    for (var i = 0; i < allPostsDoc.docs.length; i++) {
      for (var k = 0; k < postIdList.length; k++) {
        if (((allPostsDoc.docs[i].data() as dynamic)['postId']) ==
            postIdList[k]) {
          savedPostsList.add(allPostsDoc.docs[i].data());
        }
      }
    }
    setState(() {
      savedPostsList;
    });
  }

  @override
  void initState() {
    super.initState();
    getSavedPostIdList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.black,
        title: const Text(
          'Saved Posts',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: savedPostList.isEmpty
          ? const Center(
              child: Icon(
                Icons.bookmarks_outlined,
                color: Colors.white,
                size: 40,
              ),
            )
          : ListView.builder(
              itemCount: savedPostsList.length,
              itemBuilder: (context, index) {
                final savedPosts = savedPostsList[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(savedPosts['profImage']),
                  ),
                  title: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SavedPostCard(
                          snap: savedPosts,
                        ),
                      ),
                    ),
                    child: Text(
                      savedPosts['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: SizedBox(
                    height: 45.0,
                    width: 45.0,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: NetworkImage(savedPosts['postUrl']),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
