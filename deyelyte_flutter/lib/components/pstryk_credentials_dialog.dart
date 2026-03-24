import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PstrykCredentialsDialog extends StatefulWidget {
  const PstrykCredentialsDialog({super.key, required this.onSave});

  final Future<void> Function(String apiKey) onSave;

  /// Convenience factory — shows the dialog and returns when it is dismissed.
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(String apiKey) onSave,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PstrykCredentialsDialog(onSave: onSave),
    );
  }

  @override
  State<PstrykCredentialsDialog> createState() =>
      _PstrykCredentialsDialogState();
}

class _PstrykCredentialsDialogState extends State<PstrykCredentialsDialog> {
  final _apiKeyCtrl = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  bool get _canSubmit => _apiKeyCtrl.text.isNotEmpty;

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await widget.onSave(_apiKeyCtrl.text.trim());
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusXl),
      title: const Text(
        'Connect Pstryk',
        style:
            TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your Pstryk API token. '
              'Find it in your Pstryk account under API settings.',
              style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.sp3),
            ListenableBuilder(
              listenable: _apiKeyCtrl,
              builder: (context, _) {
                return TextFormField(
                  controller: _apiKeyCtrl,
                  style: const TextStyle(color: AppColors.onSurface),
                  decoration: InputDecoration(
                    labelText: 'API Token',
                    hintText: 'Your Pstryk API token',
                    labelStyle:
                        const TextStyle(color: AppColors.onSurfaceVariant),
                    hintStyle: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 13),
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.radiusMd,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.radiusMd,
                      borderSide: const BorderSide(
                          color: AppColors.outlineVariant, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.radiusMd,
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                );
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sp3),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sp3),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withAlpha(77),
                  borderRadius: AppRadius.radiusMd,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: AppSpacing.sp2),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: (_canSubmit && !_loading) ? _submit : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.surfaceContainerHigh,
            shape:
                RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          ),
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Connect'),
        ),
      ],
    );
  }
}
