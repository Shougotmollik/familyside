import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:familyside/core/theme/app_colors.dart';
import 'package:familyside/view/widgets/custom_app_bar.dart';
import 'package:familyside/view/widgets/custom_elevated_button.dart';

class SpPaymentScreen extends StatefulWidget {
  const SpPaymentScreen({
    super.key,
    required this.planName,
    required this.price,
  });

  final String planName;
  final String price;

  @override
  State<SpPaymentScreen> createState() => _SpPaymentScreenState();
}

class _SpPaymentScreenState extends State<SpPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedMethod = 0;
  bool _saveCard = false;

  final _nameCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  final List<_PaymentMethod> _methods = const [
    _PaymentMethod(label: 'stripe', color: Color(0xFF6772E5)),
    _PaymentMethod(label: 'VISA', color: Color(0xFF1A1F71)),
    _PaymentMethod(label: 'PayPal', color: Color(0xFF003087)),
    _PaymentMethod(label: 'AMEX', color: Color(0xFF007BC1)),
    _PaymentMethod(label: 'MC', color: Color(0xFFEB001B)),
    _PaymentMethod(label: 'DISC', color: Color(0xFFFF6600)),
  ];

  @override
  void initState() {
    super.initState();
    _cardCtrl.addListener(_formatCardNumber);
    _expiryCtrl.addListener(_formatExpiry);
  }

  void _formatCardNumber() {
    final text = _cardCtrl.text.replaceAll(' ', '');
    if (text.isEmpty) return;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    if (formatted != _cardCtrl.text) {
      _cardCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _formatExpiry() {
    final text = _expiryCtrl.text.replaceAll('/', '');
    if (text.isEmpty) return;
    if (text.length > 4) {
      _expiryCtrl.text = text.substring(0, 4);
    }
    if (text.length >= 3) {
      final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      if (formatted != _expiryCtrl.text) {
        _expiryCtrl.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _cardCtrl.removeListener(_formatCardNumber);
    _expiryCtrl.removeListener(_formatExpiry);
    _nameCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment processing...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppBar(title: 'Payment method'),
                        SizedBox(height: 20.h),

                        Container(
                          width: double.infinity,
                          height: 110.h,
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD94F6B), Color(0xFF9B2D6F)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    '\$${widget.price.replaceAll('\$', '')}.00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.card_giftcard,
                                  size: 64.sp,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        Text(
                          'Select your payment method',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 14.h),

                        Row(
                          children: List.generate(_methods.length, (i) {
                            final m = _methods[i];
                            final sel = _selectedMethod == i;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedMethod = i),
                              child: Container(
                                margin: EdgeInsets.only(right: 8.w),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 7.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: sel ? m.color : AppColors.border,
                                    width: sel ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  m.label,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    color: m.color,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 24.h),

                        _label('Card holder name'),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDecoration('Your name'),
                          style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Enter card holder name' : null,
                        ),
                        SizedBox(height: 16.h),

                        _label('Card number'),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _cardCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: _inputDecoration('1234 5678 9012 3456'),
                          style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter card number';
                            final digits = v.replaceAll(' ', '');
                            if (digits.length < 13) return 'Invalid card number';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Valid until'),
                                  SizedBox(height: 8.h),
                                  TextFormField(
                                    controller: _expiryCtrl,
                                    keyboardType: TextInputType.datetime,
                                    decoration: _inputDecoration('MM/YY'),
                                    style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return 'Enter expiry date';
                                      if (v.length < 5) return 'Invalid date';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('CVV'),
                                  SizedBox(height: 8.h),
                                  TextFormField(
                                    controller: _cvvCtrl,
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    decoration: _inputDecoration('***'),
                                    style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return 'Enter CVV';
                                      if (v.length < 3) return 'Invalid CVV';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        GestureDetector(
                          onTap: () => setState(() => _saveCard = !_saveCard),
                          child: Row(
                            children: [
                              Container(
                                width: 18.w,
                                height: 18.w,
                                decoration: BoxDecoration(
                                  color: _saveCard ? AppColors.primaryLight : Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                  border: Border.all(
                                    color: _saveCard
                                        ? AppColors.primaryLight
                                        : AppColors.lightText.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: _saveCard
                                    ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                                    : null,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Save card data for future payments',
                                style: TextStyle(fontSize: 13.sp, color: AppColors.lightText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                  child: CustomElevatedButton(
                    onPressed: _onSubmit,
                    title: 'Proceed to confirm',
                    color: AppColors.primaryLight,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.lightText),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.lightText.withValues(alpha: 0.25), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.lightText.withValues(alpha: 0.25), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.error, width: 1.2),
      ),
      errorStyle: TextStyle(fontSize: 11.sp, color: AppColors.error),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.text,
    ),
  );
}

class _PaymentMethod {
  final String label;
  final Color color;
  const _PaymentMethod({required this.label, required this.color});
}
