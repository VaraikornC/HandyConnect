import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../custom_code/actions/index.dart' as actions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteProfileWidget extends StatefulWidget {
  const CompleteProfileWidget({Key? key}) : super(key: key);

  @override
  _CompleteProfileWidgetState createState() => _CompleteProfileWidgetState();
}

class _CompleteProfileWidgetState extends State<CompleteProfileWidget> {
  TextEditingController? displayNameController;
  TextEditingController? imageURLController;
  TextEditingController? phoneNumberController;
  bool? switchListTileValue;
  bool? scaffoldConnected;
  final formKey = GlobalKey<FormState>();
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

    displayNameController = TextEditingController();
    imageURLController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    displayNameController?.dispose();
    imageURLController?.dispose();
    phoneNumberController?.dispose();
    super.dispose();
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
          'Complete Profile',
          style: FlutterFlowTheme.of(context).title1.override(
                fontFamily: 'Lexend Deca',
                color: FlutterFlowTheme.of(context).dark900,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Container(
                    width: 150,
                    height: 150,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      valueOrDefault<String>(
                        imageURLController!.text,
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/dark-mode-chat-xk2sj6/assets/ails754ngloi/uiAvatar@2x.png',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: imageURLController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    labelStyle: FlutterFlowTheme.of(context).title1,
                    hintText: 'Copy an profile image here...',
                    hintStyle: FlutterFlowTheme.of(context).bodyText1,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  style: FlutterFlowTheme.of(context).subtitle2,
                  keyboardType: TextInputType.url,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: displayNameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: FlutterFlowTheme.of(context).title1,
                    hintText: 'What is your name?',
                    hintStyle: FlutterFlowTheme.of(context).bodyText1,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  style: FlutterFlowTheme.of(context).subtitle2,
                  keyboardType: TextInputType.name,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Name is required';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: phoneNumberController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Your Phone',
                    labelStyle: FlutterFlowTheme.of(context).title1,
                    hintText: 'What is your phone number?',
                    hintStyle: FlutterFlowTheme.of(context).bodyText1,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  style: FlutterFlowTheme.of(context).subtitle2,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Phone number is required';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: SwitchListTile.adaptive(
                  value: switchListTileValue ??= false,
                  onChanged: (newValue) async {
                    setState(() => switchListTileValue = newValue!);
                  },
                  title: Text(
                    'Are you disabled ?',
                    style: FlutterFlowTheme.of(context).title3.override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme.of(context).primaryColor,
                        ),
                  ),
                  tileColor: Color(0xFFF1F4F8),
                  dense: false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: FFButtonWidget(
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
                          backgroundColor:
                              FlutterFlowTheme.of(context).grayDark,
                        ),
                      );
                      return;
                    } else {
                      if (formKey.currentState == null ||
                          !formKey.currentState!.validate()) {
                        return;
                      }
                    }

                    final usersUpdateData = {
                      ...createUsersRecordData(
                        photoUrl: valueOrDefault<String>(
                          imageURLController!.text,
                          'https://static.vecteezy.com/system/resources/previews/000/420/303/large_2x/avatar-icon-vector-illustration.jpg',
                        ),
                        displayName: displayNameController!.text,
                        createdTime: getCurrentTimestamp,
                        isDisabled: switchListTileValue,
                        phoneNumber: phoneNumberController!.text,
                      ),
                      'matches': FieldValue.arrayUnion(['']),
                      'rejected': FieldValue.arrayUnion(['']),
                    };
                    await currentUserReference!.update(usersUpdateData);

                    context.pushNamed('homePage');
                  },
                  text: 'Save Profile',
                  options: FFButtonOptions(
                    width: 300,
                    height: 60,
                    color: Color(0xFF0F1642),
                    textStyle: FlutterFlowTheme.of(context).title1.override(
                          fontFamily: 'Lexend Deca',
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
