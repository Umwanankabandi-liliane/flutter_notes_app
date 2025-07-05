import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'domain/services/auth_service.dart';
import 'data/repositories/note_repository.dart';
import 'presentation/cubits/auth_cubit.dart';
import 'presentation/cubits/auth_state.dart';
import 'presentation/cubits/notes_cubit.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        RepositoryProvider<NoteRepository>(
          create: (context) => NoteRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              context.read<AuthService>(),
            ),
          ),
          BlocProvider<NotesCubit>(
            create: (context) => NotesCubit(
              context.read<NoteRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return NotesScreen();
              } else {
                return const AuthScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
