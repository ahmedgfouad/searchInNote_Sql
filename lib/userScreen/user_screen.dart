import 'dart:developer';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:search_note_sql/localDatabase/dbHelper.dart';

import '../model/user_model.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  final TextEditingController searchController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final database=DatabaseHelper.instance;
  bool isLoading=true;

  List<NoteModel> userNotes = [];

  @override
  void initState() {
    getNotes();
    super.initState();
  }
  void noteSearch(text)async{
    userNotes =await database.searchNotes(text);
    setState(() {});
  }

 void getNotes()async{
    userNotes =await database.getAllData();
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          AnimationSearchBar(
            searchTextEditingController: searchController,
            onChanged: (search) => noteSearch(search),
            centerTitle: "Notes",
            isBackButtonVisible: false,
            hintStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            backIcon: Icons.transcribe,
            backIconColor: Colors.white,
            searchIconColor: Colors.white,
            closeIconColor: Colors.white,
            cursorColor: Colors.white,
            textStyle: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          label: Text("Note"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          final user = NoteModel(
                            title: titleController.text,
                            note: noteController.text,
                          );
                          database.insertToDatabase(user).then((value) {
                            getNotes();
                            Navigator.of(context).pop(context);
                            log('$value');
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue),
                          child: const Center(
                            child: Text(
                              "Add Note",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),)
      : ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10,),
          itemCount: userNotes.length,
          itemBuilder: (context, index) {
            NoteModel user = userNotes[index];
            return Card(
              child: ListTile(
                  title: Text(user.title),
                  subtitle: Text(user.note),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      database.deleteFromDatabase(user.id!).then((value) {
                        getNotes();
                      });
                    },
                  )),
            );
          }),
    );
  }
}
