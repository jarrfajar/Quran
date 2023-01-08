import 'package:flutter/material.dart';
import 'package:quran/app/data/constant/colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavagationBar extends StatefulWidget {
  final int controller;
  final Function(int value) onChanged;
  final String? label;

  const NavagationBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.label,
  }) : super(key: key);

  @override
  State<NavagationBar> createState() => _NavagationBarState();
}

class _NavagationBarState extends State<NavagationBar> {
  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: widget.controller,
      onTap: (i) => widget.onChanged(i),
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: appPurpleLight1,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.location_on_rounded),
          title: const Text("Sholat"),
          selectedColor: appPurpleLight1,
        ),
      ],
    );
  }
}
