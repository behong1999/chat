import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isMe;
  final Key key;
  final String userImage;

  MessageBubble(
    this.username,
    this.message,
    this.isMe,
    this.userImage,
    this.key,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      isMe ? Theme.of(context).accentColor : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(20),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(20),
                  ),
                ),
                width: 130,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe
                                ? Theme.of(context).accentTextTheme.title.color
                                : Colors.black),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                      Text(
                        message,
                        style: TextStyle(
                            color: isMe
                                ? Theme.of(context).accentTextTheme.title.color
                                : Colors.black),
                      ),
                    ]),
              ),
            ]),
        Positioned(
            top: -5,
            left: isMe ? null : 110,
            right: isMe ? 110 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ))
      ],
      clipBehavior: Clip.none,
    );
  }
}
