import 'package:flutter/material.dart';

class ConfPage extends StatefulWidget {
  const ConfPage({super.key});

  @override
  State<ConfPage> createState() {
    return ConfPageState();
  }
}

class ConfPageState extends State<ConfPage> {
  int counter = 0;
  final dropValue = ValueNotifier('');
  final dropOpcoes = {
    'Rede Neural 1',
    'Rede neural 2',
    'Rede neural 3',
    'Rede neural 4'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: ValueListenableBuilder(
              valueListenable: dropValue,
              builder: (BuildContext context, String value, _) {
                return SizedBox(
                  width: 360,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Modelo...',
                        style: TextStyle(fontSize: 15),
                      ),
                      decoration: InputDecoration(
                          labelText: 'Modelo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6))),
                      value: (value.isEmpty) ? null : value,
                      onChanged: (escolha) =>
                          dropValue.value = escolha.toString(),
                      items: dropOpcoes
                          .map(
                            (op) => DropdownMenuItem(
                              value: op,
                              child: Text(op),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Parametro 1',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Parametro 2',
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          const Center(
            child: Text(
              'Parametro 3',
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          const Divider(
            thickness: 5,
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.white,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.image_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app_outlined),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
