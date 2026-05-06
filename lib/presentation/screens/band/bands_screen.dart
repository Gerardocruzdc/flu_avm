import 'package:flu_avm/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/bands_provider.dart';


class BandsScreen extends ConsumerWidget {
  const BandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bands = ref.watch(bandsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) {
          return _bandTile(context, ref,bands[i]);
        },
      ), 
      floatingActionButton: FloatingActionButton(
        
        elevation: 1,
        onPressed: () {
            
            addereNovumBand(context, ref);
         
        },
        child: Icon(Icons.add),
      ),
      );
  }

  Widget _bandTile(BuildContext context, WidgetRef ref, Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        ref.read(bandsProvider.notifier).delereBand(band);
      },
      background: Container(
        padding: EdgeInsets.only(left:18),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white),),
          ),
        ),
    
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.nomen.substring(0, 2).toUpperCase()),
            ),
            title: Text(band.nomen),
            trailing: Text('${band.numerusVotum}', style: TextStyle(fontSize:20),),
            onTap: () {
              ref.read(bandsProvider.notifier).addereVotum(band);
            },
          ),
    );
  }

  addereNovumBand(BuildContext context, WidgetRef ref){
    
    final TextEditingController textumController = TextEditingController();


    // showDialog(
    //   context:context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text('New Band Name'),
    //       content: TextField(),
    //       actions: [
    //         MaterialButton(
    //           onPressed: (){
    //             addereBandAdCollectione(context, textumController.text);
    //           },
    //           textColor: Colors.blue,
    //           child: Text('Add'),
    //           )
    //       ]
    //     );
    //   }
    // );


showCupertinoDialog(
  context: context, 
  builder: ( BuildContext context ) => CupertinoAlertDialog(
    title: const Text('New band name'),
    content:  CupertinoTextField(
      controller: textumController,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.white 
          : Colors.black
        )
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Add'),
          onPressed: () {
            addereBandAdCollectione(context, ref, textumController.text);
           
          }
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Close'),
          onPressed: () => context.pop()
        ),
      ],
   )
);

  }

  void addereBandAdCollectione(BuildContext context, WidgetRef ref, String nomen){
    ref.read(bandsProvider.notifier).addereBand(Band(
      id: DateTime.now().toString(), 
      nomen: nomen, 
      numerusVotum: 0
      ));
    context.pop();

  }

}