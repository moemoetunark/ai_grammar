import 'package:flutter/material.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({
    super.key,
    required this.seedColor,
    required this.fontScale,
    required this.onSeedColorChanged,
    required this.onFontScaleChanged,
  });

  final Color seedColor;
  final double fontScale;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<double> onFontScaleChanged;

  static const _colors = [
    Color(0xFF65A30D),
    Color(0xFF633C32),
    Color(0xFF315C8C),
    Color(0xFF39734A),
    Color(0xFF8A3F70),
    Color(0xFFB36B16),
  ];

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          Text('App color theme',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            children: [
              for (final color in _colors)
                InkWell(
                  onTap: () => onSeedColorChanged(color),
                  customBorder: const CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: color,
                    child: seedColor == color
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Text size · ${(fontScale * 100).round()}%',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: fontScale,
            min: 0.8,
            max: 1.4,
            divisions: 6,
            label: '${(fontScale * 100).round()}%',
            onChanged: onFontScaleChanged,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Small'), Text('Large')],
          ),
          const SizedBox(height: 20),
          Text(
            'Preview: English learning made comfortable.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
}
