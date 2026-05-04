import 'package:flutter/material.dart';

class NumeratorScreen extends StatefulWidget {
  const NumeratorScreen({super.key});

  @override
  State<NumeratorScreen> createState() => _NumeratorScreenState();
}

class _NumeratorScreenState extends State<NumeratorScreen> {
  int counter = 0;

   void incrementCounter() {
    setState(() {
      counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numerator Screen'),
      ),
      body: Center(
        child: Text('Valor: $counter', style: Theme.of(context).textTheme.titleLarge,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            counter++;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


/*
class NumeratorScreen extends StatelessWidget {
  int counter = 0;
  NumeratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numerator Screen'),
      ),
      body: Center(
        child: Text('Valor: $counter', style: Theme.of(context).textTheme.titleLarge,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
    
            counter++;
            // ignore: avoid_print
            print(counter);
     
        },
        child: Icon(Icons.add),
      ),
    );
  }
  
}
*/
