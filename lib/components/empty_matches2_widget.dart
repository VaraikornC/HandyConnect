import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///////
///The code below is homepage of disabled person role when there are no event created.
///////

class EmptyMatches2Widget extends StatefulWidget {
  const EmptyMatches2Widget({Key? key}) : super(key: key);

  @override
  _EmptyMatches2WidgetState createState() => _EmptyMatches2WidgetState();
}

class _EmptyMatches2WidgetState extends State<EmptyMatches2Widget> {
  bool? scaffoldConnected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          child: Stack(
            children: [
              //if theme is dark, logo will change according to dark theme
              if (Theme.of(context).brightness == Brightness.dark)
                Image.asset(
                  'assets/images/chatsEmptyDark@2x.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              //if theme is light, logo will change according to light theme
              if (!(Theme.of(context).brightness == Brightness.dark))
                Image.asset(
                  'assets/images/chatEmpty@2x.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
        //There will be 2 lines of text under the empty chat logo:
        //No Post
        //Seems you don't have any post here, please create post.
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Post',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).title3.override(
                      fontFamily: 'Lexend Deca',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Seems you don\'t have any post here, please create post.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),

        ///Codes below are "Create Event" Button
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: FFButtonWidget(
                  onPressed: () async {
                    var _shouldSetState = false;
                    //Check for the internet connection
                    scaffoldConnected = await actions.checkInternetConnection();
                    _shouldSetState = true;
                    //if no internet connection show Error
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
                      if (_shouldSetState) setState(() {});
                      return;
                    } else {
                      //if Internet connection is available
                      //link to createEventPage
                      context.pushNamed(
                        'createEventPage',
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );

                      if (_shouldSetState) setState(() {});
                      return;
                    }

                    if (_shouldSetState) setState(() {});
                  },
                  text: 'Create Event',
                  icon: Icon(
                    Icons.create_new_folder_outlined,
                    size: 15,
                  ),
                  options: FFButtonOptions(
                    width: 250,
                    height: 50,
                    color: Color(0xFF0F1642),
                    textStyle: FlutterFlowTheme.of(context).title1.override(
                          fontFamily: 'Lexend Deca',
                          color: Colors.white,
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
      ],
    );
  }
}
