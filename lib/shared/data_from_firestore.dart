// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GetDataFromFirestore({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<GetDataFromFirestore> createState() => _GetDataFromFirestoreState();
}

class _GetDataFromFirestoreState extends State<GetDataFromFirestore> {
  final dialogUsernameController = TextEditingController();
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userSSS');

  myDialog(Map data, dynamic mykey) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Container(
            padding: EdgeInsets.all(22),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: dialogUsernameController,
                    maxLength: 20,
                    decoration:
                        InputDecoration(hintText: "  ${data[mykey]}    ")),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          users
                              .doc(credential!.uid)
                              .update({mykey: dialogUsernameController.text});

                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () {
                          // addnewtask();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 17),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userSSS');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 9,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Username: ${data['username']}",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              users
                                  .doc(credential!.uid)
                                  .update({"username": FieldValue.delete()});
                            });
                          },
                          icon: Icon(Icons.delete)),
                      IconButton(
                          onPressed: () {
                            myDialog(data, 'username');
                          },
                          icon: Icon(Icons.edit)),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email: ${data['email']}",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'email');
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password: ${data['pass']}",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'pass');
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Age: ${data['age']} years old",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'age');
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Title: ${data['title']} ",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'title');
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        users.doc(credential!.uid).delete();
                      });
                    },
                    child: Text(
                      "Delete Data",
                      style: TextStyle(fontSize: 18),
                    )),
              )
            ],
          );
        }

        return Text("loading");
      },
    );
  }
}
