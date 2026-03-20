import 'package:flutter/material.dart';
import '../theme/theme.dart';

class DeyeCredentialsDialog extends StatefulWidget {
  const DeyeCredentialsDialog({super.key, required this.onSave});

  final Future<void> Function(String username, String password) onSave;

  /// Convenience factory — shows the dialog and returns when it is dismissed.
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(String username, String password) onSave,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeyeCredentialsDialog(onSave: onSave),
    );
  }

  @override
  State<DeyeCredentialsDialog> createState() => _DeyeCredentialsDialogState();
}

class _DeyeCredentialsDialogState extends State<DeyeCredentialsDialog> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _passwordObscured = true;
  bool _loading = false;
  String? _errorMessage;

  bool get _canSubmit =>
      _usernameCtrl.text.isNotEmpty && _passwordCtrl.text.isNotEmpty;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await widget.onSave(_usernameCtrl.text, _passwordCtrl.text);
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
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusXl),
      title: const Text(
        'Connect Deye Cloud',
        style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField(
              controller: _usernameCtrl,
              label: 'Username',
              hint: 'Deye Cloud username',
            ),
            const SizedBox(height: AppSpacing.sp3),
            _buildField(
              controller: _passwordCtrl,
              label: 'Password',
              hint: 'Deye Cloud password',
              obscure: _passwordObscured,
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed: () =>
                    setState(() => _passwordObscured = !_passwordObscured),
              ),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge([_usernameCtrl, _passwordCtrl]),
      builder: (context, _) {
        return TextFormField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
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
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            suffixIcon: suffixIcon,
          ),
          onChanged: (_) => setState(() {}),
        );
      },
    );
  }
}
