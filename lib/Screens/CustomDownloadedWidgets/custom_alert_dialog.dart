import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  const Dialog({
    Key? key,
    required this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final Widget child;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              elevation: 30.0,
              color: _getColor(context),
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    this.titlePadding,
    required this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    required this.actions,
    this.semanticLabel,
  }) : super(key: key);

  final Widget title;
  final EdgeInsetsGeometry? titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final List<Widget> actions;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    String? label = semanticLabel;

    children.add(Padding(
      padding: titlePadding ?? const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!,
        child: Semantics(namesRoute: true, child: title),
      ),
    ));

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label =
            semanticLabel ?? MaterialLocalizations.of(context).alertDialogLabel;
        break;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        // Handle additional platforms.
        break;
    }

    children.add(Flexible(
      child: Padding(
        padding: contentPadding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: content,
        ),
      ),
    ));

    if (actions.isNotEmpty) {
      children.add(ButtonTheme(
        child: OverflowBar(
          children: actions,
        ),
      ));
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (label != null) {
      dialogChild =
          Semantics(namesRoute: true, label: label, child: dialogChild);
    }

    return Dialog(child: dialogChild);
  }
}
