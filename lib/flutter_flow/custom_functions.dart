import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import '../backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/auth_util.dart';

/// To Check the Chat in ChatsRecord.
bool? hasNoChats(List<ChatsRecord>? allChats) {
  return allChats?.isEmpty ?? true;
}

/// Combine the List (matches and rejected) together.
List<String> combineLists(
  List<String>? matches,
  List<String>? rejected,
) {
  /// combine two lists
  final List<String> newList = <String>[""];

  if (matches != null) {
    matches.forEach((match) => newList.add(match));
  }
  if (rejected != null) {
    rejected.forEach((rejected) => newList.add(rejected));
  }

  return newList;
}

/// Use to identify which uid will be in the Chat
List<DocumentReference> createChatUserList(
  DocumentReference userRef1,
  DocumentReference userRef2,
) {
  return [userRef1, userRef2];
}
