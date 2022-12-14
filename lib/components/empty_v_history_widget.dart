import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///////
///The codes below are history of matching in volunteer role
///////

class EmptyVHistoryWidget extends StatefulWidget {
  const EmptyVHistoryWidget({Key? key}) : super(key: key);

  @override
  _EmptyVHistoryWidgetState createState() => _EmptyVHistoryWidgetState();
}

class _EmptyVHistoryWidgetState extends State<EmptyVHistoryWidget> {
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
              //Logo in the back ground will be change according to theme
              if (Theme.of(context).brightness == Brightness.dark)
                //if theme is dark, dark style logo will be applied
                Image.asset(
                  'assets/images/chatsEmptyDark@2x.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              if (!(Theme.of(context).brightness == Brightness.dark))
                //if theme is light, light style logo will be applied
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
        //No History
        //Seems you don't have any history here.
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No History',
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
                  'Seems you don\'t have any history here.',
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
      ],
    );
  }
}
