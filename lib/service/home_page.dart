import 'package:flutter/material.dart';
import 'package:testt/service/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService instance = DatabaseService.instance;
  late TextEditingController contentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hello there"),
        ),
        body: FutureBuilder(
            future: instance.getData(),
            builder: (context, snap) {
              return ListView.builder(
                itemCount: snap.data?.length,
                itemBuilder: (context, index) {
                  final singleTodo = snap.data?[index];
                  return ListTile(
                    onTap: () {
                      instance.deleteNote(singleTodo.id);
                      setState(() {});
                    },
                    leading: Text(singleTodo!.content),
                    trailing: Checkbox(
                        value: singleTodo.status == 1,
                        onChanged: (val) {
                          instance.updateNote(
                              singleTodo.status == 0 ? 1 : 0, singleTodo.id);
                          setState(() {});
                        }),
                  );
                },
              );
            }),
        floatingActionButton: Showpops());
  }

  Widget Showpops() {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Note"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: contentController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 1,
                                ))),
                      ),
                      TextButton(
                        onPressed: () {
                          instance.createData(contentController.text.trim());
                          Navigator.of(context).pop();
                          contentController.clear();
                          setState(() {});
                        },
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
}
