import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  const ButtonOne({super.key, required this.text, required this.icon, required this.onTap});
  final String text;
  final Icon icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon.icon),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
