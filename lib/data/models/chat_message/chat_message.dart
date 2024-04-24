import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:socketioio/data/socket_events.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  ChatMessage._();

  factory ChatMessage({
    @Default("0") String clientId,
    required String username,
    required int date,
    @Default("") String message,
    @Default(SocketEvent.unknow) SocketEvent type,
  }) = _ChatMessage;

  String get getTime {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this.date);
    DateTime today = DateTime.now();
    String format = 'kk:mm';
    if(date.day != today.day) {
      format = "dd.MM $format";
    }
    return DateFormat(format).format(date);
  }

  Uint8List get getImage {
    if( type == SocketEvent.newImageMessage) {
      final source = base64Decode(message);
      return source;
    }
    return Uint8List.fromList([]);
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}