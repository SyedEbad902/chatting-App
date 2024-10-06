import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class ToastService extends ChangeNotifier {
  DelightToastBar DelightToast(
      {required String text,
      required IconData icon,
      required Color circleColor,
      required Color iconColor,
      required BuildContext context}) {
    return DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      builder: (context) => ToastCard(
        color: Colors.white,
        leading: CircleAvatar(
          backgroundColor: circleColor,
          radius: 20,
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
