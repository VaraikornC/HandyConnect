import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'chat_messages_record.g.dart';

///Schema for chat record
abstract class ChatMessagesRecord
    implements Built<ChatMessagesRecord, ChatMessagesRecordBuilder> {
  static Serializer<ChatMessagesRecord> get serializer =>
      _$chatMessagesRecordSerializer;

  DocumentReference? get user;

  DocumentReference? get chat;

  String? get text;

  String? get image;

  DateTime? get timestamp;

  ///Get chat message information
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(ChatMessagesRecordBuilder builder) => builder
    ..text = ''
    ..image = '';

  ///Get collections chat_message
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chat_messages');

  static Stream<ChatMessagesRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ChatMessagesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s))!);

  ChatMessagesRecord._();
  factory ChatMessagesRecord(
          [void Function(ChatMessagesRecordBuilder) updates]) =
      _$ChatMessagesRecord;

  static ChatMessagesRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

///Store chat message information
Map<String, dynamic> createChatMessagesRecordData({
  DocumentReference? user,
  DocumentReference? chat,
  String? text,
  String? image,
  DateTime? timestamp,
}) {
  final firestoreData = serializers.toFirestore(
    ChatMessagesRecord.serializer,
    ChatMessagesRecord(
      (c) => c
        ..user = user
        ..chat = chat
        ..text = text
        ..image = image
        ..timestamp = timestamp,
    ),
  );

  return firestoreData;
}
