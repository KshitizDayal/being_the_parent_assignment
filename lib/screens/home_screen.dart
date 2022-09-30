import 'package:being_the_parent_assignment/resources/firestore_methods.dart';

import 'package:being_the_parent_assignment/screens/view_story.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../resources/auth_methods.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker picker = ImagePicker();
  List<XFile>? imageList = [];
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;

  void selectImage() async {
    setState(() {
      isLoading = true;
    });
    final List<XFile>? selectedmultiItimage = await picker.pickMultiImage();

    if (selectedmultiItimage!.isNotEmpty) {
      setState(() {
        imageList!.addAll(selectedmultiItimage);
      });

      FireStoreMethods()
          .uploadStory(
        imageList: imageList!.toList(),
        userid: user!.uid,
        name: user!.displayName as String,
      )
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }

    imageList!.clear();
  }

  void logOut() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? username = FirebaseAuth.instance.currentUser!.displayName;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Hello $username"),
              actions: [
                IconButton(
                  onPressed: logOut,
                  icon: const Icon(Icons.logout_outlined),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("story")
                          .where("storyTime",
                              isGreaterThan: DateTime.now()
                                  .subtract(const Duration(days: 1)))
                          .orderBy(
                            "storyTime",
                            descending: true,
                          )
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              String image =
                                  snapshot.data!.docs[index]['storyUrl'][0];

                              var date = snapshot.data!.docs[index]['storyTime']
                                  .toDate();

                              var storyId =
                                  snapshot.data!.docs[index]['storyId'];

                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewStory(
                                        name: snapshot.data!.docs[index]
                                            ['storyBy'],
                                        story: snapshot.data!.docs[index]
                                            ['storyUrl'],
                                        date: date),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(image),
                                        radius: 40,
                                      ),
                                    ),
                                    Text(snapshot.data!.docs[index]['storyBy'])
                                  ],
                                ),
                              );

                              // FireStoreMethods().deleteStory(
                              //   storyid: storyId,
                              // );
                              // FireStoreMethods().deleteStoryfromUser(
                              //   storyid: storyId,
                              //   userid: snapshot.data!.docs[index]['userid'],
                              // );

                              return SizedBox();
                            },
                          );
                        }
                        return SizedBox();
                      }),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Container(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.upload_sharp,
                        size: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    "Upload a story",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
            ),
          );
  }
}
