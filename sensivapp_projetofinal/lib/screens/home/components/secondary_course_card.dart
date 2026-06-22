import 'package:flutter/material.dart';

class SecondaryCourseCard extends StatefulWidget {
  const SecondaryCourseCard({
    super.key,
    required this.title,
    this.color = const Color(0xFF7553F6),
  });

  final String title;
  final Color color;

  @override
  State<SecondaryCourseCard> createState() => _SecondaryCourseCardState();
}

class _SecondaryCourseCardState extends State<SecondaryCourseCard> {
  bool isChecked = false;
  double _elevation = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _elevation = 5),
      onExit: (_) => setState(() => _elevation = 0),
      child: AnimatedPhysicalModel(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
        elevation: _elevation,
        color: Colors.white,
        shadowColor: widget.color.withOpacity(0.3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: widget.color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "Prescrição médica",
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    )
                  ],
                ),
              ),
              Checkbox(
                activeColor: widget.color,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
