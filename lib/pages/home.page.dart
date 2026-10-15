import 'package:flutter/material.dart';

import '../config/global.params.dart';
import '../menu/drawer.widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Home (Accueil)'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      drawer: const MyDrawer(),
      backgroundColor: const Color(0xFFFFF8FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: GlobalParams.accueil.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                mainAxisExtent: 102,
              ),
              itemBuilder: (context, index) {
                final item = GlobalParams.accueil[index];
                final route = item['route'] as String;
                final image = item['image'] as String;
                final title = item['title'] as String;
                final icon = item['icon'] as IconData;
                final color = item['color'] as Color;

                return Semantics(
                  button: true,
                  label: title,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, route),
                    child: Center(
                      child: Image.asset(
                        'images/profile.png',
                        width: 96,
                        height: 96,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(icon, size: 68, color: color),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
