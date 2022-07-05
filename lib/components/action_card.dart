import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/models/ContributionAction.dart';
import 'package:url_launcher/url_launcher.dart';
class ActionCard extends StatelessWidget {


  List<ContributionAction>? actionList;

  ActionCard(this.actionList);

  @override
  Widget build(BuildContext context) {
    print("ActionCard");
    print(actionList!.length);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 0.0),
      child: GestureDetector(
        child: Container(
          height: 28,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              reverse : true,
              scrollDirection :  Axis.horizontal,
            itemCount: actionList?.length,
            itemBuilder: (context, index) {
              print(actionList![index].contribution_type);
              return Padding( padding: const EdgeInsets
                  .symmetric(horizontal: 7),
                  child: actionList![index].contribution_type == 1 ?
                  Text(actionList![index].contribution_action_val,style: TextStyle(fontSize:24),) :
                  actionList![index].contribution_type == 2 ? GestureDetector(child: Icon(Icons.play_circle,color: Colors.red,size:28),onTap:(){
                    _launchInWebViewOrVC(Uri.parse(actionList![index].contribution_action_val));
                  }) :
                  actionList![index].contribution_type == 3 ?
                    Icon(Icons.notification_important,color: Colors.red[400],size:28) : Icon(Icons.share,color: Colors.blueAccent,size:28)

              );
            }
          ),
        ),
      ),
    );
  }


  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

}
