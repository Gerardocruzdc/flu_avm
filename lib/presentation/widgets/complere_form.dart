import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/config.dart';
import '../providers/providers.dart';

class ComplereForm extends ConsumerWidget {
  const ComplereForm({super.key});

  static const List<Color> paletteColorum = <Color>[
  Colors.red,
  Color.fromARGB(255,79,155,255),
  Color.fromARGB(255,12,135,10),
  Color.fromARGB(255,173,120,8),
  Color.fromARGB(255,248,86,254),
  Color.fromARGB(255,121,72,255),
  ];

    @override
  Widget build(BuildContext context, WidgetRef ref) {

    final Color electusColor = ref.watch(formColorProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Color.fromRGBO(64, 64, 64, 0.86),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 14),
              blurRadius: 36,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                onChanged: (value) => ref.read(formNomenProvider.notifier).state = value,
                style:TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Pon tu nombre',
                  hintStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.black45,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _aperireColorPicker(context, ref),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.black45,
                        foregroundColor:Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 23,
                            height: 23,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: electusColor,
                              border: Border.all(color: Colors.white70, width: 2),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(exColorAdHex(electusColor), style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () => _onFormSubmit(ref),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black45,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Conectar', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormSubmit(WidgetRef ref) {
    // Aquí puedes manejar la lógica de envío del formulario, como validar los campos y actualizar los proveedores.
    final String nameValue = ref.read(formNomenProvider);
    final Color color = ref.read(formColorProvider);

    final String colorValue = exColorAdHex(color);

    if (nameValue.isEmpty) return;

    final socketService = ref.read(socketServiceProvider);

    socketService.conectare();

    socketService.mittereUsor(
      nomen: nameValue, 
      colorHex: colorValue, 
      positio: ref.read(coordsMarkerProvider)
      
      );
      

    ref.read(markerPositumProvider.notifier).state = true; // Marcar que el marcador está colocado

    // ignore: avoid_print
    print('Nombre: $nameValue, Color: $colorValue');

  }

// Función que abre el modal con los colores predefinidos
Future<void> _aperireColorPicker(BuildContext context, WidgetRef ref) async {
  
  // showModalBottomSheet es una función de Flutter que muestra un panel modal en la parte inferior de la pantalla, bloqueando la interacción con el resto de la app hasta que se cierre.
  final Color? electusColor = await showModalBottomSheet<Color>(
    context: context,
    backgroundColor: Colors.black54 ,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    builder: (BuildContext context) {
      // El widget SafeArea es un contenedor que añade automáticamente relleno (padding) a sus elementos hijo para evitar que se superpongan con los componentes del sistema operativo,
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),

              // Si hay más colores de los que entran en una linea pasa a la siguiente linea y así no hay desbordamiento.
              Wrap(
                // Espacio horizontal entre los colores y entre las lineas, si las hubiera
                spacing: 12,
                runSpacing: 12,

                // Creo la lista de GestureDetector (componentes clickables) mapeando la lista de colores
                children: paletteColorum.map((Color color) {

                  // Se obtiene el color seleccionado por el usuario
                  final Color electusColor = ref.read(formColorProvider);

                  // Se compara el color seleccionado con el color actual de la iteración del map. Si son iguales, se selecciona el color.
                  final bool electusEst = color.toARGB32() == electusColor.toARGB32();

                  return GestureDetector(
                    onTap: () {
                      // Esta línea cierra el modal actual y devuelve el color seleccionado.
                      Navigator.of(context).pop(color);
                    },
                    // Se crea el contenedor de cada color
                    child: AnimatedContainer(
                      // Duración de la animación
                      duration: const Duration(milliseconds: 160),
                      // Ancho y alto del container (cada círculo)
                      width: 40,
                      height: 40,
                      // Decoración del container
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: electusEst
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                          // Ancho del borde del círculo (depende de si está seleccionado o no)
                          width: electusEst ? 3 : 1.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );

  // Si se ha seleccionado un color, se establece como estado del provider
  if (electusColor != null) {
    ref.read(formColorProvider.notifier).state = electusColor;
  }
}

}