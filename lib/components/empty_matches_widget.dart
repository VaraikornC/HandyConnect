import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyMatchesWidget extends StatefulWidget {
  const EmptyMatchesWidget({Key? key}) : super(key: key);

  @override
  _EmptyMatchesWidgetState createState() => _EmptyMatchesWidgetState();
}

class _EmptyMatchesWidgetState extends State<EmptyMatchesWidget> {
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
              if (Theme.of(context).brightness == Brightness.dark)
                Image.asset(
                  'assets/images/chatsEmptyDark@2x.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.contain,
                ),
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
                  'Seems you don\'t have any post here, please waiting for the post.',
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
