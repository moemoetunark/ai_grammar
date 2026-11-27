import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({
    super.key,
    required this.seedColor,
    required this.fontScale,
    required this.onSeedColorChanged,
    required this.onFontScaleChanged,
    this.themeMode = ThemeMode.system,
    this.onThemeModeChanged,
    this.soundEffectsEnabled = true,
    this.onSoundEffectsChanged,
    this.onResetProgress,
    this.onRateApp,
    this.onShareApp,
    this.onPrivacyPolicy,
    this.appVersion = '1.0.0',
  });

  final Color seedColor;
  final double fontScale;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<double> onFontScaleChanged;

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final bool soundEffectsEnabled;
  final ValueChanged<bool>? onSoundEffectsChanged;
  final VoidCallback? onResetProgress;
  final VoidCallback? onRateApp;
  final VoidCallback? onShareApp;
  final VoidCallback? onPrivacyPolicy;
  final String appVersion;

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  late Color _currentSeedColor;
  late double _currentFontScale;

  static const _colors = [
    Color(0xFF65A30D), // Lime
    Color(0xFF6366F1), // Indigo
    Color(0xFF0288D1), // Sky Blue
    Color(0xFF10B981), // Emerald
    Color(0xFFE65100), // Deep Orange
    Color(0xFF8A3F70), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Amber / Gold
    Color(0xFF00ACC1), // Teal
    Color(0xFF1565C0), // Deep Blue
    Color(0xFF2E7D32), // Forest Green
    Color(0xFFDC2626), // Crimson Red
  ];

  @override
  void initState() {
    super.initState();
    _currentSeedColor = widget.seedColor;
    _currentFontScale = widget.fontScale;
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Study Progress?'),
        content: const Text(
          'This will clear all completed lessons, points, and quiz scores. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Reset',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await PreferencesService().resetAllProgress();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study progress reset successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final basePreviewSize = textTheme.bodyLarge?.fontSize ?? 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: colorScheme.surfaceContainerHighest,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // 1. APPEARANCE
          const _SectionLabel('APPEARANCE & THEME'),
          _SettingsCard(
            children: [
              if (widget.onThemeModeChanged != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Theme mode', style: textTheme.titleMedium),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('System'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Light'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Dark'),
                            ),
                          ],
                          selected: {widget.themeMode},
                          onSelectionChanged: (selection) =>
                              widget.onThemeModeChanged!(selection.first),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
              ],
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose App Color Palette', style: textTheme.titleMedium),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 16,
                      runSpacing: 14,
                      children: [
                        for (final color in _colors)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _currentSeedColor = color;
                              });
                              widget.onSeedColorChanged(color);
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: _currentSeedColor.toARGB32() == color.toARGB32()
                                    ? Border.all(color: colorScheme.primary, width: 3)
                                    : null,
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: color,
                                child: _currentSeedColor.toARGB32() == color.toARGB32()
                                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                                    : null,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2. READING & STUDY
          const _SectionLabel('READING & TEXT SIZE'),
          _SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Font Scale', style: textTheme.titleMedium),
                        Text(
                          '${(_currentFontScale * 100).round()}%',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _currentFontScale,
                      min: 0.8,
                      max: 1.4,
                      divisions: 6,
                      label: '${(_currentFontScale * 100).round()}%',
                      onChanged: (scale) {
                        setState(() {
                          _currentFontScale = scale;
                        });
                        widget.onFontScaleChanged(scale);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Small (80%)', style: textTheme.bodySmall),
                        Text('Large (140%)', style: textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Preview: English grammar made comfortable.',
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: basePreviewSize * _currentFontScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onSoundEffectsChanged != null) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('Quiz sound effects'),
                  value: widget.soundEffectsEnabled,
                  onChanged: widget.onSoundEffectsChanged,
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // 3. DATA & ABOUT
          const _SectionLabel('DATA & RESET'),
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Icons.restart_alt_rounded,
                title: 'Reset study progress',
                isDestructive: true,
                onTap: () => _confirmReset(context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              'Version ${widget.appVersion}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleChildren = children.where((w) => w is! SizedBox).toList();

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: visibleChildren,
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
