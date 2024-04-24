import 'package:get/get.dart';
import 'package:socketioio/data/models/chat_message/chat_message.dart';
import 'package:socketioio/data/socket_events.dart';
import 'package:socketioio/services/socket_service.dart';

class UserService extends GetxService {
  static UserService get to =>
      Get.find(); //создание ссылки на самом себя чтобы сервисы могли общаться

  String username = '';
  final _messages = RxList<ChatMessage>.empty();
  final typingUsers = RxSet<String>();

  RxList<ChatMessage> get messages => _messages;
  //bool itsMe(String id) => id == SocketService.to.clientId;

  void setUsernameAndConnect(String user) {
    username = user;
    SocketService.to.connect();
  }

  void addMessageToList(ChatMessage message) async {
    switch (message.type) {
      case SocketEvent.typingStart:
        typingUsers.add(message.username);
        return;
      case SocketEvent.typingStop:
        typingUsers.removeWhere((element) => element == message.username);
        return;
      default:
    }
    _messages.add(message);
    // try {
    //   var ctrl = Get.find<ChatController>().scrollCtrl;
    //   if (ctrl.offset + 50 >= ctrl.position.maxScrollExtent) {
    //     await Future.delayed(Durations.short1);
    //     ctrl.jumpTo(ctrl.position.maxScrollExtent);
    //   }
    // } catch (e) {}
    // printInfo(info: 'New message $message');
    // _messages.add(message);
  }

  void sendMessage(String message) =>
      SocketService.to.sendMessageToChat(message);
  void sendImageMessage(String file) => SocketService.to.sendImageMessage(file);

  void typingStart() => SocketService.to.sendTypingStart();
  void typindStop() => SocketService.to.sendTypingStop();

  void clearMessage() => _messages.clear();

  Future<UserService> init() async {
    return this;
  }
}
