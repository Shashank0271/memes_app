import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const catUri = "https://catfact.ninja/fact?max_length=200";
const jokeUri = "https://v2.jokeapi.dev/joke/Any?type=single";
const memeUri = "https://meme-api.herokuapp.com/gimme";
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyAppScreen(), //materials apps home is a stateful widget
    );
  }
}

class MyAppScreen extends StatefulWidget {
  @override
  _MyAppScreenState createState() => _MyAppScreenState();
}

class _MyAppScreenState extends State<MyAppScreen> {
  String message;
  String imageUrl;
  double imgBoxSize;
  double pushtext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('networking',
            style: TextStyle(
              fontFamily: 'Schyler',
            )),
        centerTitle: true,
        leading: Icon(
          Icons.message_rounded,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: pushtext == null ? 20.0 : pushtext,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        message == null ? " " : message,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.tealAccent.shade200,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Schyler2'),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: imgBoxSize,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              imageUrl != null ? imageUrl : " ",
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    //First Row of Buttons :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade700,
                            elevation: 5,
                            shadowColor: Colors.grey,
                          ),
                          icon: Icon(
                            Icons.find_in_page,
                            color: Colors.tealAccent[200],
                          ),
                          label: Text(
                            'FIND A CAT FACT !',
                            style: TextStyle(
                              color: Colors.tealAccent[200],
                              fontFamily: 'Schyler',
                            ),
                          ),
                          onPressed: () async {
                            NetworkHelper networkhelper = NetworkHelper(catUri);
                            var networkData = await networkhelper.getData();
                            print(networkData);
                            setState(() {
                              message = networkData['fact'];
                              imageUrl = null;
                              imgBoxSize = 0.0;
                              pushtext = 80.0;
                            });
                            print(message.length);
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            NetworkHelper networkhelper =
                                NetworkHelper(jokeUri);
                            var networkData;
                            networkData = await networkhelper.getData();
                            setState(() {
                              message = networkData['joke'];
                              imageUrl = null;
                              imgBoxSize = 0.0;
                              pushtext = 80.0;
                            });
                            print(networkData['joke'].length);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade700,
                            elevation: 5,
                            shadowColor: Colors.grey,
                          ),
                          icon: Icon(
                            Icons.find_in_page,
                            color: Colors.tealAccent.shade200,
                          ),
                          label: Text(
                            "FIND A JOKE !",
                            style: TextStyle(
                              color: Colors.tealAccent.shade200,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.find_in_page,
                        color: Colors.tealAccent.shade200,
                      ),
                      label: Text(
                        "GENERATE MEME",
                        style: TextStyle(
                          fontFamily: 'Schyler2',
                          color: Colors.tealAccent[200],
                        ),
                      ),
                      onPressed: () async {
                        NetworkHelper networkhelper = NetworkHelper(memeUri);
                        var networkData = await networkhelper.getData();
                        setState(
                          () {
                            message = null;
                            imageUrl = networkData['url'];
                            imgBoxSize = 350.0;
                            pushtext = 20.0;
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 5,
                        primary: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkHelper {
  final String parseThis;
  NetworkHelper(this.parseThis);
  Future getData() async {
    http.Response response = await http.get(Uri.parse(parseThis));
    return response.statusCode != null ? jsonDecode(response.body) : "";
  }
}
