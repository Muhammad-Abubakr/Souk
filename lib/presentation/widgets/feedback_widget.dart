// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FeedbackWidget extends StatelessWidget {
  // configurables
  final String title;
  final Image image;
  final String buttonLabel;
  final IconData buttonIcon;
  final void Function() onPressed;

  const FeedbackWidget({
    Key? key,
    required this.title,
    required this.image,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall!.copyWith(
              color: theme.primaryColor,
              fontFamily: 'lato',
            ),
          ),
          const Spacer(flex: 1),
          image,
          const Spacer(flex: 2),
          TextButton.icon(
            onPressed: onPressed,
            icon: Icon(buttonIcon),
            label: Text(buttonLabel),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
