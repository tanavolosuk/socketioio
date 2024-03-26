import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socketioio/data/models/chat_message/chat_message.dart';
import 'package:socketioio/services/socket_service.dart';
import 'package:socketioio/services/user_service.dart';

class ChatController extends GetxController {
  RxList<ChatMessage> get messages => UserService.to.messages;

  final textCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  @override
  void onInit() {
    messages.listen((p0) async {
      var max = scrollCtrl.position.maxScrollExtent;
      if (scrollCtrl.offset + 100 >= max) {
        await Future.delayed(const Duration(milliseconds: 100,), () {
          scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
        });
      }
    });
    super.onInit();
  }

  disconnect() => SocketService.to.disconnect();
  bool itsMe(String clientId) => clientId == SocketService.to.clientId;

  sendMessage() {
    var message = textCtrl.text;
    if (message.isNotEmpty) SocketService.to.sendMessageToChat(message);
    textCtrl.clear();
  }
}
