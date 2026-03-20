import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';

import 'main.dart';
import 'theme/app_theme.dart';
import 'theme/app_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Auth Screen – adaptive (mobile / desktop) entry point
// ─────────────────────────────────────────────────────────────────────────────

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: isDesktop
          ? const _DesktopAuthLayout()
          : const _MobileAuthLayout(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop layout – split panel
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopAuthLayout extends StatelessWidget {
  const _DesktopAuthLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left hero panel
        Expanded(
          flex: 55,
          child: _HeroPanel(),
        ),
        // Right sign-in panel
        Expanded(
          flex: 45,
          child: Container(
            color: AppColors.surfaceContainerLowest,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: const _SignInForm(isDesktop: true),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile layout – single-column
// ─────────────────────────────────────────────────────────────────────────────

class _MobileAuthLayout extends StatelessWidget {
  const _MobileAuthLayout();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _MobileLogo(),
            const SizedBox(height: 48),
            const _SignInForm(isDesktop: false),
            const SizedBox(height: 40),
            const _FooterLinks(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop hero panel (left side)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF060E20),
            Color(0xFF0B1326),
            Color(0xFF0E1A2E),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Ambient glow orb – top right
          Positioned(
            top: -120,
            right: -80,
            child: GlowOrb(
              color: AppColors.primary.withValues(alpha: 0.08),
              size: 500,
            ),
          ),
          // Ambient glow orb – bottom left (secondary / green)
          Positioned(
            bottom: -100,
            left: -60,
            child: GlowOrb(
              color: AppColors.secondary.withValues(alpha: 0.05),
              size: 400,
            ),
          ),
          // Energy grid decoration
          Positioned.fill(
            child: CustomPaint(painter: EnergyGridPainter()),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top brand
                Row(
                  children: [
                    _EnergyBoltIcon(size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'Deyelightful',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ],
                ),
                // Hero copy
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harness the\nLuminous Kinetic.',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 52,
                            height: 1.1,
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Precision energy management for high-performance homes.\nMonitor, optimize, and thrive.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 48),
                    // Stats row
                    const _StatsRow(),
                  ],
                ),
                // Bottom tagline
                Text(
                  'Powering your peak efficiency',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.outline,
                        letterSpacing: 0.1,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(value: '98%', label: 'Uptime'),
        const SizedBox(width: 24),
        _StatChip(value: '3.2×', label: 'Avg. ROI'),
        const SizedBox(width: 24),
        _StatChip(value: '24/7', label: 'Monitoring'),
      ],
    );
  }
}

/// Alias so the private _StatChip call below uses the shared StatChip.
typedef _StatChip = StatChip;

// ─────────────────────────────────────────────────────────────────────────────
// Mobile logo header
// ─────────────────────────────────────────────────────────────────────────────

class _MobileLogo extends StatelessWidget {
  const _MobileLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _EnergyBoltIcon(size: 32),
            const SizedBox(width: 12),
            Text(
              'Deyelightful',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Powering your peak efficiency',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign-in form (shared between mobile & desktop)
// ─────────────────────────────────────────────────────────────────────────────

class _SignInForm extends StatefulWidget {
  const _SignInForm({required this.isDesktop});

  final bool isDesktop;

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verificationController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isRegisterMode = false;
  bool _isAwaitingVerification = false;
  String? _errorMessage;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _verificationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final emailAuth = EmailAuthController(client.modules.auth);
      final userInfo = await emailAuth.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (userInfo == null) {
        setState(() {
          _errorMessage = 'Invalid credentials. Please try again.';
          _isLoading = false;
        });
        _shakeController.forward(from: 0);
      }
      // On success, sessionManager listener in main.dart rebuilds the app
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Connection error. Please check the server.';
        _isLoading = false;
      });
      _shakeController.forward(from: 0);
    }
  }

  Future<void> _requestRegistration() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final emailAuth = EmailAuthController(client.modules.auth);
      final sent = await emailAuth.createAccountRequest(
        _emailController.text.trim().split('@').first,
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (!sent) {
        setState(() {
          _errorMessage = 'Could not send verification email. Email may already be in use.';
          _isLoading = false;
        });
        _shakeController.forward(from: 0);
      } else {
        setState(() {
          _isAwaitingVerification = true;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Connection error. Please check the server.';
        _isLoading = false;
      });
      _shakeController.forward(from: 0);
    }
  }

  Future<void> _verifyCode() async {
    final code = _verificationController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final emailAuth = EmailAuthController(client.modules.auth);
      final userInfo = await emailAuth.validateAccount(
        _emailController.text.trim(),
        code,
      );

      if (!mounted) return;

      if (userInfo == null) {
        setState(() {
          _errorMessage = 'Invalid or expired code. Please try again.';
          _isLoading = false;
        });
        _shakeController.forward(from: 0);
      }
      // On success, session is registered and app rebuilds
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Connection error. Please check the server.';
        _isLoading = false;
      });
      _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final offset = math.sin(_shakeAnimation.value * math.pi * 4) * 8.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            if (widget.isDesktop) ...[
              Row(
                children: [
                  _EnergyBoltIcon(size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Deyelightful',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
            Text(
              _isAwaitingVerification
                  ? 'Check your email'
                  : (_isRegisterMode
                      ? 'Create Account'
                      : (widget.isDesktop ? 'Welcome Back' : 'Welcome back')),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _isAwaitingVerification
                  ? 'We sent a verification code to ${_emailController.text.trim()}. Enter it below to activate your account.'
                  : (_isRegisterMode
                      ? 'Set up your energy management account.'
                      : (widget.isDesktop
                          ? 'Sign in to manage your energy ecosystem.'
                          : 'Sign in to your account')),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 36),

            // Email & password fields (hidden during verification step)
            if (!_isAwaitingVerification) ...[
              _AnimatedInputField(
                controller: _emailController,
                label: 'Email address',
                hint: 'you@example.com',
                prefixIcon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email address';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _AnimatedInputField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _isRegisterMode ? _requestRegistration() : _signIn(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
            ],

            // Verification code field (shown only after registration request)
            if (_isAwaitingVerification) ...[
              const SizedBox(height: 8),
              _AnimatedInputField(
                controller: _verificationController,
                label: 'Verification code',
                hint: 'Enter code from email',
                prefixIcon: Icons.verified_outlined,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _verifyCode(),
              ),
            ],

            // Forgot password (sign-in mode only)
            if (!_isRegisterMode && !_isAwaitingVerification)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: navigate to forgot password
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  widget.isDesktop ? 'Forgot Access?' : 'Forgot?',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Error message
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _errorMessage != null
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 16,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.error,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Action button
            GradientButton(
              onPressed: _isLoading
                  ? null
                  : (_isAwaitingVerification
                      ? _verifyCode
                      : (_isRegisterMode ? _requestRegistration : _signIn)),
              isLoading: _isLoading,
              label: _isAwaitingVerification
                  ? 'Verify & Activate'
                  : (_isRegisterMode ? 'Send Verification Email' : 'Sign In'),
            ),
            const SizedBox(height: 28),

            // Toggle sign-in / register (hidden during verification)
            if (!_isAwaitingVerification)
              Center(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _isRegisterMode = !_isRegisterMode;
                    _errorMessage = null;
                  }),
                  child: Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                      children: [
                        TextSpan(
                          text: _isRegisterMode
                              ? 'Already have an account? '
                              : (widget.isDesktop
                                  ? 'New to the platform? '
                                  : "Don't have an account? "),
                        ),
                        TextSpan(
                          text: _isRegisterMode
                              ? 'Sign In'
                              : (widget.isDesktop ? 'Register' : 'Join now'),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Back to register (shown during verification)
            if (_isAwaitingVerification)
              Center(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _isAwaitingVerification = false;
                    _verificationController.clear();
                    _errorMessage = null;
                  }),
                  child: Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                      children: [
                        const TextSpan(text: 'Wrong email? '),
                        TextSpan(
                          text: 'Go back',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
// Footer links (mobile only)
// ─────────────────────────────────────────────────────────────────────────────

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    final links = ['Security', 'Privacy', 'Help'];
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: links
          .map(
            (l) => TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.outline,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: Text(l),
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-components / decorative helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Animated focus-ring input field
class _AnimatedInputField extends StatefulWidget {
  const _AnimatedInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  @override
  State<_AnimatedInputField> createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<_AnimatedInputField> {
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurface,
            ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: Icon(widget.prefixIcon, size: 20),
          suffixIcon: widget.suffixIcon,
        ),
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

/// Custom lightning bolt icon using CustomPaint
class _EnergyBoltIcon extends StatelessWidget {
  const _EnergyBoltIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BoltPainter()),
    );
  }
}

class _BoltPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    // Draw a simple lightning bolt shape
    final path = Path()
      ..moveTo(size.width * 0.62, 0)
      ..lineTo(size.width * 0.25, size.height * 0.52)
      ..lineTo(size.width * 0.50, size.height * 0.52)
      ..lineTo(size.width * 0.38, size.height)
      ..lineTo(size.width * 0.75, size.height * 0.48)
      ..lineTo(size.width * 0.50, size.height * 0.48)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BoltPainter old) => false;
}
