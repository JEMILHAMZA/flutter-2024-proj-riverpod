// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:quiz_app/features/auth/data/datasources/auth_local_datasource.dart';
// import 'package:quiz_app/features/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:quiz_app/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:quiz_app/features/auth/domain/repositories/auth_repository.dart';
// import 'package:quiz_app/features/auth/presentation/bloc/auth_bloc.dart';

// final serviceLocator = GetIt.instance;

// Future<void> init() async {
//   // External dependencies
//   final sharedPreferences = await SharedPreferences.getInstance();
//   serviceLocator
//     ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)

//     // Data sources
//     ..registerLazySingleton<AuthLocalDataSource>(
//         () => AuthLocalDataSource(sharedPreferences: serviceLocator()));

//   serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() =>
//       AuthRemoteDataSource(
//           baseURL: 'http://localhost:3000', localDataSource: serviceLocator()));

//   // Repositories
//   serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
//         authLocalDataSource: serviceLocator(),
//         authRemoteDataSource: serviceLocator(),
//       ));
//   // Blocs
//   serviceLocator.registerFactory(() => AuthBloc(repository: serviceLocator()));
// }

//note data sources
import 'package:quiz_app/core/utils/utility_objects.dart';
import 'package:quiz_app/features/notes/data/datasources/note_local_datasource.dart';
import 'package:quiz_app/features/notes/data/datasources/note_remote_datasource.dart';
import 'package:quiz_app/features/notes/data/repositories/note_repository_impl.dart';
import 'package:quiz_app/features/notes/domain/usecases/create_note_usecase.dart';
import 'package:quiz_app/features/notes/domain/usecases/delete_note_usecase.dart';
import 'package:quiz_app/features/notes/domain/usecases/get_note_usecase.dart';
import 'package:quiz_app/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:quiz_app/features/notes/presentation/bloc/note_state.dart';
import 'package:quiz_app/features/notes/presentation/note_riverpod/note_notifier.dart';
import 'package:riverpod/riverpod.dart';

void init() {
  final noteLocalDatasource = NoteLocalDatasource();
  final noteRemoteDatasource = NoteRemoteDatasource(
      baseURL: 'baseUrl', localDataSource: LocalDataSource);
  final noteRepository = NoteRepositoryImpl(
      noteLocalDatasource: noteLocalDatasource,
      noteRemoteDatasource: noteRemoteDatasource);

  //note usecases
  final createNote = CreateNote(noteRepository);
  final deleteNote = DeleteNote(noteRepository);
  final getNote = GetNote(noteRepository);
  final updateNote = UpdateNote(noteRepository);

  //define note providers
  final createNoteProvider = Provider<CreateNote>((ref) {
    return createNote;
  });

  final deleteNoteProvider = Provider<DeleteNote>((ref) {
    return deleteNote;
  });

  final getNoteProvider = Provider<GetNote>((ref) {
    return getNote;
  });

  final updateNoteProvider = Provider<UpdateNote>((ref) {
    return updateNote;
  });

  // setup noteNotifierProvider
  final noteNotifierProvider =
      StateNotifierProvider<NoteNotifier, NoteState>((ref) {
    final createNote = ref.watch(createNoteProvider);
    final deleteNote = ref.watch(deleteNoteProvider);
    final getNote = ref.watch(getNoteProvider);
    final updateNote = ref.watch(updateNoteProvider);

    return NoteNotifier(
      createNote: createNote,
      deleteNote: deleteNote,
      getNote: getNote,
      updateNote: updateNote,
    );
  });
}
