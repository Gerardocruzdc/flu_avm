import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pokemon_index_provider.dart';
import '../../providers/providers.dart';

class PokemonsScreen extends StatelessWidget {
  const PokemonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PokemonsVisum(),
    );
  }
}

class PokemonsVisum extends ConsumerStatefulWidget {
  const PokemonsVisum({super.key});

  @override
  ConsumerState<PokemonsVisum> createState() => PokemonsVisumState();
}

class PokemonsVisumState extends ConsumerState<PokemonsVisum> {

  bool oneratusEst = false;

  final scrollController = ScrollController();

  @override

  void initState() {
    scrollController.addListener(() {
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent){
        vadeProximamPagina();
      }
    });
    super.initState();

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          title: Text('Pokemons'),
          floating: true,
          backgroundColor: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
        ),
        _PokemonGrid(),
        
      ],
    );
  }

  Future vadeProximamPagina() async{

    if(oneratusEst) return;
    oneratusEst = true;

    await Future.delayed(Duration(seconds: 2));

    ref.read(pokemonsIdsProvider.notifier).update((state) => [
        ...state, 
        ...List.generate(30, (index) => state.length + index + 1)
        
        ]);
    oneratusEst = false;

    movereAdDescendit();
    
  }

  void movereAdDescendit() {

    if(scrollController.position.pixels + 100 <= scrollController.position.maxScrollExtent) return;

    scrollController.animateTo(
      scrollController.position.pixels +200,
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );

  }

}

class _PokemonGrid extends ConsumerWidget {

  const _PokemonGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

      final pokemonIds = ref.watch(pokemonsIdsProvider);

    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: pokemonIds.length,
      itemBuilder:(context, index) {
        return GestureDetector(
          onTap: () {
            context.push('/request/${index+1}');// Handle tap event
          },
          child: Image.network( 
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png',
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
