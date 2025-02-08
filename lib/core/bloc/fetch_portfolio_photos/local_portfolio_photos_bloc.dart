import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:vteme_tg_miniapp/core/repository/local_portfolio_photos_repository.dart';

part 'local_portfolio_photos_event.dart';

part 'local_portfolio_photos_state.dart';

class LocalPortfolioPhotosBloc
    extends Bloc<FetchPortfolioPhotosEvent, LocalPortfolioPhotosState> {
  final LocalPortfolioPhotosRepository localPortfolioPhotosRepository;
  Map<String, List<String>> localUrls = {};

  LocalPortfolioPhotosBloc(this.localPortfolioPhotosRepository)
      : super(LocalPortfolioPhotosInitial()) {
    on<FetchPortfolioPhotosData>((event, emit) async {
      emit(LocalPortfolioPhotosLoadingState());
      try {
        localUrls = await localPortfolioPhotosRepository.fetchPortfolioPhotos();
        emit(LocalPortfolioPhotosLoadedState(downloadUrls: localUrls));
      } catch (e) {
        emit(LocalPortfolioPhotosErrorState(errorMessage: e.toString()));
      }
    });
  }
}
