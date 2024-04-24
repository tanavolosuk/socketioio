import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socketioio/data/models/chat_message/chat_message.dart';
import 'package:socketioio/services/socket_service.dart';
import 'package:socketioio/services/user_service.dart';

class ChatController extends GetxController {

  Timer? typingTimer;
  String oldTypingValue = "";

  Timer? dotAnimationTimer;
  final stringAnimation = "".obs;

  RxList<ChatMessage> get messages => UserService.to.messages;
  RxSet<String> get typingUsers => UserService.to.typingUsers;

  final textCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  @override
  void onInit() {
    messages.listen((p0) async {
      if (scrollCtrl.hasClients) {
        var max = scrollCtrl.position.maxScrollExtent;
        if (scrollCtrl.offset + 100 >= max) {
          await Future.delayed(
              const Duration(
                milliseconds: 100,
              ), () {
            if (scrollCtrl.hasClients) {
              scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
            }
          });
        }
      }
    });
    super.onInit();
  }

  void disconnect() {
    //messages.clear();
    SocketService.to.disconnect();
  }

  bool itsMe(String clientId) => clientId == SocketService.to.clientId;

  sendMessage() {
    var message = textCtrl.text;
    if (message.isNotEmpty) SocketService.to.sendMessageToChat(message);
    textCtrl.clear();
  }

  void sendImageMessage(String list) {
    UserService.to.sendImageMessage(list);
  }

   void startStringAnimation() {
    dotAnimationTimer ??= Timer.periodic(
      Durations.short3,
      (timer) {
        if (stringAnimation.value.length < 3) {
          stringAnimation.value += '.';
        } else {
          stringAnimation.value = "";
        }
      },
    );
  }

   void typingStart(String value) {
    if (typingTimer != null) {
      oldTypingValue = value;
    } else {
      typingTimer = Timer.periodic(
        Durations.long2,
        (timer) {
          if (oldTypingValue == value) {
            typingStop();
          }
          oldTypingValue = value;
        },
      );
      startStringAnimation();
      UserService.to.typingStart();
    }
  }

   void typingStop() {
    if(typingTimer != null) {
      typingTimer?.cancel();
      typingTimer = null;
      dotAnimationTimer?.cancel();
      dotAnimationTimer = null;
      UserService.to.typindStop();
    }
  }


  @override
  void onClose() {
    scrollCtrl.dispose();
    super.onClose();
  }
}
