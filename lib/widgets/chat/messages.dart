import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          //* Snapshot aka LISTENER in this case is the result of the Future / Stream you are listening to in your FutureBuilder / StreamBuilder.
          //! Before interacting with the data being returned and using it in your builder, you have to access it first.
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          //* This builder function will be re-executed whenever the stream gives a new value
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final chatDocs = (streamSnapshot.data as QuerySnapshot).docs;

            return ListView.builder(
              // NOTE: The property 'documents' can't be unconditionally accessed
              // because the receiver can be 'null'.
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(2),
                  child: MessageBubble(
                      chatDocs[index]['username'],
                      chatDocs[index]['text'],
                      chatDocs[index]['userId'] == user.uid,
                      chatDocs[index]['userImage'],
                      ValueKey(chatDocs[index].id)),
                );
              },
            );
          },
        );
      },
    );
  }
}
