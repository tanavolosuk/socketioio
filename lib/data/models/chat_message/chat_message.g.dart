// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      clientId: json['clientId'] as String? ?? "0",
      username: json['username'] as String,
      date: json['date'] as int,
      message: json['message'] as String? ?? "",
      type: $enumDecodeNullable(_$SocketEventEnumMap, json['type']) ??
          SocketEvent.unknow,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'username': instance.username,
      'date': instance.date,
      'message': instance.message,
      'type': _$SocketEventEnumMap[instance.type]!,
    };

const _$SocketEventEnumMap = {
  SocketEvent.unknow: 'unknow',
  SocketEvent.login: 'login',
  SocketEvent.logout: 'logout',
  SocketEvent.newMessage: 'newMessage',
  SocketEvent.newImageMessage: 'newImageMessage',
  SocketEvent.typingStart: 'typingStart',
  SocketEvent.typingStop: 'typingStop',
};
