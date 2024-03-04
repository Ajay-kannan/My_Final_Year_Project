import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  ChatView(),
    );
  }
}


class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class _ChatViewState extends State<ChatView> {


  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, How Can Help you", messageType: "bot"),

  ];

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[

                SizedBox(width: 12,),
                CircleAvatar(
                  child: Image.asset(
                    "assets/logo.png", // Set your logo image here
                    color: Colors.green,
                  ),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Chat Bot", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
                // Icon(Icons.settings,color: Colors.black54,)
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[

          Container(
            height: 600,
            alignment: Alignment.topCenter,
            child: Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index].messageType == "bot"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType == "bot" ? Colors
                              .grey.shade200 : Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(messages[index].messageContent,
                          style: TextStyle(fontSize: 15),),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Container(
            child: Align(
              alignment: Alignment.bottomLeft,

              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,

                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    FloatingActionButton(
                      onPressed: () {
                        fetchResponse();
                        setState(() {
                          messages.add(new ChatMessage(
                              messageContent: messageController.text,
                              messageType: "human"));
                          messageController.text = "";
                        });

                      },
                      child: Icon(Icons.send, color: Colors.white, size: 18,),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],

                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  Future fetchResponse() async {
    // Define the API endpoint
    final String apiUrl = 'http://127.0.0.1:5000/ask';

    // Prepare the request body
    Map<String, String> requestBody = {'user_question': messageController.text};

    // Encode the request body to JSON
    String jsonBody = json.encode(requestBody);

    try {
      // Make the POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(response.body);
        String answer = responseData['answer'];

        // Do something with the answer
        print('Answer: $answer');

        setState(() {
          messages.add(new ChatMessage(
              messageContent: answer,
              messageType: "bot"));
        });
      } else {
        // Handle the error
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }

}
