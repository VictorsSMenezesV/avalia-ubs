import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meu_app/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:meu_app/features/avaliacao/data/datasources/avaliacao_firestore_datasource.dart';
import 'package:meu_app/features/avaliacao/data/datasources/denuncia_firestore_datasource.dart';
import 'package:meu_app/features/avaliacao/data/respositories/denuncia_repository_impl.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/denuncia_repository.dart';
import 'package:meu_app/features/avaliacao/domain/usecases/criar_denuncia_usecase.dart';
import 'package:meu_app/features/avaliacao/domain/usecases/editar_avaliacao_usecase.dart';
import 'package:meu_app/features/avaliacao/domain/usecases/excluir_avalicao_usecase.dart';
import 'package:meu_app/features/ubs/data/datasource/favorito_firestore_datasource.dart';
import 'package:meu_app/features/ubs/data/datasource/favorito_firestore_datasource_impl.dart';
import 'package:meu_app/features/ubs/data/datasource/loc_mock.dart';
import 'package:meu_app/features/ubs/data/datasource/localizacao_datasource.dart';
import 'package:meu_app/features/ubs/data/datasource/ubs_remote_datasource.dart';
import 'package:meu_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meu_app/features/avaliacao/data/respositories/avaliacao_repository_impl.dart';
import 'package:meu_app/features/ubs/data/datasource/ubs_remote_datasource_impl.dart';
import 'package:meu_app/features/ubs/data/repositories/favorito_repository_impl.dart';
import 'package:meu_app/features/ubs/data/repositories/ubs_repository_impl.dart';
import 'package:meu_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/avaliacao_repository.dart';
import 'package:meu_app/features/ubs/domain/repositories/favorito_repository.dart';
import 'package:meu_app/features/ubs/domain/repositories/ubs_repository.dart';
import 'package:meu_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:meu_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:meu_app/features/auth/domain/usecases/observar_usuario_logado_usecase.dart';
import 'package:meu_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:meu_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:meu_app/features/avaliacao/domain/usecases/busca_avaliacoes_por_ubs_usecase.dart';
import 'package:meu_app/features/avaliacao/domain/usecases/buscar_minhas_avaliacoes_usecase.dart';
import 'package:meu_app/features/avaliacao/domain/usecases/criar_avaliacao_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/buscar_favoritos_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/buscar_ubs_paginado_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/buscar_ubs_proxima_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/cadastrar_ubs_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/observar_is_favorito_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/obter_localizacao_atual_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/toggle_favorito_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/ubs_usecase.dart';
import 'package:meu_app/features/admin/presentation/providers/admin_provider.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/avaliacao/presentation/providers/avaliacao_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/favorito_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/ubs_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/ubs_lista_paginada_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/ubs_proxima_controller.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // ---------------------------------------------------------------
  // instâncias brutas do Firebase
  // ---------------------------------------------------------------
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // ---------------------------------------------------------------
  // datasources
  // ---------------------------------------------------------------
  locator.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthFirebaseDatasource(
      firebaseAuth: locator<FirebaseAuth>(),
      firestore: locator<FirebaseFirestore>(),
    ),
  );
  locator.registerLazySingleton<UbsFirestoreDataSource>(
    () => UbsFirestoreDataSourceImpl(firestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<AvaliacaoRemoteDatasource>(
    () => AvaliacaoFirestoreDatasource(firestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<FavoritoRemoteDatasource>(
    () => FavoritoFirestoreDatasource(firestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<DenunciaRemoteDatasource>(
    () => DenunciaFirestoreDatasource(firestore: locator<FirebaseFirestore>()),
  );

  // ---------------------------------------------------------------
  // repositories
  // ---------------------------------------------------------------
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<AuthRemoteDatasource>()),
  );
  locator.registerLazySingleton<UbsRepository>(
    () => UbsRepositoryImpl(locator<UbsFirestoreDataSource>()),
  );
  locator.registerLazySingleton<AvaliacaoRepository>(
    () => AvaliacaoRepositoryImpl(locator<AvaliacaoRemoteDatasource>()),
  );
  locator.registerLazySingleton<FavoritoRepository>(
    () => FavoritoRepositoryImpl(locator<FavoritoRemoteDatasource>()),
  );
  locator.registerLazySingleton<DenunciaRepository>(
    () => DenunciaRepositoryImpl(locator<DenunciaRemoteDatasource>()),
  );

  // ---------------------------------------------------------------
  // usecases
  // ---------------------------------------------------------------
  locator.registerLazySingleton(() => LoginUsecase(locator<AuthRepository>()));
  locator.registerLazySingleton(() => SignupUsecase(locator<AuthRepository>()));
  locator.registerLazySingleton(() => LogoutUsecase(locator<AuthRepository>()));
  locator.registerLazySingleton(
    () => ResetPasswordUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton(
    () => ObservarUsuarioLogadoUsecase(locator<AuthRepository>()),
  );

  locator.registerLazySingleton(
    () => BuscarUbsUsecase(locator<UbsRepository>()),
  );
  locator.registerLazySingleton(
    () => BuscarUbsPaginadoUsecase(locator<UbsRepository>()),
  );
  locator.registerLazySingleton(
    () => CadastrarUbsUsecase(locator<UbsRepository>()),
  );

  locator.registerLazySingleton(
    () => CriarAvaliacaoUsecase(locator<AvaliacaoRepository>()),
  );
  locator.registerLazySingleton(
    () =>
        BuscarAvaliacoesAprovadasPorUbsUsecase(locator<AvaliacaoRepository>()),
  );
  locator.registerLazySingleton(
    () => BuscarMinhasAvaliacoesUsecase(locator<AvaliacaoRepository>()),
  );

  locator.registerLazySingleton(
    () => BuscarFavoritosUsecase(locator<FavoritoRepository>()),
  );
  locator.registerLazySingleton(
    () => ObservarIsFavoritoUsecase(locator<FavoritoRepository>()),
  );
  locator.registerLazySingleton(
    () => ToggleFavoritoUsecase(locator<FavoritoRepository>()),
  );
   locator.registerLazySingleton(
    () => CriarDenunciaUseCase(locator<DenunciaRepository>()),
  );
   locator.registerLazySingleton(
    () => EditarAvaliacaoUsecase(locator<AvaliacaoRepository>()),
  );
  locator.registerLazySingleton(
    () => ExcluirAvaliacaoUsecase(locator<AvaliacaoRepository>()),
  );
  

const bool usarLocalizacaoMockada = bool.fromEnvironment('MOCK_LOCATION', defaultValue: false);

locator.registerLazySingleton<LocalizacaoDatasource>(() {
  if (usarLocalizacaoMockada) {
    return const LocalizacaoMockDatasource(
      latitude: -23.672651777766024, 
      longitude: -46.619268666362785,
    );
  }
  return LocalizacaoGeolocatorDatasource();
});

locator.registerFactory(() => ObterLocalizacaoAtualUsecase(locator<LocalizacaoDatasource>()));
  locator.registerLazySingleton(
    () => BuscarUbsProximasUsecase(locator<UbsRepository>()),
  );
  

  // ---------------------------------------------------------------
  // controllers (ChangeNotifier)
  // ---------------------------------------------------------------
  locator.registerLazySingleton(
    () => AuthController(
      locator<LoginUsecase>(),
      locator<SignupUsecase>(),
      locator<LogoutUsecase>(),
      locator<ResetPasswordUsecase>(),
      locator<ObservarUsuarioLogadoUsecase>(),
    ),
  );

  locator.registerLazySingleton(
    () => UbsController(
      locator<BuscarUbsUsecase>(),
      locator<CadastrarUbsUsecase>(),
      locator<LogoutUsecase>(),
    ),
  );
  locator.registerLazySingleton(
    () => FavoritoController(
      locator<BuscarFavoritosUsecase>(),
      locator<ObservarIsFavoritoUsecase>(),
      locator<ToggleFavoritoUsecase>(),
    ),
  );
  locator.registerLazySingleton(
    () => AvaliacaoController(
     locator(),
     locator(),
     locator(),
     locator(),
     locator(),
     locator(),
     locator(),
    ),
  );
   locator.registerLazySingleton(
    () => UbsProximasController(
     locator<ObterLocalizacaoAtualUsecase>(),
     locator<BuscarUbsProximasUsecase>(), 
    ),
  );
  locator.registerLazySingleton(() => AdminController());
  locator.registerLazySingleton(() => UbsListaPaginadaController(locator()));
}
