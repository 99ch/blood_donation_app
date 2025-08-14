import 'package:flutter/material.dart';

/// Widget pour gérer les états de chargement
class LoadingWrapper extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;
  final Color? backgroundColor;

  const LoadingWrapper({
    super.key,
    required this.child,
    this.isLoading = false,
    this.loadingMessage,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  if (loadingMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      loadingMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Widget pour afficher des erreurs avec retry
class ErrorWrapper extends StatelessWidget {
  final Widget child;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool hasError;

  const ErrorWrapper({
    super.key,
    required this.child,
    this.errorMessage,
    this.onRetry,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage ?? 'Une erreur est survenue',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Réessayer'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return child;
  }
}

/// Widget pour afficher un état vide
class EmptyStateWrapper extends StatelessWidget {
  final Widget child;
  final bool isEmpty;
  final String? emptyMessage;
  final IconData? emptyIcon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWrapper({
    super.key,
    required this.child,
    this.isEmpty = false,
    this.emptyMessage,
    this.emptyIcon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                emptyIcon ?? Icons.inbox_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage ?? 'Aucune donnée disponible',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (onAction != null && actionText != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionText!),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return child;
  }
}

/// Widget combiné pour gérer loading, error et empty states
class StateWrapper extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final String? loadingMessage;
  final String? errorMessage;
  final String? emptyMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onAction;
  final String? actionText;

  const StateWrapper({
    super.key,
    required this.child,
    this.isLoading = false,
    this.hasError = false,
    this.isEmpty = false,
    this.loadingMessage,
    this.errorMessage,
    this.emptyMessage,
    this.onRetry,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: isLoading,
      loadingMessage: loadingMessage,
      child: ErrorWrapper(
        hasError: hasError,
        errorMessage: errorMessage,
        onRetry: onRetry,
        child: EmptyStateWrapper(
          isEmpty: isEmpty,
          emptyMessage: emptyMessage,
          onAction: onAction,
          actionText: actionText,
          child: child,
        ),
      ),
    );
  }
}
