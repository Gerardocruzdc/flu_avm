import 'package:flutter/material.dart';
import 'dart:math' as math;

class DomusScreen extends StatelessWidget {
  const DomusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flu Avm App'),
      ),
      body:  _DomusView(),
    );
  }
}

class _DomusView extends StatelessWidget {
  const _DomusView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 7,
      itemBuilder:(context, index) {
        return _PropriumListTile();
      },
    );
  }
}

class _PropriumListTile extends StatelessWidget {
  const _PropriumListTile();

  @override
  Widget build(BuildContext context) {

    final colorum = Theme.of(context).colorScheme;
    return ListTile(
      title: Text('Contador'),
      subtitle: Text('Introduccion a Riverpod'),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colorum.primary,),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(
          100, 
          math.Random().nextInt(256),
          math.Random().nextInt(256),
          math.Random().nextInt(256),
        ),
        child: Icon(Icons.add, color: Colors.black),
      ),
      onTap: () {},
    );
  }
}