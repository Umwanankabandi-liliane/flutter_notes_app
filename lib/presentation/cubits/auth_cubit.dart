import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authService.signUp(email, password);
      // State will be updated by the stream listener
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authService.signIn(email, password);
      // State will be updated by the stream listener
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
