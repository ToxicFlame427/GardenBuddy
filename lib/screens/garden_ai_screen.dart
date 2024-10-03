import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/widgets/credit_circle.dart';
import 'package:garden_buddy/widgets/custom_info_dialog.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class GardenAIScreen extends StatefulWidget {
  const GardenAIScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GardenAIScreenState();
  }
}

class _GardenAIScreenState extends State<GardenAIScreen> {
  // Create the users for a chat screen
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser modelUser = ChatUser(
      id: "1", firstName: "Garden AI", profileImage: "assets/icons/icon.jpg");

  @override
  void initState() {
    super.initState();
  }

  // Function to send the AI a message
  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];

      // Add the chat
      chatHistory.add(Content.text(chatMessage.text));
    });

    try {
      // HOLY FUCK! This is some confusing code
      // Yadda yadda, it makes messages work between user and model
      //String message = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      aiModel
          .startChat(history: chatHistory)
          .sendMessage(images == null
              ? Content.text(chatMessage.text)
              : Content("user", [DataPart("image/jpeg", images[0])]))
          .then((value) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == modelUser) {
          lastMessage = messages.removeAt(0);
          String response = value.text!;
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = value.text!;
          ChatMessage mMessage = ChatMessage(
              user: modelUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [mMessage, ...messages];
            chatHistory.add(Content.text(response));
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "Describe this picture",
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ]);
      _sendMessage(chatMessage);
    }
  }

  // Show dialog about garden AI
  void _showGardenAIDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomInfoDialog(
              title: "Say Hello to Garden AI!",
              description:
                  "Garden AI is here to help you tend to your garden! Ask Garden AI any question about gardening, lawncare, or landscaping and it is sure to give you an answer! Please note that this is an AI model, and not every reponse is completely accurate. Please be aware of this and believe what you will. To begin, send a chat message.",
              imageAsset: "assets/icons/icon.jpg",
              buttonText: "Got it!",
              onClose: () {
                Navigator.pop(context);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Garden AI",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          centerTitle: false,
          actions: [
            const CreditCircle(value: 3),
            IconButton(
              onPressed: _showGardenAIDialog,
              icon: const Icon(Icons.info),
              color: Colors.white,
            )
          ],
          iconTheme: const IconThemeData().copyWith(color: Colors.white),
        ),
        body: SafeArea(
          child: Column(children: [
            // Uses verified library for chat screen making UI building much easier
            Flexible(
              child: DashChat(
                  inputOptions: InputOptions(trailing: [
                    IconButton(
                        onPressed: _sendMediaMessage,
                        icon: const Icon(Icons.image))
                  ]),
                  currentUser: currentUser,
                  onSend: _sendMessage,
                  messages: messages),
            ),
            if (messages.isEmpty)
              const Text("Send a message to Garden AI to chat!")
          ]),
        ));
  }
}
