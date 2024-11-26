/// Returns a boolean indicating whether the provided [FocusNode] is currently focused.
///
/// This hook listens for focus changes on the given [FocusNode] and updates its state
/// accordingly. It utilizes Flutter Hooks to manage the lifecycle of the listener.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

bool useIsFocused(FocusNode node) {
  final isFocused = useState(node.hasFocus);

  useEffect(
    () {
      void listener() {
        isFocused.value = node.hasFocus;
      }

      node.addListener(listener);
      return () => node.removeListener(listener);
    },
    [node],
  );

  return isFocused.value;
}
