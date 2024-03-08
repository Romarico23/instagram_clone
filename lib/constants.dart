import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/main_screens/add_post_screen.dart';
import 'package:instagram_clone/screens/main_screens/saved_post_screen/saved_post_screen.dart';
import 'package:instagram_clone/screens/main_screens/feed%20screen/feed_screen.dart';
import 'package:instagram_clone/screens/main_screens/profile_screen.dart';
import 'package:instagram_clone/screens/main_screens/search_screen.dart';

List<Widget> getHomeScreenItems() {
  return [
    const FeedScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const SavedPostScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  ];
}

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
