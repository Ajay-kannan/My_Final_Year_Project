import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantify/Provider/auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';


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

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  String messageContent_tamil;
  String time;
  String date;
  String language;
  List<String> url_link;
  List<String> images;
  List<String> videos;
  bool imagevisible = false;
  bool videovisible = false;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.videos,
      required this.images,
      required this.url_link,
      required this.language,
      required this.messageContent_tamil,
      required this.time,
      required this.date}) {}

  Map<String, dynamic> toMap() {
    return {
      'messageContent': messageContent,
      'messageType': messageType,
      'messageContentTamil': messageContent_tamil,
      'time': time,
      'date': date,
      'language': language,
      'urlLink': url_link,
      'images': images,
      'videos': videos,
      'imagevisible' : false,
      'videovisible' : false,
    };
  }
}

class _ChatViewState extends State<ChatView> {
  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();
  List<IconData> myIcons = [
    Icons.image_search,
    Icons.video_collection,
    Icons.language
  ];
  YoutubePlayerController? _youtubePlayerController;
  int _videoCurrentIndex = 0;
  final dateFormatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('HH:mm:ss');
  FlutterTts flutterTts = FlutterTts();
  bool _loadingState = false;

  void _onPlayButtonPressed(String url) {
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(url)!;
    try {
      if (url.contains('youtube.com')) {
        setState(() {
          _youtubePlayerController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false, // Adjust as needed
              mute: false,
            ),
          );
        });
      } else {
        // Handle non-YouTube videos appropriately in production
        print('Non-YouTube video URL detected: $url');
      }
    } catch (error) {
      print(error);
      // Show user-friendly error message
    }
  }

  void _onUpdateButtonPressed(String url) {
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(url)!;
    try {
      if (url.contains('youtube.com')) {
        setState(() {
          _youtubePlayerController?.cue(videoId);
        });
      } else {
        // Handle non-YouTube videos appropriately in production
        print('Non-YouTube video URL detected: $url');
      }
    } catch (error) {
      print(error);
      // Show user-friendly error message
    }
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  Future speak(String languageCode, String text) async {
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1);
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void pause() async {
    await flutterTts.pause();
  }
  void createNewChat() async {
    if(messages.isNotEmpty ) {
      try {
        // Reference to the Firestore collection
        CollectionReference messageCollection = FirebaseFirestore.instance.collection('chat_messages');

        String uniqueId = '${messages.first.date.toString()}_${messages.first.time.toString()}';

        // Extract the title from the first message
        String title = messages.isNotEmpty ? messages.first.messageContent : 'Untitled';

        final user = await FirebaseAuth.instance.currentUser;

        // Serialize each ChatMessage into a Map
        List<Map<String, dynamic>> serializedMessages = messages.map((message) => message.toMap()).toList();

        // Create a document with the unique ID and add the messages
        await messageCollection.doc(uniqueId).set({
          'user_id' : user?.email,
          'title': title,
          'messages': serializedMessages,
        });

        setState(() {
          messages.clear();
        });
      } catch (e) {
        print('Error adding messages: $e');
        // Handle error
      }

    }
  }

  void saveChat() async{
    if(messages.isNotEmpty ) {
      try {
        // Reference to the Firestore collection
        CollectionReference messageCollection = FirebaseFirestore.instance.collection('chat_messages');

        String uniqueId = '${messages.first.date.toString()}_${messages.first.time.toString()}';

        final user = await FirebaseAuth.instance.currentUser;

        // Extract the title from the first message
        String title = messages.isNotEmpty ? messages.first.messageContent : 'Untitled';

        // Serialize each ChatMessage into a Map
        List<Map<String, dynamic>> serializedMessages = messages.map((message) => message.toMap()).toList();

        // Create a document with the unique ID and add the messages
        await messageCollection.doc(uniqueId).set({
          'user_id' : user?.email,
          'title': title,
          'messages': serializedMessages,
        });

      } catch (e) {
        print('Error adding messages: $e');
        // Handle error
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF181a20),
        flexibleSpace: SafeArea(
          child: Container(

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: const CircleAvatar(
                    child: Image(
                      image: AssetImage(
                          "assets/logo.png"), // Set your logo image here
                      color: Colors.green,
                    ),
                    maxRadius: 20,
                    backgroundColor: Color(0xFF181a20),
                  ),
                ),
                Text(
                  "Chat Bot",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
               Container(
                 child: Row(
                   children: [
                     GestureDetector(onTap: (){createNewChat();}, child: Icon(Icons.add , color: Colors.white,),),
                     SizedBox(width: 5,),
                     GestureDetector(onTap: (){saveChat();}, child: Icon(Icons.save , color : Colors.white),),
                     SizedBox(width: 10,)
                   ],
                 ),
               )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF181a20),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 14, right: 24, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF1f222a)),
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Hello, How Can I Help you",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 70), // Adjust bottom padding
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 24, top: 10, bottom: 10),
                  child: Align(
                      alignment: (messages[index].messageType == "bot"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: (messages[index].messageType == "bot"
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFF1f222a)),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .language ==
                                      "english")
                                    Text(
                                      messages[index].messageContent,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  else
                                    Text(
                                      messages[index].messageContent_tamil,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  SizedBox(
                                      height:
                                          8), // Add some spacing between text and links
                                  Text(
                                    "Sources :-",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    height: 100, // Adjust the height as needed
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          messages[index].url_link.length - 1,
                                      itemBuilder: (context, idx) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              launchURL(
                                                  '${messages[index].url_link[idx]}');
                                            },
                                            child: Container(
                                              child: Text(
                                                messages[index].url_link[idx],
                                                style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.green,
                                                    decorationColor:
                                                        Colors.green),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            messages[index].imagevisible = !messages[index].imagevisible;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Icon(
                                            myIcons[0],
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (messages[index].videos.length >
                                                0) {
                                              _onPlayButtonPressed(
                                                  messages[index].videos[
                                                      _videoCurrentIndex]);
                                              messages[index].videovisible = !messages[index].videovisible;
                                            }

                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Icon(
                                            myIcons[1],
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            Provider.of<ThemeProvider>(context,
                                                listen: false)
                                                .changeLanuage();
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Icon(
                                            myIcons[2],
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: (Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: false)
                                                    .language ==
                                                "english"
                                            ? GestureDetector(
                                                onTap: () {
                                                  if (messages[index]
                                                      .messageContent
                                                      .isNotEmpty)
                                                    speak(
                                                        'en-US',
                                                        messages[index]
                                                            .messageContent);
                                                },
                                                child: Icon(
                                                  Icons.speaker,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  if (messages[index]
                                                      .messageContent_tamil
                                                      .isNotEmpty)
                                                    speak(
                                                        'ta',
                                                        messages[index]
                                                            .messageContent_tamil);
                                                },
                                                child: Icon(
                                                  Icons.speaker,
                                                  color: Colors.white,
                                                ),
                                              )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          pause();
                                        },
                                        child: Icon(
                                          Icons.pause,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      messages[index].time,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  (messages[index].imagevisible
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Here are Some Images",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              child: CarouselSlider(
                                                items: messages[index]
                                                    .images
                                                    .map((item) {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Image.network(
                                                      item,
                                                      height: 200,
                                                    ),
                                                  );
                                                }).toList(),
                                                options: CarouselOptions(
                                                    height: 250),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container()),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  if (messages[index].videovisible)
                                    Container(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Here are Some Videos",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        YoutubePlayer(
                                          controller: _youtubePlayerController!,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              ElevatedButton(
                                                  onPressed: () {
                                                    if (_videoCurrentIndex >
                                                        0) {
                                                      setState(() {
                                                        _videoCurrentIndex -= 1;
                                                      });
                                                      _onUpdateButtonPressed(
                                                          messages[index]
                                                                  .videos[
                                                              _videoCurrentIndex]);
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                  child: Text(
                                                    "prev",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    if (messages[index]
                                                            .videos
                                                            .length >
                                                        _videoCurrentIndex +
                                                            1) {
                                                      setState(() {
                                                        _videoCurrentIndex += 1;
                                                      });
                                                      _onUpdateButtonPressed(
                                                          messages[index]
                                                                  .videos[
                                                              _videoCurrentIndex]);
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                  child: Text(
                                                    "next",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ))
                                            ])
                                      ],
                                    ))
                                  else
                                    Container(),
                                ],
                              ),
                            )
                          : Container(
                          padding: EdgeInsets.only(left: 40, right: 0, top: 10, bottom: 10),
                              child: Column(
                              children: [
                                Container(
                                  padding : EdgeInsets.all(15) ,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xFF00a86b),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Text(
                                            messages[index].messageContent,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            messages[index].time,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )),
                                (_loadingState
                                    ? Container(
                                        padding : EdgeInsets.only(top: 10),
                                        child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: LoadingAnimationWidget
                                            .prograssiveDots(
                                          color: const Color(0xFF00a86b),
                                          size: 20,
                                        ),
                                      ))
                                    : Container())
                              ],
                            )))),
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
                color: Color(0xFF1f222a),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Adjust alignment
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    FloatingActionButton(
                      onPressed: () {
                        fetchResponse(); // Uncomment if you want to fetch response
                        setState(() {
                          final DateTime now_time = DateTime.now();

                          final formattedDate = dateFormatter.format(now_time);
                          final formattedTime = timeFormatter.format(now_time);
                          messages.add(ChatMessage(
                            messageContent: messageController.text,
                            messageType: "human",
                            url_link: [],
                            images: [],
                            videos: [],
                            language: "english",
                            messageContent_tamil: "",
                            time: formattedTime,
                            date: formattedDate,
                          ));
                          messageController.text = "";
                          _loadingState = true;
                        });
                      },
                      child:
                          const Icon(Icons.send, color: Colors.white, size: 18),
                      backgroundColor: const Color(0xff00a86b),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future fetchResponse() async {
    final String apiUrl = URLprovider.BaseUrl + "/ask";

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'user_question': messageController.text
    };

    try {
      // Create a Dio instance
      Dio dio = Dio();

      // Make the POST request
      final response = await dio.post(
        apiUrl,
        data: requestBody, // Set the request body
        options: Options(
          contentType: 'application/json', // Set the content type header
        ),
      );

      // Check if the request was successful (status code 200)
      print(response);

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        String answer = responseData['messageContent'];
        String answer_tamil = responseData['messageContent_tamil'];
        List<dynamic> urlLinkData = responseData['url_link'];
        List<String> urlLink =
            urlLinkData.map((link) => link.toString()).toList();

        List<dynamic> imagesData = responseData['image_links'];
        List<String> images =
            imagesData.map((link) => link.toString()).toList();

        List<dynamic> videosData = responseData['video_links'];
        List<String> videos =
            videosData.map((link) => link.toString()).toList();

        print('Answer: $answer');

        DateTime now_time = DateTime.now();
        final formattedDate = dateFormatter.format(now_time);
        final formattedTime = timeFormatter.format(now_time);

        setState(() {
          _loadingState = false;
          messages.add(ChatMessage(
              messageContent: answer,
              messageType: "bot",
              url_link: urlLink,
              images: images,
              videos: videos,
              language: "english",
              messageContent_tamil: answer_tamil,
              time: formattedTime,
              date: formattedDate));
        });
      } else {
        // Handle the error
        setState(() {
          _loadingState = false;
        });
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        _loadingState = false;
      });
      print('Error: $e');
    }
  }
}
