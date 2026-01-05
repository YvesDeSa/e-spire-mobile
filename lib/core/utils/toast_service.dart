import 'package:flutter/material.dart';
import '../../components/molecules/animated_toast_widget.dart'; // Importe o novo widget

class ToastService {
  static OverlayEntry? _overlayEntry;
  // Definimos a duração aqui para ser consistente
  static const Duration _toastDuration = Duration(seconds: 4);

  static void show(BuildContext context, String title, String message, ToastType type) {
    // Se já houver um, remove imediatamente antes de mostrar o próximo
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16, // Topo seguro + margem
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AnimatedToastWidget(
            title: title,
            message: message,
            type: type,
            duration: _toastDuration,
            // Esta função será chamada pelo widget quando a barra chegar a 0
            onDismissed: () {
              _removeOverlay();
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // Função auxiliar para limpar o overlay
  static void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static void success(BuildContext context, String message) {
    show(context, "Sucesso", message, ToastType.success);
  }

  static void error(BuildContext context, String message, {String title = "Erro"}) {
    show(context, title, message, ToastType.error);
  }

  static void info(BuildContext context, String message) {
    show(context, "Atenção", message, ToastType.info);
  }
}