import 'package:flutter/material.dart';
import 'package:socketioio/core/colors.dart';
import 'package:socketioio/data/models/chat_message/chat_message.dart';
import 'package:socketioio/data/socket_events.dart';

class BubbleMessage extends StatelessWidget {
  const BubbleMessage({super.key, required this.message, required this.itsMe});

  final ChatMessage message;
  final bool itsMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: itsMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: itsMe
                  ? AppColors.thirdPrimeryColor
                  : AppColors.secondPrimeryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!itsMe) Text(message.username),
              (() { //функция вызывает саму себя
                if (message.type == SocketEvent.newImageMessage) {
                  return Image.memory(
                    message.getImage,
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('Error image'),
                  );
                }
                return Text(message.message);
              })(),
              Text(message.getTime, style: const TextStyle(fontSize: 10)),
            ],
          )),
    );
  }
}
