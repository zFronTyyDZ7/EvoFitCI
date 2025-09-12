import 'package:flutter/material.dart';
import 'home_screen.dart';

class ObjetivoScreen extends StatefulWidget {
  const ObjetivoScreen({super.key});

  @override
  State<ObjetivoScreen> createState() => _ObjetivoScreenState();
}

class _ObjetivoScreenState extends State<ObjetivoScreen>
    with SingleTickerProviderStateMixin {
  final List<String> objetivos = [
    'Perder Peso',
    'Ganho de Massa',
    'Melhorar o Condicionamento',
    'Saúde e Bem-Estar',
  ];
  final Set<String> _selectedObjetivos = {};

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

  void _toggleSelection(String objetivo) {
    setState(() {
      if (_selectedObjetivos.contains(objetivo))
        _selectedObjetivos.remove(objetivo);
      else
        _selectedObjetivos.add(objetivo);
    });
  }

  void _saveObjectives() {
    // Apenas simulação, vamos para a Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Objetivo'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Qual seu objetivo com o EvoFit?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: objetivos.length,
                  itemBuilder: (context, index) {
                    final obj = objetivos[index];
                    final isSelected = _selectedObjetivos.contains(obj);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[100] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(obj),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.arrow_forward_ios,
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        onTap: () => _toggleSelection(obj),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveObjectives,
                  child: const Text('Salvar Objetivos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
