import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do_app/view_model/data/local/shared_keys.dart';
import 'package:to_do_app/view_model/data/network/dio_helper.dart';
import 'package:to_do_app/view_model/data/network/end_point.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  bool hidePassword = true;

  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
    emit(AppPasswordVisibilityChanged());
  }

  Future<void> login() async {
    emit(LoginLoading());
    await DioHelper.post(endPoint: EndPoints.login, body: {
      "email": emailController.text,
      "password": passwordController.text
    }).then((value) async {
      const storage = FlutterSecureStorage();
      await storage.write(
          key: SharedKeys.token, value: value.data['data']['token']);
      emit(LoginSuccess());
    }).catchError((error) {
      if (error is DioException) {
        emit(
          LoginFailed(
              errorMassage: error.response?.data['message'] ??
                  'Something went wrong on Login'),
        );
        return;
      }
      emit(
        LoginFailed(
            errorMassage: 'Something went wrong on Login ${error.toString()}'),
      );
    });
  }

  Future<void> register() async {
    emit(RegisterLoading());
    await DioHelper.post(endPoint: EndPoints.register, body: {
      'name': nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      'password_confirmation': passwordConfirmationController.text,
    },
    ).then((value) {
      DioHelper.storage.write(key: SharedKeys.token, value: value.data['data']['token']);
      emit(RegisterSuccess());
    }).catchError((error){
      if (error is DioException) {
        emit(
          RegisterFailed(
              errorMassage:  error.response?.data['message'] ??
                  'Something went wrong on Register'),
        );
        return;
      }
      emit(RegisterFailed(errorMassage: 'Something went wrong on Register ${error.toString()}'));
      throw error;
    });
  }


///// Firebase Methods Authentication  ///////  Authentication


 Future <void> registerFromFirebase () async {
   emit(RegisterLoading());
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          RegisterFailed(errorMassage : '$e')
        );
      } else if (e.code == 'email-already-in-use') {
        rethrow;
        // print('The account already exists for that email.');
      }
    } catch (e) {
      emit(RegisterFailed(errorMassage : 'Something went wrong on Register ${e.toString()}'));
      rethrow;
      // print(e);
    }
  }

  Future <void> signInFromFirebase () async {
    emit(LoginLoading());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        emit(
          LoginFailed(
              errorMassage: ' User  Not Found ${e.toString()}'),
        );
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        emit(
          LoginFailed(
              errorMassage: 'Wrong Password ${e.toString()}'),
        );
      }
    }
    emit(
      LoginFailed(
          errorMassage: 'Something went wrong on Login '),
    );
  }




}
