import 'package:first_project_flutter/cam_page.dart';
import 'package:first_project_flutter/livecam_page.dart';
import 'package:flutter/material.dart';

class ConfPage extends StatefulWidget {
  const ConfPage({super.key});

  @override
  State<ConfPage> createState() {
    return ConfPageState();
  }
}

class ConfPageState extends State<ConfPage> {
  ConfPageState() {
    _selectedVal = _dropOpcoes[0];
  }
  final _dropOpcoes = [
    '',
    'Rede Neural 1',
    'Rede neural 2',
    'Rede neural 3',
    'Rede neural 4'
  ];
  String? _selectedVal = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 5, top: 80),
              child: DropdownButtonFormField(
                value: _selectedVal,
                items: _dropOpcoes
                    .map((e) => DropdownMenuItem(
                        child: Text(e.isEmpty ? 'Modelo...' : e), value: e))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedVal = val as String;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down_rounded),
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    labelText: "Modelo",
                    border: OutlineInputBorder()),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 5, top: 40),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    labelText: 'Parametro 1',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 5, top: 40),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    labelText: 'Parametro 2',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 5, top: 40),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    labelText: 'Parametro 3',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 5, top: 40),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    labelText: 'Parametro 4',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    labelText: 'Parametro 5',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        child: BottomAppBar(
          height: 60,
          color: Colors.white,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ConfPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CamPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LiveCamPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
