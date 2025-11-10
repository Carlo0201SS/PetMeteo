import 'package:flutter/material.dart';
import 'package:petmeteo/UI/components3/AppLabelText16.dart';

class MenuOpened extends StatelessWidget {
  final List<String> optionLabels;
  const MenuOpened({super.key, required this.optionLabels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seleziona un'opzione")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
          children: [
            _buildGridItem(context, Icons.map, optionLabels[0], null),
            _buildGridItem(
              context,
              Icons.notifications_active,
              optionLabels[1],
              null,
            ),

            //  QUI: vai alla schermata del carosello
            _buildGridItem(context, Icons.pets, optionLabels[2], () {
              Navigator.pushReplacementNamed(context, '/');
            }),

            _buildGridItem(context, Icons.share, optionLabels[3], null),
          ],
        ),
      ),
    );
  }



  Widget _buildGridItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.black),
            const Spacer(),
            AppLabelText16(text: label),
          ],
        ),
      ),
    );
  }
}
















































