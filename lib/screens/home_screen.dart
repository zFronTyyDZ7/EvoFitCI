import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? _userEmail;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();

    // Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString("userEmail") ?? "Usuário";
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> opcoes = [
      {
        "titulo": "Mapa",
        "icone": Icons.map,
        "rota": "/mapa",
        "cor": Colors.blue,
      },
      {
        "titulo": "Objetivos",
        "icone": Icons.flag,
        "rota": "/objetivo",
        "cor": Colors.green,
      },
      {
        "titulo": "Configurações",
        "icone": Icons.settings,
        "rota": "/config",
        "cor": Colors.orange,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Bem-vindo, $_userEmail 👋"),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: opcoes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = opcoes[index];
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, item['rota']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: item['cor'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: item['cor'],
                      radius: 32,
                      child: Icon(item['icone'], color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['titulo'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Placeholder para progresso ou notificações
                    LinearProgressIndicator(
                      value: index == 1
                          ? 0.4
                          : null, // exemplo: 40% para Objetivos
                      backgroundColor: Colors.grey[200],
                      color: item['cor'],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
