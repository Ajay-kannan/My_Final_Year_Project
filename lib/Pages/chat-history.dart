import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      // Reference to the Firestore collection
      CollectionReference messageCollection = FirebaseFirestore.instance.collection('chat_messages');

      final user = await FirebaseAuth.instance.currentUser;

      // Query the collection for documents where user_id is equal to widget.userEmail
      QuerySnapshot<Object?> querySnapshot =
      await messageCollection.where('user_id', isEqualTo: user?.email).get();

      // Extract the messages from the documents
      List<Map<String, dynamic>> fetchedMessages = [];
      querySnapshot.docs.forEach((doc) {
        fetchedMessages.addAll(doc['messages']);
      });


      setState(() {
        messages = fetchedMessages;
      });


    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message History'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          // Build each message item here
          return ListTile(
            title: Text(messages[index]['messageContent'] ?? ''),
            // Add more message details as needed
          );
        },
      ),
    );
  }
}
