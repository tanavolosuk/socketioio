import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socketioio/core/colors.dart';
import 'package:socketioio/data/socket_events.dart';
import 'package:socketioio/modules/chat/widget/bubble_message.dart';
import 'chat_controller.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.firstPrimeryColor,
      appBar: AppBar(
        title: Obx(
          () => Column(
            children: [
              const Text(
                'Чат',
                style: TextStyle(
                    color: AppColors.firstPrimeryColor,
                    fontWeight: FontWeight.bold),
              ),
              if (controller.typingUsers.isNotEmpty)
                Text(
                  '${controller.typingUsers.join(',')} печатает${controller.stringAnimation.padRight(3)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.firstPrimeryColor),
                )
            ],
          ),
        ),
        backgroundColor: AppColors.secondPrimeryColor,
        actions: [
          IconButton(
              onPressed: () {
                controller.disconnect();
              },
              icon: const Icon(
                Icons.logout,
                color: AppColors.firstPrimeryColor,
              ))
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: Obx(() => ListView.builder(
                    controller: controller.scrollCtrl,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      var message = controller.messages[index];
                      var itsMe = controller.itsMe(message.clientId);
                      switch (message.type) {
                        case SocketEvent.login:
                          return Center(
                              child: Text(
                            "${message.username} вошел в чат!",
                            style: const TextStyle(
                                color: AppColors.fourthPrimeryColor,
                                fontWeight: FontWeight.bold),
                          ));
                        case SocketEvent.logout:
                          return Center(
                              child: Text(
                            "${message.username} вышел из чата!",
                            style: const TextStyle(
                                color: AppColors.fourthPrimeryColor,
                                fontWeight: FontWeight.bold),
                          ));
                        case SocketEvent.newMessage ||
                              SocketEvent.newImageMessage:
                          return BubbleMessage(message: message, itsMe: itsMe);
                        default:
                          return const SizedBox();
                      }
                    },
                  ))),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: controller.textCtrl,
              onFieldSubmitted: (value) {
                controller.sendMessage();
              },
              onChanged: (value) => controller.typingStart(value),
              onTapOutside: (event) => controller.typingStop(),
              decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          var data = base64Encode(await image.readAsBytes());
                          controller.sendImageMessage(data);
                        }
                      },
                      icon: const Icon(
                        Icons.crop_original,
                        color: AppColors.secondPrimeryColor,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.secondPrimeryColor,
                      ),
                    ),
                  ],
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
