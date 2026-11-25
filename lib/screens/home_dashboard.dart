import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key, required this.onActivitySelected});

  final ValueChanged<int> onActivitySelected;

  static const _grammarLevels = [
    (
      title: 'Basic',
      subtitle: 'Start with grammar fundamentals',
      icon: Icons.looks_one_rounded,
      color: Color(0xFFE5F1E8),
      tag: 'START HERE'
    ),
    (
      title: 'Intermediate',
      subtitle: 'Build on what you already know',
      icon: Icons.trending_up_rounded,
      color: Color(0xFFE8EFF8),
      tag: 'COMING SOON'
    ),
    (
      title: 'Advanced',
      subtitle: 'Master more complex grammar',
      icon: Icons.workspace_premium_rounded,
      color: Color(0xFFF5EAF1),
      tag: 'COMING SOON'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary,
                  Color.lerp(primary, const Color(0xFF262C45), .38)!
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: .22),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'YOUR LEARNING SPACE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'A little practice\nevery day goes far.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose a grammar level and keep growing.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .82),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Icon(Icons.bolt_rounded,
                        color: Color(0xFFFFD166), size: 19),
                    SizedBox(width: 6),
                    Text(
                      'Ready when you are',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Grammar practice',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            'Pick the level that feels right for you.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < _grammarLevels.length; index++) ...[
            _GrammarLevelCard(
              title: _grammarLevels[index].title,
              subtitle: _grammarLevels[index].subtitle,
              tag: _grammarLevels[index].tag,
              icon: _grammarLevels[index].icon,
              tint: _grammarLevels[index].color,
              active: index == 0,
              onTap: () {
                if (index == 0) {
                  onActivitySelected(1);
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => GrammarLevelPlaceholder(
                        level: _grammarLevels[index].title,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _GrammarLevelCard extends StatelessWidget {
  const _GrammarLevelCard({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.tint,
    required this.active,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final Color tint;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tag,
                        style: TextStyle(
                          color: active
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 10,
                          letterSpacing: .8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  active
                      ? Icons.arrow_forward_rounded
                      : Icons.lock_outline_rounded,
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black38,
                ),
              ],
            ),
          ),
        ),
      );
}

class GrammarLevelPlaceholder extends StatelessWidget {
  const GrammarLevelPlaceholder({super.key, required this.level});

  final String level;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('$level Grammar')),
        body: Center(
          child: Text('$level grammar lessons are not available yet.'),
        ),
      );
}
