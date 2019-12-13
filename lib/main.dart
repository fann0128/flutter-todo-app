import 'package:flutter/material.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(new TodoApp());

// Every component in Flutter is a widget, even the whole app itself
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoList()
    );
  }
}


class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Map> _todoItems = [];

  void _addTodoItem(String val) {
    setState(() => _todoItems.add({
      'label': val,
      'isCompleted': false,
    }));
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add a new task'),
            ),
            body: new TextField(
              autofocus: true,
              onSubmitted:(val) {
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: new InputDecoration(
                hintText: 'Enter a new item...',
                contentPadding: const EdgeInsets.all(16.0)
              ),
            ),
          );
        }
      )
    );
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Mark "${_todoItems[index]['label']}" as done?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
              child: new Text('MARK AS DONE'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  void _promptDoneTodoItem(int index) {
    setState(() => _todoItems[index]['isCompleted'] = !_todoItems[index]['isCompleted']);
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index]['label'], _todoItems[index]['isCompleted'], index);
        }
      },
    );
  }

  Widget _buildTodoItem(String todoText, bool isCompleted, int index) {
    return new ListTile(
      leading: _buildItemLeading(index),
      title: new Text(todoText, style: isCompleted ? new TextStyle(color: Colors.green, fontFamily: 'Monsterrat') : null),
      // onTap: () => _promptRemoveTodoItem(index),
      trailing: _buildItemTrailing(index)
    );
  }

  Widget _buildItemLeading(int index) {
    return new IconButton(
      icon: Icon(Icons.check),
      tooltip: 'done',
      onPressed: () {
        _promptDoneTodoItem(index);
      }
    );
  }

  Widget _buildItemTrailing(int index) {
    return new IconButton(
      icon: Icon(Icons.close),
      tooltip: 'remove',
      onPressed: () {
        _promptRemoveTodoItem(index);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Todo List'),
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add Task',
        child: new Icon(Icons.add),
      ),
    );
  }
}