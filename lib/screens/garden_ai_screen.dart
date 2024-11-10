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

  XFile? file;

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

    // Reset the file to nothing and update the state
    setState(() {
      file = null;
    });
  }

  void _pickImage() async {
    ImagePicker picker = ImagePicker();
    file = await picker.pickImage(source: ImageSource.gallery);

    // Set the new state to have the tiny image in the corner
    setState(() {
      file = file;
    });
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
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                messageOptions: MessageOptions(
                  currentUserContainerColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.scrim,
                  currentUserTextColor: Theme.of(context).colorScheme.scrim,
                  containerColor: Theme.of(context).cardColor
                ),
                  inputOptions: InputOptions(
                    trailing: [
                    Column(children: [
                      if (file != null)
                        GestureDetector(
                          onTap: () => {
                            setState(() {
                              file = null;
                            })
                          },
                          child: Image.memory(
                            File(file!.path).readAsBytesSync(),
                            height: 30,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      IconButton(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          color: Theme.of(context).colorScheme.primary,
                      )
                    ])
                  ]),
                  currentUser: currentUser,
                  onSend: (message) {
                    if (message.medias == null && file == null) {
                      _sendMessage(message);
                    } else {
                      ChatMessage newMsg = message;
                      newMsg.medias = [];
                      newMsg.medias?.add(ChatMedia(
                          url: file!.path,
                          fileName: file!.name,
                          type: MediaType.image));
                      _sendMessage(newMsg);
                    }
                  },
                  messages: messages),
            ),
            if (messages.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text("Send a message to Garden AI to chat!"),
              )
          ]),
        ));
  }
}
