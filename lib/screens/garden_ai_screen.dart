import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/gemini/ai_constants.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/screens/manage_subscription_screen.dart';
import 'package:garden_buddy/widgets/objects/banner_ad.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
import 'package:garden_buddy/widgets/objects/credit_circle.dart';
import 'package:garden_buddy/widgets/dialogs/custom_info_dialog.dart';
import 'package:garden_buddy/widgets/objects/no_connection_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

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

  // For network integrity
  bool networkIntegrity = checkConnectionIntegrity();
  final StreamController<SwipeRefreshState> _refreshController =
      StreamController<SwipeRefreshState>();

  @override
  void initState() {
    super.initState();
  }

  // Function to send the AI a message
  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      AiConstants.messages = [chatMessage, ...AiConstants.messages];

      // Add the chat
      AiConstants.chatHistory.add(Content.text(chatMessage.text));
    });

    try {
      // HOLY BALLS! This is some confusing code
      // Yadda yadda, it makes messages work between user and model
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      AiConstants.chatModel
          .startChat(history: AiConstants.chatHistory)
          .sendMessage(images == null
              ? Content.text(chatMessage.text)
              : Content("user", [DataPart("image/jpeg", images[0])]))
          .then((value) {
        ChatMessage? lastMessage = AiConstants.messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == modelUser) {
          lastMessage = AiConstants.messages.removeAt(0);
          String response = value.text!;
          lastMessage.text += response;
          setState(() {
            AiConstants.messages = [lastMessage!, ...AiConstants.messages];
          });
        } else {
          String response = value.text!;
          ChatMessage mMessage = ChatMessage(
              user: modelUser, createdAt: DateTime.now(), text: response);
          setState(() {
            AiConstants.messages = [mMessage, ...AiConstants.messages];
            AiConstants.chatHistory.add(Content.text(response));
            // When a response is generated, subtract form the Ai credits count, for usubscribed users
            if (!PurchasesApi.subStatus) {
              AiConstants.aiCount--;
            }
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

  // Show dialog about subscribing for more credits
  void _showSubDialog() {
    /*
      "Whats wrong?"
      You've been asking, but I don't have an answer.
      ...
      'Cause we can stay at home and watch the sunset.
      But I can't help from asking, "Are you bored yet?"
      And if you're feelin' lonely, you should tell me.
      Before this ends up as another memory.
    */

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: "Out of credits!",
            description:
                "It appears that you have ran out of credits to chat with Garden AI. You must wait until tomorrow for three more credits or you can subscribe for unlimited credits.",
            imageAsset: "assets/icons/icon.jpg",
            negativeButtonText: "No thanks!",
            positiveButtonText: "Subscribe",
            onNegative: () {
              Navigator.pop(context);
            },
            onPositive: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const ManageSubscriptionScreen()));
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Garden AI",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Khand",
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: false,
          actions: [
            CreditCircle(value: AiConstants.aiCount),
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
            // May be hard to see: Ternary for network integrity
            Flexible(
              child: networkIntegrity
                  ? Column(children: [
                      // MARK: DONT TOUCH, REAL BANNER IDS
                      BannerAdView(
                        androidBannerId:
                            "ca-app-pub-6754306508338066/2146896939",
                        iOSBannerId: "ca-app-pub-6754306508338066/6325070548",
                        isTest: adTesting,
                        isShown: !PurchasesApi.subStatus,
                        bannerSize: AdSize.largeBanner,
                      ),
                      Flexible(
                        child: DashChat(
                            scrollToBottomOptions: ScrollToBottomOptions(
                              scrollToBottomBuilder: (scrollController) {
                                return DefaultScrollToBottom(
                                  scrollController: scrollController,
                                  textColor: Theme.of(context).colorScheme.primary,
                                  backgroundColor: Theme.of(context).cardColor,
                                );
                              },
                            ),
                            messageOptions: MessageOptions(
                                currentUserContainerColor:
                                    Theme.of(context).colorScheme.primary,
                                textColor: Theme.of(context).colorScheme.scrim,
                                currentUserTextColor:
                                  Colors.white,
                                containerColor: Theme.of(context).cardColor),
                            inputOptions: InputOptions(
                                inputDecoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  hintText: "Message Garden AI...",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                inputTextStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.scrim),
                                sendButtonBuilder: (send) {
                                  return IconButton(
                                    onPressed: send,
                                    icon: const Icon(Icons.send),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  );
                                },
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  ])
                                ]),
                            currentUser: currentUser,
                            onSend: (message) {
                              // If the person is subscribed, or the AI count is higher than 0, then the message can be sent...
                              if (PurchasesApi.subStatus ||
                                  AiConstants.aiCount > 0) {
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
                                // Otherwise, recommend the user a subscription
                              } else {
                                _showSubDialog();
                              }
                            },
                            messages: AiConstants.messages),
                      ),
                      // SHow the text that the AI is thinking
                      if (AiConstants.messages.isNotEmpty)
                        if (AiConstants.messages.first.user == currentUser)
                          Text("Garden AI is thinking...")
                    ])
                  : Stack(children: [
                      NoConnectionWidget(),
                      SwipeRefresh.adaptive(
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        stateStream: _refreshController.stream,
                        onRefresh: () async {
                          await getConnectionTypes();

                          setState(() {
                            networkIntegrity = checkConnectionIntegrity();
                            _refreshController.sink
                                .add(SwipeRefreshState.hidden);
                          });
                        },
                        children: [SizedBox(width: 100)],
                      )
                    ]),
            ),
            if (AiConstants.messages.isEmpty && networkIntegrity)
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text("Send a message to Garden AI to chat!"),
              )
          ]),
        ));
  }
}
