import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add_page extends StatefulWidget {
  final Map? todo;
  const Add_page({super.key, this.todo});

  @override
  State<Add_page> createState() => _Add_pageState();
}

class _Add_pageState extends State<Add_page> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descrip_controller = TextEditingController();

  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titlecontroller.text = title;
      descrip_controller.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(isEdit ? 'Edit page' : 'Add Page')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Title"),
              controller: titlecontroller,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Description"),
              keyboardType: TextInputType.multiline,
              controller: descrip_controller,
              maxLines: 5,
              minLines: 3,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: isEdit?update_data:submit_data,
                child: Text(isEdit ? "Update" : "Submit"))
          ],
        ),
      ),
    );
  }


// PUT API

  Future<void> update_data() async {
    final todo = widget.todo;
    if (todo == Null) {
      print("you cannnot call update without todo data ");
      return;
    }
     final id = todo!['_id'];
    final title = titlecontroller.text;
    final description = descrip_controller.text;
     final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final Url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(Url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
        if (response.statusCode == 200) {
      show_message("Updation sucessfull");
     
    } else {
      show_message("Updation failed");
    }
  }

  //POST API

  Future<void> submit_data() async {
    //Get data from form
    final title = titlecontroller.text;
    final description = descrip_controller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final Url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(Url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      show_message("creation sucessfull");
      titlecontroller.text = '';
      descrip_controller.text = '';
    } else {
      show_message("creation failed");
    }
    //submit data
  }

  void show_message(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
