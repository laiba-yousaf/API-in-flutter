import 'dart:async';
import 'dart:convert';

import 'package:api_project/screen/add.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class To_dolist extends StatefulWidget {
  const To_dolist({super.key});

  @override
  State<To_dolist> createState() => _To_dolistState();
}

class _To_dolistState extends State<To_dolist> {
  List item = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Todo List")),
      ),
      body: Visibility(
        visible: isloading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchdata,
          child: ListView.builder(
              itemCount: item.length,
              itemBuilder: ((context, index) {
                final data = item[index] as Map;
                final id = data['_id'] as String;
          
                return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(data['title']),
                    subtitle: Text(data['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        Navigatatorpage_edit(data);
                        //Navigatatorpage();
                      } else if (value == 'delete') {
                        dealtbyid(id);
                      }
                    }, itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('delete'),
                          value: 'delete',
                        )
                      ];
                    }));
              })),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: Navigatatorpage, label: Text("Add Todo")),
    );
  }

// Navigate to ADD PAGE
  Future Navigatatorpage() async {
    final route = MaterialPageRoute(builder: (context) => Add_page());
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchdata();
  }


//NAVIGATE TO EDIT PAGE

   Future Navigatatorpage_edit(Map data) async {
    final route = MaterialPageRoute(builder: (context) => Add_page(todo:data));
    await Navigator.push(context, route);
     setState(() {
      isloading = true;
    });
    fetchdata();
    
   
  }


//  Delete API

  Future<void> dealtbyid(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = item.where((element) => element['_id'] != id).toList();
      setState(() {
        item = filtered;
      });
    } else {
      show_message("Deletion filed");
    }
  }


 //GET API


  Future<void> fetchdata() async {
    final Url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(Url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        item = result;
      });
    }

    setState(() {
      isloading = false;
    });
  }


//show snackbar

  void show_message(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
