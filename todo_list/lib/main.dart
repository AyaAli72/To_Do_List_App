import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:todo_list/entities/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 135, 109, 180)),
        useMaterial3: false,
      ),
      home: First_Page(),
    );
  }
}

List<TODOItem> todo = [];

class First_Page extends StatefulWidget {
  const First_Page({super.key});

  @override
  State<First_Page> createState() => _First_PageState();
}

class _First_PageState extends State<First_Page> {
  int barindex = 0;
  late final PageController pagecontroller =
      PageController(initialPage: barindex);
  void initstate() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pagecontroller.dispose();
  }

  void changepage(int index) {
    setState(() {
      barindex = index;
      pagecontroller.animateToPage(
        index,
        duration: const Duration(microseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PageView(
        allowImplicitScrolling: false,
        controller: pagecontroller,
        children: [
          TODO_View(),
          Top_page(),
        ],
        onPageChanged: (value) => changepage(value),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: barindex,
        onTap: (value) => changepage(value),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/todo-list.png',
              height: 25,
              color: Colors.black,
            ),
            label: 'List',
            activeIcon: Image.asset(
              'assets/icons/todo-list.png',
              height: 25,
              color: Colors.deepPurple,
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          )
        ],
      ),
    );
  }
}

class TODO_View extends StatefulWidget {
  const TODO_View({super.key});

  @override
  State<TODO_View> createState() => _TODO_ViewState();
}

class _TODO_ViewState extends State<TODO_View> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todo.length,
      itemBuilder: (context, index) {
        final todos = todo[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            selected: true,
            selectedColor: Colors.deepPurpleAccent.withOpacity(0.1),
            title: Text(
              todos.title,
              style: TextStyle(
                decoration: todos.isdone ? TextDecoration.lineThrough : null,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              todos.description,
              style: TextStyle(
                decoration: todos.isdone ? TextDecoration.lineThrough : null,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  todos.toggeldone();
                });
              },
              icon: Icon(
                todos.isdone ? Icons.check_box : Icons.check_box_outline_blank,
              ),
            ),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    todo.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete)),
          ),
        );
      },
    );
  }
}

class Top_page extends StatefulWidget {
  Top_page({super.key});

  @override
  State<Top_page> createState() => _Top_pageState();
}

class _Top_pageState extends State<Top_page> {
  late final TextEditingController _Title_Controller;
  late final TextEditingController _Description_Controller;
  @override
  void initState() {
    super.initState();
    _Title_Controller = TextEditingController();
    _Description_Controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _Title_Controller.dispose();
    _Description_Controller.dispose();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 173, 155, 206),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   'assets/svg/add-note,svg',
              //   height: MediaQuery.sizeOf(context).height * 2,
              // ),
              Image.asset(
                'assets/svg/todolist.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                autocorrect: true,
                controller: _Title_Controller,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLength: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                autocorrect: true,
                controller: _Description_Controller,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: 'Desctiption',
                  border: OutlineInputBorder(),
                ),
                maxLength: 500,
                maxLines: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addpage,
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addpage() {
    final title = _Title_Controller.text;
    final description = _Description_Controller.text;
    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The Title and description can not be empty'),
        ),
      );
    } else {
      todo.add(
        TODOItem(
          title: title,
          description: description,
        ),
      );
      _Title_Controller.clear();
      _Description_Controller.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
