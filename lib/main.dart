import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_todo_app_2/bloc/bloc/crud_bloc.dart';
import 'package:sqflite_todo_app_2/page/add_todo.dart';
import 'package:sqflite_todo_app_2/splash_screen/splash_screen.dart';

import 'page/details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CrudBloc()),
      ],
      child:MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.transparent),
    primarySwatch: Colors.yellow,
    scaffoldBackgroundColor: Colors.grey,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
  ),
  home: const SplashScreen(),
)

    );
  }
}

class SqFliteDemo extends StatefulWidget {
  const SqFliteDemo({Key? key}) : super(key: key);

  @override
  State<SqFliteDemo> createState() => _SqFliteDemoState();
}

class _SqFliteDemoState extends State<SqFliteDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bloc'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
         
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AddTodoPage()));
        },
      ),
      body: BlocBuilder<CrudBloc, CrudState>(
        builder: (context, state) {
          if (state is CrudInitial) {
            context.read<CrudBloc>().add(const FetchTodos());
          }
          if (state is DisplayTodos) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  Center(
                    child: Text(
                      'Add a Todo'.toUpperCase(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  state.todo.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(8),
                            itemCount: state.todo.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<CrudBloc>().add(
                                      FetchSpecificTodo(id: state.todo[i].id!));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const DetailsPage()),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(bottom: 14),
                                  child: Card(
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            state.todo[i].title.toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<CrudBloc>()
                                                        .add(DeleteTodo(
                                                            id: state
                                                                .todo[i].id!));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      content:
                                                          Text("deleted todo"),
                                                    ));
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Text(''),
                ]),
              ),
            );
          }
          return Container(
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
