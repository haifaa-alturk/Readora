import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

class RechargeWalletScreen extends StatefulWidget {
  const RechargeWalletScreen({super.key});

  @override
  State<RechargeWalletScreen> createState() => _RechargeWalletScreenState();
}

class _RechargeWalletScreenState extends State<RechargeWalletScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  String? _receiptImagePath;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // اختيار صورة إيصال الدفع من المعرض
  Future<void> _pickReceiptImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      if (!mounted) return;

      setState(() {
        _receiptImagePath = image.path;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء اختيار الصورة: $e')),
      );
    }
  }

  void _submit() {
    // التحقق من المبلغ
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // التحقق من وجود صورة الإيصال
    if (_receiptImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صورة إيصال الدفع')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('المبلغ غير صالح')));
      return;
    }

    // إرسال طلب الشحن إلى الباك
    context.read<WalletBloc>().add(
      RechargeWalletEvent(amount: amount, receiptImagePath: _receiptImagePath!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Recharge Wallet',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          // =========================
          // SUCCESS
          // =========================

          if (state is WalletRechargeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xff54a747),
              ),
            );

            // نرجع للـ WalletScreen
            // ونرسل true حتى يعمل Reload.
            Navigator.pop(context, true);
          }

          // =========================
          // ERROR
          // =========================

          if (state is WalletRechargeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xffe61b72),
              ),
            );
          }
        },

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  // =========================
                  // INFORMATION
                  // =========================
                  const Text(
                    'Recharge your wallet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Enter the amount you transferred and upload your payment receipt. Your request will be reviewed by the administrator.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // AMOUNT
                  // =========================
                  const Text(
                    'Recharge Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _amountController,

                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    decoration: InputDecoration(
                      labelText: 'Amount (SYP)',
                      hintText: 'Minimum 1000 SYP',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      prefixIcon: const Icon(Icons.payments_outlined),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount';
                      }

                      final amount = double.tryParse(value.trim());

                      if (amount == null) {
                        return 'Please enter a valid amount';
                      }

                      // مطابق للباك:
                      // 'amount'=>'required|numeric|min:1000'
                      if (amount < 1000) {
                        return 'Minimum recharge amount is 1000 SYP';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // RECEIPT
                  // =========================
                  const Text(
                    'Payment Receipt',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Upload the receipt image for your payment.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: _pickReceiptImage,

                    child: Container(
                      height: 180,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.4),
                        ),
                      ),

                      child: _receiptImagePath == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 44,
                                  color: Color(0xffe61b72),
                                ),

                                SizedBox(height: 10),

                                Text(
                                  'Select payment receipt',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  'JPG, JPEG or PNG',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),

                                SizedBox(height: 3),

                                Text(
                                  'Maximum size: 2 MB',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                File(_receiptImagePath!),

                                width: double.infinity,

                                height: 180,

                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  // =========================
                  // CHANGE RECEIPT
                  // =========================
                  if (_receiptImagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),

                      child: TextButton.icon(
                        onPressed: _pickReceiptImage,

                        icon: const Icon(Icons.image_outlined),

                        label: const Text('Change receipt'),
                      ),
                    ),

                  const Spacer(),

                  // =========================
                  // SEND REQUEST
                  // =========================
                  BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      final loading = state is WalletRechargeLoading;

                      return SizedBox(
                        height: 52,

                        child: ElevatedButton(
                          onPressed: loading ? null : _submit,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffe61b72),

                            foregroundColor: Colors.white,

                            disabledBackgroundColor: Colors.grey.shade400,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,

                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Send Recharge Request',

                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your wallet balance will be updated after administrator approval.',
                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
