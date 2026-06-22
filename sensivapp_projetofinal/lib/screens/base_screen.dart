import 'package:flutter/material.dart';
import 'home/components/custom_bottom_nav.dart';
import 'home/homescreen.dart';
import 'sound_list_screen.dart';
import 'userprofile_screen.dart';
import 'diario_screen.dart';
import 'lembretes_screen.dart';
import 'artigos_screen.dart';
import 'meditacao_screen.dart';
import 'mapa_conforto_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SoundListScreen(),
    const DiarioScreen(),
    const UserProfileScreen(),
  ];

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.notifications_active_rounded,
                    color: Color(0xFF7553F6),
                  ),
                  title: const Text("Lembretes"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LembretesScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.map_rounded,
                    color: Color(0xFF7553F6),
                  ),
                  title: const Text("Mapa de Conforto"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapaConfortoScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.self_improvement_rounded,
                    color: Color(0xFF7553F6),
                  ),
                  title: const Text("Meditações"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeditacaoScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.article_rounded,
                    color: Color(0xFF7553F6),
                  ),
                  title: const Text("Artigos"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ArtigosScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex > 3 ? 0 : _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          if (index == 4) {
            _showMoreOptions();
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
