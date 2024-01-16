import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class showLoading extends StatelessWidget{
  const showLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black12,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(bottom: 80),
        child: LoadingAnimationWidget.waveDots(
            color: const Color(0xFF6342E8),
            size: 80,
        ),
    );
  }
}