import 'package:flutter/material.dart';
import '../theme/theme.dart';

class SolcastCredentialsDialog extends StatefulWidget {
  const SolcastCredentialsDialog({super.key, required this.onSave});

  final Future<void> Function(String apiKey, String siteId) onSave;

  /// Convenience factory — shows the dialog and returns when it is dismissed.
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(String apiKey, String siteId) onSave,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SolcastCredentialsDialog(onSave: onSave),
    );
  }

  @override
  State<SolcastCredentialsDialog> createState() =>
      _SolcastCredentialsDialogState();
}

class _SolcastCredentialsDialogState extends State<SolcastCredentialsDialog> {
  final _apiKeyCtrl = TextEditingController();
  final _siteIdCtrl = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  bool get _canSubmit =>
      _apiKeyCtrl.text.isNotEmpty && _siteIdCtrl.text.isNotEmpty;

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    _siteIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await widget.onSave(_apiKeyCtrl.text.trim(), _siteIdCtrl.text.trim());
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
        'Connect Solcast',
        style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your Solcast API key and rooftop site resource ID. '
              'Find these in your Solcast Toolkit account under API → Rooftop Sites.',
              style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.sp3),
            _buildField(
              controller: _apiKeyCtrl,
              label: 'API Key',
              hint: 'Your Solcast API key',
            ),
            const SizedBox(height: AppSpacing.sp3),
            _buildField(
              controller: _siteIdCtrl,
              label: 'Site Resource ID',
              hint: 'e.g. 1234-5678-abcd-ef00',
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
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge([_apiKeyCtrl, _siteIdCtrl]),
      builder: (context, _) {
        return TextFormField(
          controller: controller,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
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
              borderSide:
                  const BorderSide(color: AppColors.outlineVariant, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          onChanged: (_) => setState(() {}),
        );
      },
    );
  }
}
