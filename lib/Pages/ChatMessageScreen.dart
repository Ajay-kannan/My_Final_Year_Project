import 'package:flutter/material.dart';

import 'chat-history.dart';


class ChatMessageScreen extends StatelessWidget {
  final Conversation conversation;

  const ChatMessageScreen({Key? key, required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Messages"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Title: ${conversation.title}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: conversation.messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (conversation.messages[index].messageType == "bot"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (conversation.messages[index].messageType == "bot"
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        conversation.messages[index].messageContent,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
