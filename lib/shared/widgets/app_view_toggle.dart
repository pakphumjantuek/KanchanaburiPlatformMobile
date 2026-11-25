import 'package:flutter/material.dart';

class ToggleOption<T> {
  final T value;
  final String label;
  final IconData icon;

  const ToggleOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class AppViewToggle<T> extends StatelessWidget {
  final T selectedValue;
  final List<ToggleOption<T>> options;
  final ValueChanged<T> onChanged;
  final Color activeColor;

  const AppViewToggle({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.activeColor = const Color(0xFFD96C2C),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedValue == option.value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        option.icon,
                        size: 18,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        option.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
