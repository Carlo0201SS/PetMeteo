import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback? onTap; // <-- callback opzionale per il tap

  const MenuIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
    this.onTap, // <-- aggiunto
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        // <-- GestureDetector rende tappabile
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          color: color,
          child: Icon(icon, color: Colors.grey.shade600, size: size),
        ),
      ),
    );
  }
  
}
























