import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ChatMessageScreen.dart';

class ChatMessage {
  final String messageContent;
  final String messageType;
  final String messageContentTamil;
  final String time;
  final String date;
  final String language;
  final List<String> urlLink;
  final List<String> images;
  final List<String> videos;

  ChatMessage({
    required this.messageContent,
    required this.messageType,
    required this.videos,
    required this.images,
    required this.urlLink,
    required this.language,
    required this.messageContentTamil,
    required this.time,
    required this.date,
  });

  factory ChatMessage.fromFirestore(Map<String, dynamic> data) {
    return ChatMessage(
      messageContent: data['messageContent'] ?? '',
      messageType: data['messageType'] ?? '',
      messageContentTamil: data['messageContentTamil'] ?? '',
      time: data['time'] ?? '',
      date: data['date'] ?? '',
      language: data['language'] ?? '',
      urlLink: List<String>.from(data['urlLink'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      videos: List<String>.from(data['videos'] ?? []),
    );
  }
}

class Conversation {
  final String title;
  final List<ChatMessage> messages;

  Conversation({required this.title, required this.messages});
}

class ChatHistory extends StatelessWidget {
  const ChatHistory({Key? key}) : super(key: key);

  Future<List<Conversation>> fetchConversations() async {
    try {
      final CollectionReference messageCollection = FirebaseFirestore.instance.collection('chat_messages');
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final QuerySnapshot<Object?> querySnapshot =
        await messageCollection.where('user_id', isEqualTo: user.email).get();

        final List<Conversation> conversations = [];
        querySnapshot.docs.forEach((doc) {
          final String title = doc['title'];
          final List<dynamic> messagesData = doc['messages'];
          final List<ChatMessage> messages =
          messagesData.map((data) => ChatMessage.fromFirestore(data)).toList();
          conversations.add(Conversation(title: title, messages: messages));
        });

        return conversations;
      } else {
        print('User is not signed in.');
        return [];
      }
    } catch (e) {
      print('Error fetching conversations: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/logogreen.png"),
          radius: 30.0,
          backgroundColor: Color(0xff181a20),
        ), // Your logo widget
        title: const Text(
          "Message History",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true, // Aligns title to the center
        backgroundColor: Color(0xff181a20),
      ),
      body: FutureBuilder<List<Conversation>>(
        future: fetchConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final List<Conversation> conversations = snapshot.data!;
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final Conversation conversation = conversations[index];
                return
                  GestureDetector(
                              onTap: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => ChatMessageScreen(conversation: conversation),),);
                                    },
                                child: Card(
                                          child: ListTile(
                                            title: Text(conversation.title),
                                          // Add more message details as needed
                                        ),
                                         ),
                                   );
                        },
                  );
          } else {
            return Center(
              child: Text('No conversations found.'),
            );
          }
        },
      ),
    );
  }
}