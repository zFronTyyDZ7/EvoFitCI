import 'dart:async';
import 'package:flutter/material.dart';

// Tela: Chat AI — gera plano de treino semanal (Modelo 3: detalhado / premium)
// Local recomendado: lib/screens/chat_ai_screen.dart

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({Key? key}) : super(key: key);

  @override
  State<ChatAiScreen> createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _TrainingAiService _aiService = _TrainingAiService();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _addAiWelcome();
  }

  void _addAiWelcome() {
    final welcome =
        "Olá! Sou seu assistente EvoFit — posso gerar um plano de treino semanal detalhado, revisar um plano existente ou adaptar para iniciante/intermediário/avançado. Peça: \"Gerar semana otimizada para recomposição corporal\" ou informe seu nível e objetivo.";
    _messages.add(_ChatMessage(text: welcome, sender: Sender.ai));
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, sender: Sender.user));
      _isSending = true;
      _controller.clear();
    });

    _scrollToBottom();

    try {
      final response = await _aiService.generateResponse(text);
      setState(() {
        _messages.add(_ChatMessage(text: response, sender: Sender.ai));
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          _ChatMessage(
            text: 'Erro interno ao gerar resposta. Tente novamente.',
            sender: Sender.ai,
          ),
        );
      });
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    // Delay to allow ListView to rebuild
    Timer(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EvoFit — IA: Treino Semanal'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFFF0F4F8),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final m = _messages[index];
                    return _ChatBubble(message: m);
                  },
                ),
              ),
            ),

            // Input
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _send(),
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText:
                            'Peça: "Gerar semana otimizada" ou descreva seu nível e objetivo',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    onPressed: _isSending ? null : _send,
                    child: _isSending
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------
// Modelos e widgets auxiliares
// ---------------------

enum Sender { user, ai }

class _ChatMessage {
  final String text;
  final Sender sender;

  _ChatMessage({required this.text, required this.sender});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  const _ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == Sender.user;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = isUser ? Colors.blue.shade600 : Colors.white;
    final textColor = isUser ? Colors.white : Colors.black87;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isUser ? 18 : 6),
      bottomRight: Radius.circular(isUser ? 6 : 18),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: radius,
                boxShadow: [
                  if (!isUser)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                    ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                message.text,
                style: TextStyle(color: textColor, height: 1.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------
// Serviço local que simula IA Generativa para gerar o modelo 3 (detalhado)
// ---------------------

class _TrainingAiService {
  Future<String> generateResponse(String userInput) async {
    // Pequena "simulação" de latência de rede/IA
    await Future.delayed(const Duration(milliseconds: 700));

    final lower = userInput.toLowerCase();

    // Se o usuário pedir explicitamente para gerar semana, chamamos o gerador detalhado
    if (lower.contains('gerar') && lower.contains('semana') ||
        lower.contains('plano')) {
      return _generateDetailedWeeklyPlan();
    }

    // Se o usuário disser nível/objetivo simples, interpretamos e chamamos o gerador
    if (lower.contains('iniciante') ||
        lower.contains('intermedi') ||
        lower.contains('avanç') ||
        lower.contains('recomposição') ||
        lower.contains('hipertrofia')) {
      return _generateDetailedWeeklyPlan();
    }

    // Caso default: resposta orientativa
    return 'Posso gerar um plano semanal detalhado para você. Peça: "Gerar semana otimizada para recomposição corporal" ou informe seu nível (iniciante/intermediário/avançado) e objetivo (hipertrofia/recomposição/condicionamento).';
  }

  String _generateDetailedWeeklyPlan() {
    // Modelo 3 — texto detalhado, explicando prioridade e cada sessão
    return '''Semana otimizada para recomposição corporal (orientação premium):

Segunda — Força Upper (Prioridade: progressão de cargas)
• Aquecimento 10 min (mobilidade de ombro + ativação scapular)
• Supino reto: 5 séries x 4–6 reps (foco em carga e técnica)
• Remada curvada: 4x6–8 reps
• Desenvolvimento com halteres: 3x8–10 reps
• Tríceps testa: 3x8–10 reps
• Core: prancha 3x 40–60s

Terça — Força Lower (Pré-exaustão e unilateral)
• Aquecimento 8–10 min (mobilidade de quadril)
• Agachamento frontal: 4x5–7 reps
• Avanço com halteres: 3x8–10 reps (cada perna)
• Stiff 3x8–10 reps
• Elevação de gémeos: 4x12–15 reps
• Alongamento/recuperação 6 min

Quarta — Cardio ativo + baixa carga (autonomia metabólica)
• 25–30 min de corrida leve/urbana ou bike (zona 2)
• Circuito leve: 3 voltas — 15 air squats, 12 push-ups, 20 segundos mountain climbers
• Trabalho de mobilidade 10 min

Quinta — Hipertrofia Push (alta densidade)
• Supino inclinado com halteres: 4x8–10 reps
• Paralelas assistidas / dips: 3x8–10
• Elevação lateral: 4x10–12 reps (controlado)
• Tríceps pulley: 3x10–12
• Core dinâmico: 3x 20 rep de abdominais bicicleta

Sexta — Hipertrofia Pull (técnica e volume moderado)
• Puxada na frente / pull-down: 4x8–10
• Remada em máquina (ou unilatera): 4x8–10
• Rosca direta: 3x8–10
• Facepulls: 3x12–15
• Trabalho compensatório de postura 8 min

Sábado — Condicionamento multifásico + core avançado
• Intervalos: 6x 30s sprint / 90s descanso OR 20 min AMRAP funcional
• Circuito de core avançado: prancha lateral com elevação de perna, hollow hold, Russian twist — 3 séries
• Mobilidade e respiração: 10 min

Domingo — Recuperação neural e mobilidade profunda
• Yoga leve ou sessão de mobilidade 30–40 min
• Trabalho de sono / higiene do sono e hidratação

Recomendações gerais:
• Priorizar sono 7–8h por noite.
• Proteína distribuída ao longo do dia (1.6–2.0 g/kg se objetivo recomposição/hipertrofia).
• Progresso semanal de cargas entre 2–5% onde possível.
• Autoavaliação: registrar RPE (esforço percebido) e ajustar volume conforme fadiga.

Se quiser, posso transformar essa semana em um plano com séries/exercícios alternativos (sem equipamento / só peso corporal) ou dividir em ABCD com microciclos — peça: "Converter para sem equipamento" ou "Converter para ABCD".''';
  }
}
