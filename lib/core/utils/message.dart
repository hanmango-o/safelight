part of core;

class Message {
  void snackbar(
    BuildContext context, {
    required String text,
    Color? backgroundColor,
    Color? iconColor,
    EdgeInsets? margin,
    SnackBarBehavior? position,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(milliseconds: 1300),
        showCloseIcon: true,
        closeIconColor: iconColor ?? Colors.white,
        backgroundColor: backgroundColor,
        behavior: position ?? SnackBarBehavior.floating,
        margin: margin,
        dismissDirection: DismissDirection.vertical,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: Semantics.fromProperties(
          properties: const SemanticsProperties(
            liveRegion: true,
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
