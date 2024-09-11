import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/view/screens/home_screen/home_screen.dart';
import 'package:to_do_app/view_model/cubits/auth/auth_cubit.dart';
import 'package:to_do_app/view_model/utils/app_colors.dart';
import '../../../view_model/utils/app_navigate.dart';
import '../../../view_model/utils/local_keys.g.dart';
import '../login_screen/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocProvider.value(
      value: AuthCubit.get(context),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            AppNavigation.pushAndRemove(context, const HomeScreen());
          } else if (state is RegisterFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMassage!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/icons/logo.png',
                            height: 180,
                            width: 180,
                          ),
                        ),
                        Center(
                          child: Text(
                            LocaleKeys.signup.tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.sp,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        TextFormField(
                          controller: AuthCubit.get(context).nameController,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.user_name.tr(),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: AuthCubit.get(context).emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.email.tr(),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: AuthCubit.get(context).passwordController,
                          validator: (value) {
                            List<String> errors = [];
                            if (value == null || value.isEmpty) {
                              errors.add('Please enter your password');
                            }
                            if (value!.length < 8) {
                              errors.add(
                                  'Password must be at least 8 characters long');
                            }
                            if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                              errors.add(
                                  'Password must include a lowercase letter');
                            }
                            if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                              errors.add(
                                  'Password must include an uppercase letter');
                            }
                            if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                              errors.add('Password must include a number');
                            }
                            if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                              errors.add(
                                  'Password must include a special character');
                            }
                            if (errors.isEmpty) {
                              return null;
                            }
                            return errors.join('\n');
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          obscureText: AuthCubit.get(context).hidePassword, // تعديل هنا
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            labelText: LocaleKeys.password.tr(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                AuthCubit.get(context)
                                    .togglePasswordVisibility();
                              },
                              icon: Icon(
                                AuthCubit.get(context).hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility, // تعديل هنا
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: AuthCubit.get(context)
                              .passwordConfirmationController,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          textInputAction: TextInputAction.next,
                          obscureText: AuthCubit.get(context).hidePassword, // تعديل هنا
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            labelText: LocaleKeys.password_confirmation.tr(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                AuthCubit.get(context)
                                    .togglePasswordVisibility();
                              },
                              icon: Icon(
                                AuthCubit.get(context).hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility, // تعديل هنا
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: state is RegisterLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                AuthCubit.get(context).register();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 125.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              LocaleKeys.signup.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.already_have_account.tr(),
                              style:
                              const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                AppNavigation.pushAndRemove(
                                    context, const LoginScreen());
                              },
                              child: Text(
                                LocaleKeys.login.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
