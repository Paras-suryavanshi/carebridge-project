import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/message_model.dart';

class CareAIScreen extends StatefulWidget {
  const CareAIScreen({super.key});

  @override
  State<CareAIScreen> createState() => _CareAIScreenState();
}

class _CareAIScreenState extends State<CareAIScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  AnimationController? _pulseController;
  AnimationController? _micController;
  bool _isListening = false;
  bool _isTyping = false;

  final List<MessageModel> _messages = [
    MessageModel(
      id: '1',
      content:
          'Hello! I\'m your Care AI assistant. 👋\n\nHow can I help you today? You can type or speak your health concerns.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _pulseController?.dispose();
    _micController?.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        MessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: text,
            isUser: true,
            timestamp: DateTime.now()),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response with typing indicator
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          MessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content:
                'Thank you for sharing your concern. I understand you mentioned: "$text"\n\nBased on your health profile, here are my recommendations:\n\n✓ Monitor your vitals regularly\n✓ Stay hydrated\n✓ Take prescribed medications on time\n\nWould you like me to schedule a check-up with your doctor?',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _micController?.forward();
      // TODO: Implement actual speech recognition here
      // For now, simulate voice input
      Future.delayed(const Duration(seconds: 3), () {
        if (_isListening && mounted) {
          _sendMessage(
              'I have been feeling a bit tired lately and my blood pressure seems high');
          setState(() {
            _isListening = false;
          });
          _micController?.reverse();
        }
      });
    } else {
      _micController?.reverse();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleQuickAction(String action) {
    _sendMessage(action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // Dynamic AI Logo
            _DynamicAILogo(pulseController: _pulseController),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppStrings.careAITitle,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isListening ? 'Listening...' : AppStrings.online,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color:
                                  _isListening ? Colors.red : AppColors.success,
                              fontWeight: _isListening
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Actions
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickActionChip(
                      AppStrings.checkVitals,
                      () => _handleQuickAction('Check my vitals'),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickActionChip(
                      AppStrings.medicationReminders,
                      () => _handleQuickAction('Remind me about medications'),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickActionChip(
                      AppStrings.healthTips,
                      () => _handleQuickAction('Give me health tips'),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickActionChip(
                      AppStrings.moodCheck,
                      () => _handleQuickAction('How is my mood today?'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: _buildMessageBubble(message),
                );
              },
            ),
          ),

          // Input Field with Voice Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Voice Input Button
                  _VoiceMicrophoneButton(
                    isListening: _isListening,
                    onTap: _toggleListening,
                    micController: _micController,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: _isListening
                            ? 'Listening to your voice...'
                            : AppStrings.askAnything,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.chat_bubble_outline,
                          color: AppColors.primary.withOpacity(0.5),
                          size: 20,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                      enabled: !_isListening,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded,
                          color: AppColors.white),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: AppColors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: message.isUser ? AppColors.primaryGradient : null,
                    color: message.isUser ? null : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: message.isUser
                              ? AppColors.white
                              : AppColors.textPrimary,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.formattedTime,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DynamicAILogo(pulseController: _pulseController, size: 32),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FadeIn(
                    delay: Duration(milliseconds: index * 200),
                    duration: const Duration(milliseconds: 600),
                    child: FadeOut(
                      delay: Duration(milliseconds: 600 + index * 200),
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dynamic animated AI Logo widget
class _DynamicAILogo extends StatelessWidget {
  final AnimationController? pulseController;
  final double size;

  const _DynamicAILogo({
    this.pulseController,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (pulseController == null) {
      // Fallback static logo
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: Icon(
          Icons.psychology_rounded,
          color: Colors.white,
          size: size * 0.5,
        ),
      );
    }

    return AnimatedBuilder(
      animation: pulseController!,
      builder: (context, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea)
                    .withOpacity(0.3 + pulseController!.value * 0.2),
                blurRadius: 15 + pulseController!.value * 10,
                spreadRadius: 1 + pulseController!.value * 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing ring
              Transform.scale(
                scale: 1 + pulseController!.value * 0.15,
                child: Container(
                  width: size * 0.85,
                  height: size * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white
                          .withOpacity(0.3 - pulseController!.value * 0.3),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // AI Icon
              Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: size * 0.5,
              ),
              // Sparkle effect
              Positioned(
                top: size * 0.15,
                right: size * 0.15,
                child: Transform.rotate(
                  angle: pulseController!.value * 2 * math.pi,
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white.withOpacity(0.8),
                    size: size * 0.25,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Voice Microphone Button with animated listening state
class _VoiceMicrophoneButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;
  final AnimationController? micController;

  const _VoiceMicrophoneButton({
    required this.isListening,
    required this.onTap,
    this.micController,
  });

  @override
  Widget build(BuildContext context) {
    if (micController == null) {
      // Fallback static button
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isListening
                ? const LinearGradient(
                    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                  )
                : LinearGradient(
                    colors: [
                      const Color(0xFF11998e).withOpacity(0.1),
                      const Color(0xFF38ef7d).withOpacity(0.1),
                    ],
                  ),
            border: Border.all(
              color: isListening
                  ? const Color(0xFFf5576c)
                  : const Color(0xFF11998e).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none_rounded,
            color: isListening ? Colors.white : const Color(0xFF11998e),
            size: 28,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: micController!,
        builder: (context, child) {
          return Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isListening
                  ? const LinearGradient(
                      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                    )
                  : LinearGradient(
                      colors: [
                        const Color(0xFF11998e).withOpacity(0.1),
                        const Color(0xFF38ef7d).withOpacity(0.1),
                      ],
                    ),
              border: Border.all(
                color: isListening
                    ? const Color(0xFFf5576c)
                    : const Color(0xFF11998e).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: isListening
                  ? [
                      BoxShadow(
                        color: const Color(0xFFf5576c).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated circles when listening
                if (isListening) ...[
                  _buildPulseCircle(0.6, 0),
                  _buildPulseCircle(0.8, 300),
                  _buildPulseCircle(1.0, 600),
                ],
                // Microphone icon
                Transform.scale(
                  scale: isListening ? 1.1 : 1.0,
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none_rounded,
                    color: isListening ? Colors.white : const Color(0xFF11998e),
                    size: 28,
                  ),
                ),
                // Listening wave effect
                if (isListening)
                  Positioned(
                    bottom: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: _buildWaveBar(index),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPulseCircle(double scale, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: scale * value,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(1 - value),
                width: 2,
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop animation
      },
    );
  }

  Widget _buildWaveBar(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 2.0, end: 8.0),
      duration: Duration(milliseconds: 300 + index * 100),
      builder: (context, value, child) {
        return Container(
          width: 2,
          height: value,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      },
      onEnd: () {
        // Loop animation
      },
    );
  }
}
