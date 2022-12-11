import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/empty_matches2_widget.dart';
import '../components/empty_matches_widget.dart';
import '../components/empty_v_history_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../custom_code/actions/index.dart' as actions;
import '../flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  Completer<List<PostsRecord>>? _firestoreRequestCompleter;
  bool? scaffoldConnected;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    /// On page load action.
    /// To check the internet connection.
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: Color(0xFF0F1642),
        automaticallyImplyLeading: false,
        title: Text(
          'Homepage',
          style: FlutterFlowTheme.of(context).title1.override(
                fontFamily: 'Lexend Deca',
                color: FlutterFlowTheme.of(context).dark900,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// Check isDisabled, This is Disabled account.
          if (valueOrDefault<bool>(currentUserDocument?.isDisabled, false) ==
              true)
            AuthUserStreamWidget(
              child: Stack(
                children: [
                  StreamBuilder<UsersRecord>(
                    /// Get Document of current user Reference.
                    stream: UsersRecord.getDocument(currentUserReference!),
                    builder: (context, snapshot) {
                      /// loading Widget style.
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
                      final stackUsersRecord = snapshot.data!;
                      return Stack(
                        children: [
                          StreamBuilder<List<PostsRecord>>(
                            /// Query from posts collection (post_user)
                            stream: queryPostsRecord(
                              queryBuilder: (postsRecord) => postsRecord.where(
                                  'post_user',
                                  isEqualTo: currentUserReference),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              /// loading Widget style.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                );
                              }
                              List<PostsRecord> stackPostsRecordList =
                                  snapshot.data!;
                              final stackPostsRecord =
                                  stackPostsRecordList.isNotEmpty
                                      ? stackPostsRecordList.first
                                      : null;
                              return Stack(
                                children: [
                                  if (stackPostsRecord != null)
                                    StreamBuilder<List<PostsRecord>>(
                                      /// Query from posts collection (post_user == time_posted)
                                      stream: queryPostsRecord(
                                        queryBuilder: (postsRecord) =>
                                            postsRecord
                                                .where('post_user',
                                                    isEqualTo:
                                                        currentUserReference)
                                                .orderBy('time_posted',
                                                    descending: true),
                                      ),
                                      builder: (context, snapshot) {
                                        /// loading Widget style.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: CircularProgressIndicator(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryColor,
                                              ),
                                            ),
                                          );
                                        }
                                        List<PostsRecord>
                                            columnPostsRecordList =
                                            snapshot.data!;

                                        /// Check previous query, if have document
                                        /// then show No Post and CreateEvent Button.
                                        if (columnPostsRecordList.isEmpty) {
                                          return Center(
                                            child: Image.asset(
                                              'assets/images/noFriends@2x.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                            ),
                                          );
                                        }

                                        /// Show history of created events and CreateEvent Button.
                                        return SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(
                                                columnPostsRecordList.length,
                                                (columnIndex) {
                                              final columnPostsRecord =
                                                  columnPostsRecordList[
                                                      columnIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 12, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8, 0, 8, 0),

                                                      /// Tap on event to view Additional Information.
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Additional Information :'),
                                                                content: Text(
                                                                    columnPostsRecord
                                                                        .postDescription!),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Close'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },

                                                        /// Information of created events (Ex.Title,Lacation,Date/Time,etc.).
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 2,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.95,
                                                            height: 250,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .lineColor,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .dark900,
                                                                  offset:
                                                                      Offset(
                                                                          0, 1),
                                                                )
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 0,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12,
                                                                          20,
                                                                          12,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            24,
                                                                        height:
                                                                            32,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).lineColor,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.location_on_sharp,
                                                                              color: Colors.black,
                                                                              size: 27,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.date_range_outlined,
                                                                              color: Colors.black,
                                                                              size: 27,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              color: Colors.black,
                                                                              size: 27,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            20,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            /// Show Title of event.
                                                                            Text(
                                                                              columnPostsRecord.postTitle!,
                                                                              style: FlutterFlowTheme.of(context).title1,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),

                                                                                  /// Show Location of event.
                                                                                  child: Text(
                                                                                    'Location : ${columnPostsRecord.location}',
                                                                                    style: FlutterFlowTheme.of(context).subtitle1,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),

                                                                                  /// Show Date of event.
                                                                                  child: Text(
                                                                                    'Date : ${dateTimeFormat('d/M/y', columnPostsRecord.startTime)}',
                                                                                    style: FlutterFlowTheme.of(context).subtitle1,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),

                                                                                  /// Show Time of event.
                                                                                  child: Text(
                                                                                    'Time : ${dateTimeFormat('jm', columnPostsRecord.startTime)}',
                                                                                    style: FlutterFlowTheme.of(context).subtitle1,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,

                                                                            /// Show Status of event.
                                                                            children: [
                                                                              Text(
                                                                                'Status',
                                                                                style: FlutterFlowTheme.of(context).title1,
                                                                              ),
                                                                              Stack(
                                                                                children: [
                                                                                  /// Show Status (Complete) of event.
                                                                                  if (columnPostsRecord.status == true)
                                                                                    Container(
                                                                                      width: 150,
                                                                                      height: 60,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xAB5AEF39),
                                                                                        borderRadius: BorderRadius.circular(40),
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                                                                                              child: Text(
                                                                                                columnPostsRecord.status == false
                                                                                                    ? valueOrDefault<String>(
                                                                                                        '',
                                                                                                        'Ongoing',
                                                                                                      )
                                                                                                    : valueOrDefault<String>(
                                                                                                        '',
                                                                                                        'Complete',
                                                                                                      ),
                                                                                                textAlign: TextAlign.center,
                                                                                                style: FlutterFlowTheme.of(context).title2,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),

                                                                                  /// Show Status (On going) of event.
                                                                                  if (columnPostsRecord.status == false)
                                                                                    Container(
                                                                                      width: 150,
                                                                                      height: 60,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFFFFC03D),
                                                                                        borderRadius: BorderRadius.circular(40),
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                                                                                              child: Text(
                                                                                                columnPostsRecord.status == false
                                                                                                    ? valueOrDefault<String>(
                                                                                                        '',
                                                                                                        'Ongoing',
                                                                                                      )
                                                                                                    : valueOrDefault<String>(
                                                                                                        '',
                                                                                                        'Complete',
                                                                                                      ),
                                                                                                textAlign: TextAlign.center,
                                                                                                style: FlutterFlowTheme.of(context).title2,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                        );
                                      },
                                    ),

                                  /// Check previous query (stackPostsRecord), if empty document
                                  /// then show widget "No Post and CreateEvent Button".
                                  if (!(stackPostsRecord != null))
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: EmptyMatches2Widget(),
                                        ),
                                      ],
                                    ),

                                  /// Check internet connection.
                                  /// Not connected then show error.
                                  if (stackPostsRecord != null)
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 20, 0, 20),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  if (scaffoldConnected ==
                                                      false) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Error: A network error (such as timeout, interrupted connection or unreachable host) has occurred.',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .dark900,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .grayDark,
                                                      ),
                                                    );
                                                    return;
                                                  } else {
                                                    /// Connected then goto createEventPage.
                                                    context.pushNamed(
                                                      'createEventPage',
                                                      extra: <String, dynamic>{
                                                        kTransitionInfoKey:
                                                            TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType:
                                                              PageTransitionType
                                                                  .fade,
                                                          duration: Duration(
                                                              milliseconds: 0),
                                                        ),
                                                      },
                                                    );

                                                    return;
                                                  }
                                                },
                                                text: 'Create Event',
                                                icon: Icon(
                                                  Icons
                                                      .create_new_folder_outlined,
                                                  size: 15,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 300,
                                                  height: 55,
                                                  color: Color(0xFF0F1642),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .title1
                                                          .override(
                                                            fontFamily:
                                                                'Lexend Deca',
                                                            color: Colors.white,
                                                          ),
                                                  elevation: 3,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

          /// Check isDisabled, This is Volunteer account.
          if (valueOrDefault<bool>(currentUserDocument?.isDisabled, false) ==
              false)
            AuthUserStreamWidget(
              child: Stack(
                children: [
                  /// Use TabBar to Seperate HelpBoard and History Page.
                  DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Color(0xFF0F1642),
                          labelStyle: FlutterFlowTheme.of(context).bodyText1,
                          indicatorColor:
                              FlutterFlowTheme.of(context).secondaryColor,
                          tabs: [
                            Tab(
                              text: 'Help Board',
                              icon: Icon(
                                Icons.emoji_people,
                                color: Color(0xFF0F1642),
                              ),
                            ),
                            Tab(
                              text: 'My History',
                              icon: Icon(
                                Icons.history,
                                color: Color(0xFF0F1642),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            /// TabBar HelpBoard.
                            children: [
                              StreamBuilder<List<PostsRecord>>(
                                /// Query from posts collection.
                                stream: queryPostsRecord(
                                  queryBuilder: (postsRecord) =>
                                      postsRecord.whereNotIn(
                                          'post_id',
                                          functions.combineLists(
                                              (currentUserDocument?.matches
                                                          ?.toList() ??
                                                      [])
                                                  .toList(),
                                              (currentUserDocument?.rejected
                                                          ?.toList() ??
                                                      [])
                                                  .toList())),
                                  singleRecord: true,
                                ),
                                builder: (context, snapshot) {
                                  /// loading Widget style.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryColor,
                                        ),
                                      ),
                                    );
                                  }
                                  List<PostsRecord> stackPostsRecordList =
                                      snapshot.data!;
                                  final stackPostsRecord =
                                      stackPostsRecordList.isNotEmpty
                                          ? stackPostsRecordList.first
                                          : null;
                                  return Stack(
                                    children: [
                                      StreamBuilder<List<PostsRecord>>(
                                        stream: queryPostsRecord(
                                          queryBuilder: (postsRecord) => postsRecord
                                              .whereNotIn(
                                                  'post_id',
                                                  functions.combineLists(
                                                      (currentUserDocument
                                                                  ?.matches
                                                                  ?.toList() ??
                                                              [])
                                                          .toList(),
                                                      (currentUserDocument
                                                                  ?.rejected
                                                                  ?.toList() ??
                                                              [])
                                                          .toList()))
                                              .where('status',
                                                  isEqualTo: false),
                                          singleRecord: true,
                                        ),
                                        builder: (context, snapshot) {
                                          /// loading Widget style.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            );
                                          }
                                          List<PostsRecord>
                                              stackPostsRecordList =
                                              snapshot.data!;
                                          final stackPostsRecord =
                                              stackPostsRecordList.isNotEmpty
                                                  ? stackPostsRecordList.first
                                                  : null;
                                          return Stack(
                                            children: [
                                              StreamBuilder<List<PostsRecord>>(
                                                stream: queryPostsRecord(
                                                  queryBuilder: (postsRecord) => postsRecord
                                                      .whereNotIn(
                                                          'post_id',
                                                          functions.combineLists(
                                                              (currentUserDocument
                                                                          ?.matches
                                                                          ?.toList() ??
                                                                      [])
                                                                  .toList(),
                                                              (currentUserDocument
                                                                          ?.rejected
                                                                          ?.toList() ??
                                                                      [])
                                                                  .toList()))
                                                      .where('status',
                                                          isEqualTo: false),
                                                  singleRecord: true,
                                                ),
                                                builder: (context, snapshot) {
                                                  /// loading Widget style.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<PostsRecord>
                                                      stackPostsRecordList =
                                                      snapshot.data!;

                                                  /// Return an empty Container when the document does not exist.
                                                  if (snapshot.data!.isEmpty) {
                                                    return Container();
                                                  }
                                                  final stackPostsRecord =
                                                      stackPostsRecordList
                                                              .isNotEmpty
                                                          ? stackPostsRecordList
                                                              .first
                                                          : null;
                                                  return Stack(
                                                    children: [
                                                      StreamBuilder<
                                                          List<UsersRecord>>(
                                                        stream:

                                                            /// Query from users collection.
                                                            queryUsersRecord(
                                                          queryBuilder: (usersRecord) =>
                                                              usersRecord.where(
                                                                  'post_id',
                                                                  arrayContains:
                                                                      stackPostsRecord!
                                                                          .postId),
                                                          singleRecord: true,
                                                        ),
                                                        builder: (context,
                                                            snapshot) {
                                                          /// loading Widget style.
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Center(
                                                              child: SizedBox(
                                                                width: 50,
                                                                height: 50,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          List<UsersRecord>
                                                              stackUsersRecordList =
                                                              snapshot.data!;
                                                          final stackUsersRecord =
                                                              stackUsersRecordList
                                                                      .isNotEmpty
                                                                  ? stackUsersRecordList
                                                                      .first
                                                                  : null;
                                                          return Stack(
                                                            /// Show information of Disabled user that created event.
                                                            children: [
                                                              if (stackPostsRecord !=
                                                                  null)
                                                                SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,

                                                                        /// Show image
                                                                        children: [
                                                                          Image
                                                                              .network(
                                                                            stackUsersRecord!.photoUrl!,
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            height:
                                                                                230,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8,
                                                                            10,
                                                                            8,
                                                                            0),

                                                                        /// Tap on info box, show the Additional Information.
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Additional Information :'),
                                                                                  content: Text(stackPostsRecord!.postDescription!),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext),
                                                                                      child: Text('Close'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                230,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).lineColor,
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 55, 10, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.person_rounded,
                                                                                            color: Colors.black,
                                                                                            size: 27,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.location_on_sharp,
                                                                                            color: Colors.black,
                                                                                            size: 27,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.date_range_outlined,
                                                                                            color: Colors.black,
                                                                                            size: 27,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.access_time_outlined,
                                                                                            color: Colors.black,
                                                                                            size: 27,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Text(
                                                                                            stackPostsRecord!.postTitle!,
                                                                                            style: FlutterFlowTheme.of(context).title1,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          /// Show Disabled name.
                                                                                          Text(
                                                                                            'Name : ${stackUsersRecord!.displayName}',
                                                                                            style: FlutterFlowTheme.of(context).title2.override(
                                                                                                  fontFamily: 'Lexend Deca',
                                                                                                  fontSize: 20,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          /// Show Disabled location.
                                                                                          Text(
                                                                                            'Location : ${stackPostsRecord!.location}',
                                                                                            style: FlutterFlowTheme.of(context).title2.override(
                                                                                                  fontFamily: 'Lexend Deca',
                                                                                                  fontSize: 20,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          /// Show Disabled Date.
                                                                                          Text(
                                                                                            'Date : ${dateTimeFormat('d/M/y', stackPostsRecord!.startTime)}',
                                                                                            style: FlutterFlowTheme.of(context).title2.override(
                                                                                                  fontFamily: 'Lexend Deca',
                                                                                                  fontSize: 20,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          /// Show Disabled time.
                                                                                          Text(
                                                                                            'Time : ${dateTimeFormat('jm', stackPostsRecord!.startTime)}',
                                                                                            style: FlutterFlowTheme.of(context).title2.override(
                                                                                                  fontFamily: 'Lexend Deca',
                                                                                                  fontSize: 20,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                20,
                                                                                0,
                                                                                24),
                                                                            child:
                                                                                FFButtonWidget(
                                                                              /// Check internet connection.
                                                                              /// Not connected then show error.
                                                                              onPressed: () async {
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
                                                                                  return;
                                                                                } else {
                                                                                  /// Connected.
                                                                                  /// Ask for user confirmation (Decline Button).
                                                                                  var confirmDialogResponse = await showDialog<bool>(
                                                                                        context: context,
                                                                                        builder: (alertDialogContext) {
                                                                                          return AlertDialog(
                                                                                            title: Text('Are you sure you want to decline this request?'),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                                child: Text('No'),
                                                                                              ),
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                                child: Text('Yes'),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      ) ??
                                                                                      false;

                                                                                  /// Update to rejected.
                                                                                  if (confirmDialogResponse) {
                                                                                    final usersUpdateData = {
                                                                                      'rejected': FieldValue.arrayUnion([
                                                                                        stackPostsRecord!.postId
                                                                                      ]),
                                                                                    };
                                                                                    await currentUserReference!.update(usersUpdateData);
                                                                                  } else {
                                                                                    return;
                                                                                  }

                                                                                  context.pushNamed(
                                                                                    'homePage',
                                                                                    extra: <String, dynamic>{
                                                                                      kTransitionInfoKey: TransitionInfo(
                                                                                        hasTransition: true,
                                                                                        transitionType: PageTransitionType.fade,
                                                                                        duration: Duration(milliseconds: 0),
                                                                                      ),
                                                                                    },
                                                                                  );

                                                                                  return;
                                                                                }
                                                                              },
                                                                              text: 'Decline',
                                                                              options: FFButtonOptions(
                                                                                width: 100,
                                                                                height: 60,
                                                                                color: Color(0xBDEF3939),
                                                                                textStyle: FlutterFlowTheme.of(context).title3.override(
                                                                                      fontFamily: 'Lexend Deca',
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                elevation: 3,
                                                                                borderSide: BorderSide(
                                                                                  color: Colors.transparent,
                                                                                  width: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                20,
                                                                                0,
                                                                                24),
                                                                            child:
                                                                                FFButtonWidget(
                                                                              onPressed: () async {
                                                                                /// Check Internet connection.
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
                                                                                  return;
                                                                                } else {
                                                                                  /// Ask for user confirmation (Accept Button).
                                                                                  var confirmDialogResponse = await showDialog<bool>(
                                                                                        context: context,
                                                                                        builder: (alertDialogContext) {
                                                                                          return AlertDialog(
                                                                                            title: Text('Are you sure you want to accept this request?'),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                                child: Text('No'),
                                                                                              ),
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                                child: Text('Yes'),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      ) ??
                                                                                      false;

                                                                                  /// Update to matches.
                                                                                  if (confirmDialogResponse) {
                                                                                    final postsUpdateData = createPostsRecordData(
                                                                                      status: true,
                                                                                    );
                                                                                    await stackPostsRecord!.reference.update(postsUpdateData);
                                                                                  } else {
                                                                                    return;
                                                                                  }

                                                                                  await Future.delayed(const Duration(milliseconds: 1000));

                                                                                  final usersUpdateData = {
                                                                                    'matches': FieldValue.arrayUnion([
                                                                                      stackPostsRecord!.postId
                                                                                    ]),
                                                                                  };
                                                                                  await currentUserReference!.update(usersUpdateData);

                                                                                  ///Chat user match.
                                                                                  if ((currentUserDocument?.matches?.toList() ?? []).contains(stackPostsRecord!.postId)) {
                                                                                    final chatsCreateData = {
                                                                                      ...createChatsRecordData(
                                                                                        userA: stackUsersRecord!.reference,
                                                                                        userB: currentUserReference,
                                                                                        lastMessage: stackPostsRecord!.postTitle,
                                                                                        lastMessageTime: getCurrentTimestamp,
                                                                                      ),
                                                                                      'users': functions.createChatUserList(stackUsersRecord!.reference, currentUserReference!),
                                                                                    };
                                                                                    await ChatsRecord.collection.doc().set(chatsCreateData);
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(
                                                                                        content: Text(
                                                                                          'Thank you for your support ^_^',
                                                                                          style: TextStyle(
                                                                                            color: FlutterFlowTheme.of(context).dark900,
                                                                                          ),
                                                                                        ),
                                                                                        duration: Duration(milliseconds: 4000),
                                                                                        backgroundColor: Color(0xFF0F1642),
                                                                                      ),
                                                                                    );
                                                                                    await Future.delayed(const Duration(milliseconds: 1000));
                                                                                  }

                                                                                  context.pushNamed(
                                                                                    'homePage',
                                                                                    extra: <String, dynamic>{
                                                                                      kTransitionInfoKey: TransitionInfo(
                                                                                        hasTransition: true,
                                                                                        transitionType: PageTransitionType.fade,
                                                                                        duration: Duration(milliseconds: 0),
                                                                                      ),
                                                                                    },
                                                                                  );

                                                                                  return;
                                                                                }
                                                                              },
                                                                              text: 'Accept',
                                                                              options: FFButtonOptions(
                                                                                width: 100,
                                                                                height: 60,
                                                                                color: Color(0xAB5AEF39),
                                                                                textStyle: FlutterFlowTheme.of(context).title3.override(
                                                                                      fontFamily: 'Lexend Deca',
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                elevation: 3,
                                                                                borderSide: BorderSide(
                                                                                  color: Colors.transparent,
                                                                                  width: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),

                                              /// Check previous query (stackPostsRecord), if empty document
                                              /// then show widget "No Post".
                                              if (!(stackPostsRecord != null))
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          EmptyMatchesWidget(),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                              StreamBuilder<List<PostsRecord>>(
                                /// Query from posts collection.
                                stream: queryPostsRecord(
                                  queryBuilder: (postsRecord) =>
                                      postsRecord.whereIn(
                                          'post_id',
                                          (currentUserDocument?.matches
                                                  ?.toList() ??
                                              [])),
                                  singleRecord: true,
                                ),
                                builder: (context, snapshot) {
                                  /// loading Widget style.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryColor,
                                        ),
                                      ),
                                    );
                                  }
                                  List<PostsRecord> stackPostsRecordList =
                                      snapshot.data!;
                                  final stackPostsRecord =
                                      stackPostsRecordList.isNotEmpty
                                          ? stackPostsRecordList.first
                                          : null;
                                  return Stack(
                                    children: [
                                      StreamBuilder<List<PostsRecord>>(
                                        stream: queryPostsRecord(
                                          queryBuilder: (postsRecord) =>
                                              postsRecord.whereIn(
                                                  'post_id',
                                                  (currentUserDocument?.matches
                                                          ?.toList() ??
                                                      [])),
                                          singleRecord: true,
                                        ),
                                        builder: (context, snapshot) {
                                          /// loading Widget style.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            );
                                          }
                                          List<PostsRecord>
                                              stackPostsRecordList =
                                              snapshot.data!;

                                          /// Return an empty Container when the document does not exist.
                                          if (snapshot.data!.isEmpty) {
                                            return Container();
                                          }
                                          final stackPostsRecord =
                                              stackPostsRecordList.isNotEmpty
                                                  ? stackPostsRecordList.first
                                                  : null;
                                          return Stack(
                                            children: [
                                              StreamBuilder<List<UsersRecord>>(
                                                /// Query from users collection.
                                                stream: queryUsersRecord(
                                                  queryBuilder: (usersRecord) =>
                                                      usersRecord.where(
                                                          'matches',
                                                          arrayContains:
                                                              stackPostsRecord!
                                                                  .postId),
                                                  singleRecord: true,
                                                ),
                                                builder: (context, snapshot) {
                                                  /// loading Widget style.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<UsersRecord>
                                                      stackUsersRecordList =
                                                      snapshot.data!;

                                                  /// Return an empty Container when the document does not exist.
                                                  if (snapshot.data!.isEmpty) {
                                                    return Container();
                                                  }
                                                  final stackUsersRecord =
                                                      stackUsersRecordList
                                                              .isNotEmpty
                                                          ? stackUsersRecordList
                                                              .first
                                                          : null;

                                                  /// TabBar History.
                                                  return Stack(
                                                    children: [
                                                      FutureBuilder<
                                                          List<PostsRecord>>(
                                                        future: (_firestoreRequestCompleter ??= Completer<
                                                                List<
                                                                    PostsRecord>>()
                                                              ..complete(

                                                                  /// Query from posts collection.
                                                                  queryPostsRecordOnce(
                                                                queryBuilder: (postsRecord) => postsRecord.whereIn(
                                                                    'post_id',
                                                                    (currentUserDocument
                                                                            ?.matches
                                                                            ?.toList() ??
                                                                        [])),
                                                              )))
                                                            .future,
                                                        builder: (context,
                                                            snapshot) {
                                                          /// loading Widget style.
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Center(
                                                              child: SizedBox(
                                                                width: 50,
                                                                height: 50,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          List<PostsRecord>
                                                              columnPostsRecordList =
                                                              snapshot.data!;

                                                          /// Check previous query, if do not have documents
                                                          /// then show "No History".
                                                          if (columnPostsRecordList
                                                              .isEmpty) {
                                                            return Center(
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/noFriends@2x.png',
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.9,
                                                              ),
                                                            );
                                                          }

                                                          /// Slide down to refresh page.
                                                          return RefreshIndicator(
                                                            onRefresh:
                                                                () async {
                                                              setState(() =>
                                                                  _firestoreRequestCompleter =
                                                                      null);
                                                              await waitForFirestoreRequestCompleter();
                                                            },
                                                            child:
                                                                SingleChildScrollView(
                                                              physics:
                                                                  const AlwaysScrollableScrollPhysics(),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: List.generate(
                                                                    columnPostsRecordList
                                                                        .length,
                                                                    (columnIndex) {
                                                                  final columnPostsRecord =
                                                                      columnPostsRecordList[
                                                                          columnIndex];
                                                                  return Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            12,
                                                                            0,
                                                                            0),
                                                                    child: StreamBuilder<
                                                                        List<
                                                                            UsersRecord>>(
                                                                      stream:

                                                                          /// Query from users collection.
                                                                          queryUsersRecord(
                                                                        queryBuilder: (usersRecord) => usersRecord.where(
                                                                            'post_id',
                                                                            arrayContains:
                                                                                columnPostsRecord.postId),
                                                                        singleRecord:
                                                                            true,
                                                                      ),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        /// loading Widget style.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Center(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 50,
                                                                              height: 50,
                                                                              child: CircularProgressIndicator(
                                                                                color: FlutterFlowTheme.of(context).primaryColor,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                        List<UsersRecord>
                                                                            listFriendUsersRecordList =
                                                                            snapshot.data!;
                                                                        final listFriendUsersRecord = listFriendUsersRecordList.isNotEmpty
                                                                            ? listFriendUsersRecordList.first
                                                                            : null;
                                                                        return Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                                                                              child: InkWell(
                                                                                /// Tap on history box, it will show Additional Information.
                                                                                onTap: () async {
                                                                                  await showDialog(
                                                                                    context: context,
                                                                                    builder: (alertDialogContext) {
                                                                                      return AlertDialog(
                                                                                        title: Text('Additional Information :'),
                                                                                        content: Text(columnPostsRecord.postDescription!),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () => Navigator.pop(alertDialogContext),
                                                                                            child: Text('Close'),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  elevation: 2,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                  child: Container(
                                                                                    width: MediaQuery.of(context).size.width * 0.95,
                                                                                    height: 290,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).lineColor,
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: FlutterFlowTheme.of(context).dark900,
                                                                                          offset: Offset(0, 1),
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                      border: Border.all(
                                                                                        color: Colors.transparent,
                                                                                        width: 0,
                                                                                      ),
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Card(
                                                                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                                color: FlutterFlowTheme.of(context).primaryColor,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                                                                                                  child: Container(
                                                                                                    width: 50,
                                                                                                    height: 50,
                                                                                                    clipBehavior: Clip.antiAlias,
                                                                                                    decoration: BoxDecoration(
                                                                                                      shape: BoxShape.circle,
                                                                                                    ),

                                                                                                    /// Show disabled image profile.
                                                                                                    child: CachedNetworkImage(
                                                                                                      imageUrl: listFriendUsersRecord!.photoUrl!,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Icon(
                                                                                                      Icons.location_on_sharp,
                                                                                                      color: Colors.black,
                                                                                                      size: 27,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Icon(
                                                                                                      Icons.date_range_outlined,
                                                                                                      color: Colors.black,
                                                                                                      size: 27,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Icon(
                                                                                                      Icons.access_time,
                                                                                                      color: Colors.black,
                                                                                                      size: 27,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,

                                                                                                  /// Show disabled title of event.
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      columnPostsRecord.postTitle!,
                                                                                                      style: FlutterFlowTheme.of(context).title1,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),

                                                                                                          /// Show disabled location of event.
                                                                                                          child: Text(
                                                                                                            'Location : ${columnPostsRecord.location}',
                                                                                                            style: FlutterFlowTheme.of(context).subtitle1,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),

                                                                                                          /// Show disabled Date of event.
                                                                                                          child: Text(
                                                                                                            'Date : ${dateTimeFormat('d/M/y', columnPostsRecord.startTime)}',
                                                                                                            style: FlutterFlowTheme.of(context).subtitle1,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),

                                                                                                          /// Show disabled Time of event.
                                                                                                          child: Text(
                                                                                                            'Time : ${dateTimeFormat('jm', columnPostsRecord.startTime)}',
                                                                                                            style: FlutterFlowTheme.of(context).subtitle1,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                                                                    /// Show disabled Status of event.
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        'Status',
                                                                                                        style: FlutterFlowTheme.of(context).title1,
                                                                                                      ),
                                                                                                      Stack(
                                                                                                        children: [
                                                                                                          /// Show Status (Complete) of event.
                                                                                                          if (columnPostsRecord.status == true)
                                                                                                            Container(
                                                                                                              width: 150,
                                                                                                              height: 60,
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Color(0xAB5AEF39),
                                                                                                                borderRadius: BorderRadius.circular(40),
                                                                                                              ),
                                                                                                              child: Row(
                                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  Expanded(
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                                                                                                                      child: Text(
                                                                                                                        columnPostsRecord.status == false
                                                                                                                            ? valueOrDefault<String>(
                                                                                                                                '',
                                                                                                                                'Ongoing',
                                                                                                                              )
                                                                                                                            : valueOrDefault<String>(
                                                                                                                                '',
                                                                                                                                'Complete',
                                                                                                                              ),
                                                                                                                        textAlign: TextAlign.center,
                                                                                                                        style: FlutterFlowTheme.of(context).title2,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),

                                                                                                          /// Show Status (On going) of event.
                                                                                                          if (columnPostsRecord.status == false)
                                                                                                            Container(
                                                                                                              width: 150,
                                                                                                              height: 60,
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Color(0xFFFFC03D),
                                                                                                                borderRadius: BorderRadius.circular(40),
                                                                                                              ),
                                                                                                              child: Row(
                                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  Expanded(
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                                                                                                                      child: Text(
                                                                                                                        columnPostsRecord.status == false
                                                                                                                            ? valueOrDefault<String>(
                                                                                                                                '',
                                                                                                                                'Ongoing',
                                                                                                                              )
                                                                                                                            : valueOrDefault<String>(
                                                                                                                                '',
                                                                                                                                'Complete',
                                                                                                                              ),
                                                                                                                        textAlign: TextAlign.center,
                                                                                                                        style: FlutterFlowTheme.of(context).title2,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                      /// Check previous query (stackPostsRecord), if do not have document
                                      /// then show widget "No History".
                                      if (!(stackPostsRecord != null))
                                        EmptyVHistoryWidget(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Wait firestore request complete.
  Future waitForFirestoreRequestCompleter({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = _firestoreRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
