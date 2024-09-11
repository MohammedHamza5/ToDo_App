import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/view/screens/home_screen/home_screen.dart';
import 'package:to_do_app/view_model/cubits/auth/auth_cubit.dart';
import '../../../view_model/utils/app_colors.dart';
import '../../../view_model/utils/app_navigate.dart';
import '../../../view_model/utils/local_keys.g.dart';
import '../sign_up_screen/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocProvider.value(
      value: AuthCubit.get(context),
      // create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Login Successfully"),
              ),
            );
            AppNavigation.pushAndRemove(context, const HomeScreen());
          } else if (state is LoginFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMassage),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 18.h,),
                      Center(
                        child: Image.asset(
                          'assets/icons/logo.png',
                          height: 200.h,
                          width: 200.w,
                        ),
                      ),
                      Center(
                        child: Text(
                          LocaleKeys.login.tr(),
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
                        controller: AuthCubit.get(context).emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
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
                        height: 30.h,
                      ),
                      TextFormField(
                        controller: AuthCubit.get(context).passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (kDebugMode) {
                              print('Please enter your password');
                            }
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        obscureText: AuthCubit.get(context).hidePassword,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          labelText: LocaleKeys.password.tr(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              AuthCubit.get(context).togglePasswordVisibility();
                            },
                            icon: Icon(
                              AuthCubit.get(context).hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              LocaleKeys.forgot_password.tr(),
                            ),
                          )),
                      SizedBox(
                        height: 30.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: state is LoginLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                   await AuthCubit.get(context).login();
                                   AppNavigation.pushAndRemove(context, HomeScreen());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.purpleA,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 140.w, vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r)),
                                  elevation: 5,
                                ),
                                child: Text(
                                  LocaleKeys.login.tr(),
                                  style:  TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      TextButton(
                        onPressed: () {
                          AppNavigation.navigateTo(
                            context,
                            const SignUpScreen(),
                          );
                        },
                        child: Center(
                          child: Text(
                            LocaleKeys.signup.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
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
