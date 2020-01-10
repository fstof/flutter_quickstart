import 'package:flutter/material.dart';

class UnknownRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Dead end'),),
        body: Center(
          child: Text(
            'How did we get here?',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }
}
