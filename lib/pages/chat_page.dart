import 'dart:async';

import 'package:chat_gpt/constant/desingelements.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

import '../messages.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Messages> _messages = [];
  OpenAI? openAI;
  StreamSubscription? _subscription;
  bool _isTyping = false;
  bool _darkMode = false;

  _chatInputArea() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.5)),
              child: TextField(
                onSubmitted: ((value) => _sendMessage()),
                controller: _controller,
                decoration:
                    InputDecoration.collapsed(hintText: "Ask me something"),
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: IconButton(
                  onPressed: () => _sendMessage(),
                  icon: Icon(
                    Icons.send,
                  )))
        ],
      ),
    );
  }

  void _sendMessage() {
    Messages message = Messages(text: _controller.text, sender: "User");
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    final request = CompleteText(
        prompt: message.text, model: "text-davinci-003", maxTokens: 100);
    _subscription = openAI
        ?.build(
          token: //add your token here,
        )
        .onCompletionStream(request: request)
        .listen((response) {
      print(response!.choices[0].text);
      Messages botMessage =
          Messages(text: response.choices[0].text, sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openAI = OpenAI.instance;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(
        "Chat GPT Bot",
        style: mainHeading,
      ))),
      body: SafeArea(
        child: Column(children: [
          Flexible(
            child: ListView.builder(
                itemCount: _messages.length,
                reverse: true,
                padding: EdgeInsets.all(10),
                itemBuilder: ((context, index) {
                  return _messages[index];
                })),
          ),
          if (_isTyping)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/gif/loading-3.gif",
                width: 40,
              ),
            ),
          _chatInputArea()
        ]),
      ),
    );
  }
}
