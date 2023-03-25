import 'package:chat_gpt/constant/desingelements.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key, required this.text, required this.sender});
  final String text;
  final String sender;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: sender == "bot"
              ? Color.fromARGB(255, 255, 249, 229)
              : Color.fromARGB(255, 253, 242, 244),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: sender == "bot"
                ? CircleAvatar(
                    child: Image.asset(
                    "assets/icons/ai.png",
                    width: 30,
                  ))
                : CircleAvatar(
                    child: Image.asset(
                    "assets/icons/user.png",
                    width: 30,
                  )),
          ),
          Expanded(child: Text(text.trim().replaceAll("\n", " "))),
        ],
      ),
    );
  }
}
