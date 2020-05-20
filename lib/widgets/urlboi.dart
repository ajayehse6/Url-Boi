import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_boi/locator.dart';
import 'package:url_boi/services/dynamic_links_service.dart';
import 'package:fluttertoast/fluttertoast.dart';


class UrlBoi extends StatefulWidget {
  @override
  UrlBoiState createState() => UrlBoiState();
}

class UrlBoiState extends State<UrlBoi> {
  final _urlController = TextEditingController();
  final DynamicLinksService _dynamicLinksService =locator<DynamicLinksService>();
  var _connectionStatus = 'Unknown';
  String shortUrl = '';
  String linkValue;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    initialConnectivity();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: "Enter Link to Shorten Here......",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                maxLines: 12,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ),
          Container(
            child: RaisedButton(
              child: Text(
                "Shorten This!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              color: Color(0xff0091EA),
              textColor: Colors.white,
              splashColor: Colors.grey,
              onPressed: () {
                if(Uri.parse(_urlController.text).isAbsolute){
                  if (_connectionStatus == 'ConnectivityResult.none' ||
                      _connectionStatus == 'Unknown') {
                    noConnectionAlert();
                  } else {
                    setState(() {
                      linkValue = _urlController.text;
                    });
                    _dynamicLinksService
                        .createDynamicLink(linkValue)
                        .then((Uri value) {
                      setState(() {
                        shortUrl = value.host + value.path;
                      });
                    });
                  }
                }
                else if(_urlController.text.startsWith('urlboi.page.link')){
                  inValidUrlAlert("Already Shortened!","Url Boi can't shorten his own links!");
                }
                else{
                  inValidUrlAlert("Invalid URL!","Url Boi can't shorten invalid links!");
                }
              },
            ),
          ),
          (shortUrl!='')?Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: SelectableText(
                    shortUrl,
                    style: TextStyle(
                      backgroundColor: Color(0xfff9f9ff),
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: copyToClipboard,
                    enableInteractiveSelection: false,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(8),
                ),
                Container(
                  child: Text(
                    "Click on the link above to copy it.",
                    style:TextStyle(
                      fontSize: 18
                    )
                  ),
                  margin: EdgeInsets.all(5),
                )
              ],
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top:10),
          )
          :Container(),
        ],
      ),
    );
  }

  void copyToClipboard() {
    Clipboard.setData(new ClipboardData(text: shortUrl));
    Fluttertoast.showToast(
        msg: "Yo! Link is copied!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<bool> inValidUrlAlert(String title,String errtext) {
    return Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
      ),
      type: AlertType.error,
      title: title,
      desc: errtext,
      buttons: [
        DialogButton(
          child: Text(
            "Okay Boi",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Future<bool> noConnectionAlert() {
    return Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
      ),
      type: AlertType.error,
      title: "No Internet",
      desc: "Url Boi can't shorten links!",
      buttons: [
        DialogButton(
          child: Text(
            "Okay Boi",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Future<bool> connectionsIsBackAlert() {
    return Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.green,
        ),
      ),
      type: AlertType.success,
      title: "Internet Connected",
      desc: "Url Boi can shorten links now!!",
      buttons: [
        DialogButton(
          child: Text(
            "Okay Boi",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  void initialConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    _connectionStatus = result.toString();
    if (result == ConnectivityResult.none) {
      noConnectionAlert();
    }
    checkConnectivity();
  }

  void checkConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (_connectionStatus == 'ConnectivityResult.none') {
          setState(() {
            _connectionStatus = connectivityResult.toString();
          });
          connectionsIsBackAlert();
        }
        // I am connected to a mobile network.
      } else {
        setState(() {
          _connectionStatus = connectivityResult.toString();
        });
        noConnectionAlert();
      }
    });
  }
}
