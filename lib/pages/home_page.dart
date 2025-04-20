// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/layout/home_layout.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String excuse = "";
  String showExcuse = "";
  dynamic _response;
  List<List<String>> items = [
    //["dummy", "shirt"],
  ];

  final ScrollController _scrollController = ScrollController();

  // @override
  // void dispose() {
  //   _scrollController.dispose(); // Always dispose controller
  //   super.dispose();
  // }

  Future<void> generateExcuse(String input) async {
    try {
      final body = jsonEncode({'input': input});
      final header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final apiUrl = dotenv.env['API_URL'];

      final res = await http.post(
        Uri.parse('$apiUrl/query'),
        headers: header,
        body: body,
      );
      _response = res.body;
      Map<dynamic, dynamic> data = jsonDecode(_response);
      debugPrint('res $_response');
      String info = data['ai'] ?? "something went wrong or Server Error";
      setState(() {
        items.insert(0,[input, info]);
      });
    } catch (err) {
      debugPrint("error $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Excuse",
                hintText: "Enter Your Excuse",
              ),
              onChanged: (val) {
                setState(() {
                  excuse = val;
                });
              },
            ),
          ),
          SizedBox(height: 10.0),
          FilledButton(
            onPressed: () {
              setState(() {
                showExcuse = excuse;
              });
              debugPrint(excuse);
              generateExcuse(excuse);
            },
            child: Text("Generate"),
          ),

          SizedBox(height: 20.0),

          // Text(showExcuse),

          // ListView(children: items.map((item){

          //     return ListTile(
          //       title: Text(item[0]),
          //       subtitle: Text(item[1]),
          //     );
          //   }).toList(),

          // )
          Expanded(
            child: Scrollbar(
              controller: _scrollController, // connect controller
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return (Container(
                    padding: EdgeInsets.all(2.0),
                   
                    margin: EdgeInsets.all(4.0),
                    color: Color(0xffC1D8C3),
                    child: Column(
                      children: [
                        Container(
                          color: Color(0xff6A9C89),
                          padding: EdgeInsets.all(2.0),
                          width: double.infinity,
                          child: Text(
                            "${index + 1}) ${item[0]} .",
                            softWrap: true,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.all(2.0),
                          width: double.infinity,
                          child: Text(
                            item[1],
                            softWrap: true,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        // SizedBox(height: 25.0),
                      ],
                    ),
                  ));
                },
              ),
            ),
          ),
          // ListView.builder(
          //   itemCount: items.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final item = items[index];
          //     if (item is List && item.length >= 2) {
          //       // Check data type and length
          //       return Container(
          //         color: Colors.amber,
          //         child: Row(children: [Text(item[0]), Text(item[1])]),
          //       );
          //     } else {
          //       debugPrint("Warning: Invalid item data: $item at index $index");
          //       return Container(
          //         // Placeholder for invalid data
          //         color: Colors.grey[200],
          //         padding: EdgeInsets.all(16),
          //         child: Text("Invalid data for this item"),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
