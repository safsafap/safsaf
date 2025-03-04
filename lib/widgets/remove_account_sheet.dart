import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/screens/accuel_screen.dart';
import 'package:multi_vendor/services/login_service.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showError = false;
  final _accountController = Get.find<AccountController>(tag: "account");

  Future<void> _confirmDelete() async {
    if (_passwordController.text.isEmpty) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    _showError = !(await LoginService().deleteAccount(
        id: _accountController.user?.id ?? 0,
        password: _passwordController.text));

    print("showError : $_showError");

    if (!_showError) {
      await _accountController.Logout(remove: true);
      Get.offAll(() => AccuelScreen());
    } else {
      if (!mounted) return;
      setState(() {
        _showError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(24),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Delete Account'.tr,
              style:const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action is permanent and cannot be undone. Please enter your password to confirm.'.tr,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password'.tr,
                prefixIcon: const Icon(Icons.lock_outline, size: 22),
                border: const OutlineInputBorder(),
                errorText: _showError ? 'Incorrect password'.tr : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 14,
                ),
              ),
              onChanged: (value) {
                if (_showError) setState(() => _showError = false);
              },
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    :  Text(
                        'Delete Account Permanently'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
