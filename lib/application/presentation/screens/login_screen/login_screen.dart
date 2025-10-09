import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player_media/application/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AuthController>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Your\nMobile Number',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae. Et tortor at vehicula euismod mi viverra.',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+91',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 60, // desired height
                        child: TextFormField(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          controller: controller.phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mobile number';
                            } else if (value.length != 10) {
                              return 'Mobile number must be 10 digits';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Only numeric digits allowed';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // allow only numbers
                            LengthLimitingTextInputFormatter(
                              10,
                            ), // limit to 10 digits
                          ],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter Mobile Number",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black,
                            isDense:
                                true, // reduces internal padding for better height control
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ), // adjust vertical to center text
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white54,
                                width: 0.8,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 250),
                Align(
                  alignment: Alignment.topCenter,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey), // border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        context.read<AuthController>().login(context);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        Consumer<AuthController>(
                          builder: (context, ref, _) {
                            if (ref.isLoading) {
                              return const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
