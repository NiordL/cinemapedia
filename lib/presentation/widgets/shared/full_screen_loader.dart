import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages(){
    final messages = <String>[
    'Cargando peliculas',
    'Comprando palomitas',
    'No queda hielo!',
    'Esto esta tardando o es cosa mia?',
    'Has provado a apagar y volver a encender',
  ];

    return Stream.periodic(const Duration(milliseconds: 2000),(step){
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('please wait'),
          const SizedBox(height: 10,),
          const CircularProgressIndicator(strokeWidth: 2,),
          const SizedBox(height: 10,),  
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot){
              if (!snapshot.hasData) return const Text('Cargando...');

              return Text(snapshot.data!);
            })
        ],),
       

    );
  }
}