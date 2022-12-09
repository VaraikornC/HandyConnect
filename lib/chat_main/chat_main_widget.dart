import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/empty_chat_widget.dart';
import '../flutter_flow/chat/index.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMainWidget extends StatefulWidget {
  const ChatMainWidget({Key? key}) : super(key: key);

  @override
  _ChatMainWidgetState createState() => _ChatMainWidgetState();
}

class _ChatMainWidgetState extends State<ChatMainWidget> {
  bool? scaffoldConnected;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      scaffoldConnected = await actions.checkInternetConnection();
      if (scaffoldConnected == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: A network error (such as timeout, interrupted connection or unreachable host) has occurred.',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).dark900,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).grayDark,
          ),
        );
      } else {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
            ),
          );
        }
        final chatMainUsersRecord = snapshot.data!;
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: Color(0xFF0F1642),
            automaticallyImplyLeading: false,
            title: Text(
              'All Chats',
              style: FlutterFlowTheme.of(context).title1.override(
                    fontFamily: 'Lexend Deca',
                    color: FlutterFlowTheme.of(context).tertiaryColor,
                  ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 4,
          ),
          body: SafeArea(
            child: StreamBuilder<List<ChatsRecord>>(
              stream: queryChatsRecord(
                queryBuilder: (chatsRecord) => chatsRecord
                    .where('users', arrayContains: currentUserReference)
                    .orderBy('last_message_time', descending: true),
              ),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                List<ChatsRecord> containerChatsRecordList = snapshot.data!;
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                    child: Builder(
                      builder: (context) {
                        final allChats = containerChatsRecordList.toList();
                        if (allChats.isEmpty) {
                          return Center(
                            child: EmptyChatWidget(),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: allChats.length,
                          itemBuilder: (context, allChatsIndex) {
                            final allChatsItem = allChats[allChatsIndex];
                            return StreamBuilder<FFChatInfo>(
                              stream: FFChatManager.instance
                                  .getChatInfo(chatRecord: allChatsItem),
                              builder: (context, snapshot) {
                                final chatInfo =
                                    snapshot.data ?? FFChatInfo(allChatsItem);
                                return FFChatPreview(
                                  onTap: () => context.pushNamed(
                                    'chatDetails',
                                    queryParams: {
                                      'chatUser': serializeParam(
                                        chatInfo.otherUsers.length == 1
                                            ? chatInfo.otherUsersList.first
                                            : null,
                                        ParamType.Document,
                                      ),
                                      'chatRef': serializeParam(
                                        chatInfo.chatRecord.reference,
                                        ParamType.DocumentReference,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      'chatUser':
                                          chatInfo.otherUsers.length == 1
                                              ? chatInfo.otherUsersList.first
                                              : null,
                                    },
                                  ),
                                  lastChatText: chatInfo.chatPreviewMessage(),
                                  lastChatTime: allChatsItem.lastMessageTime,
                                  seen: allChatsItem.lastMessageSeenBy!
                                      .contains(currentUserReference),
                                  title: chatInfo.chatPreviewTitle(),
                                  userProfilePic: chatInfo.chatPreviewPic(),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  unreadColor:
                                      FlutterFlowTheme.of(context).tertiary,
                                  titleTextStyle: GoogleFonts.getFont(
                                    'Lexend Deca',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  dateTextStyle: GoogleFonts.getFont(
                                    'Lexend Deca',
                                    color:
                                        FlutterFlowTheme.of(context).grayIcon,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  previewTextStyle: GoogleFonts.getFont(
                                    'Lexend Deca',
                                    color:
                                        FlutterFlowTheme.of(context).grayIcon,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          8, 3, 8, 3),
                                  borderRadius: BorderRadius.circular(0),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
