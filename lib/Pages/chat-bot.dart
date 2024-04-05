import 'package:flutter/material.dart';
import 'package:dio/dio.dart';



class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class _ChatViewState extends State<ChatView> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, How Can I Help you", messageType: "bot"),
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
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                const CircleAvatar(
                  child: Image(
                    image: AssetImage("assets/logo.png"), // Set your logo image here
                    color: Colors.green,
                  ),
                  maxRadius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Chat Bot",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 70), // Adjust bottom padding
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "bot" ? Alignment.topLeft : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType == "bot" ? Colors.grey.shade200 : Colors.blue[200]),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    FloatingActionButton(
                      onPressed: () {
                        // fetchResponse(); // Uncomment if you want to fetch response
                        setState(() {
                          messages.add(ChatMessage(
                            messageContent: messageController.text,
                            messageType: "human",
                          ));
                          messageController.text = "";
                        });
                      },
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
                      backgroundColor: const Color(0xff00a86b),
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
}

// Future fetchResponse() async {
//   final String apiUrl = 'http://127.0.0.1:5000/ask';
//
//   // Prepare the request body
//   Map<String, dynamic> requestBody = {'user_question': messageController.text};
//
//   try {
//     // Create a Dio instance
//     Dio dio = Dio();
//
//     // Make the POST request
//     final response = await dio.post(
//       apiUrl,
//       data: requestBody, // Set the request body
//       options: Options(
//         contentType: 'application/json', // Set the content type header
//       ),
//     );
//
//     // Check if the request was successful (status code 200)
//     print(response);
//     if (response.statusCode == 200) {
//       // Parse the response data
//       Map<String, dynamic> responseData = response.data;
//       String answer = responseData['answer'];
//       print('Answer: $answer');
//
//       setState(() {
//         messages.add(ChatMessage(
//           messageContent: answer,
//           messageType: "bot",
//         ));
//       });
//     } else {
//       // Handle the error
//       print('Request failed with status: ${response.statusCode}');
//     }
//   } catch (e) {
//     // Handle network errors
//     print('Error: $e');
//   }
// }

