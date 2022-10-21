import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/gloabal_var.dart';
import '../../model/todo.dart';
import '../../services/firebase_database.dart';
import '../../services/theme_provider.dart';
import '../../widgets/circle_loading.dart';
import '../../widgets/todo_tile.dart';

class TaskIncompleted extends StatefulWidget {
  const TaskIncompleted({Key? key}) : super(key: key);

  @override
  State<TaskIncompleted> createState() => _TaskIncompletedState();
}

class _TaskIncompletedState extends State<TaskIncompleted> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = (theme.getTheme() == ThemeData.dark());
    return Column(
      children: <Widget>[
        Divider(
          thickness: 1.5,
          color: isDark ? Colors.lightBlue : Colors.blue,
          indent: 30,
          endIndent: 30,
        ),

        // ...........................................................................

        // Animated Grid Will Come Here

        // ...........................................................................

        Expanded(
          child: StreamBuilder(
              stream: TaskDatabase().getExpiredTasks(uid: clientEmail),
              builder:
                  (BuildContext context, AsyncSnapshot<List<ToDo>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleLoading();
                }

                return (snapshot.data!.isEmpty)
                    ? Center(
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            children: <Widget>[
                              const Expanded(
                                  child: Icon(
                                Icons.add_task,
                                size: 100,
                              )),
                              Text(
                                'No Task Expired!',
                                style: GoogleFonts.mcLaren(fontSize: 30),
                              )
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ToDoTile(
                                todo: snapshot.data![index],
                                snapshot: snapshot,
                                index: index);
                          },
                        ),
                      );
              }),
        ),
      ],
    );
  }
}
