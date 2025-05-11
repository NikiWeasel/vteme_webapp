import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:vteme_tg_miniapp/core/models/category.dart';
import 'package:vteme_tg_miniapp/core/repository/local_categories_repository.dart';

part 'local_categories_event.dart';
part 'local_categories_state.dart';

class LocalCategoriesBloc
    extends Bloc<LocalCategoriesEvent, FetchCategoriesState> {
  final LocalCategoriesRepository localCategoriesRepository;
  List<RegCategory> localCats = [];

  LocalCategoriesBloc(this.localCategoriesRepository)
      : super(LocalCategoriesInitialState()) {
    on<FetchCategoriesData>((event, emit) async {
      emit(LocalCategoriesLoadingState());
      try {
        localCats = await localCategoriesRepository.fetchCategoriesData();
        emit(LocalCategoriesLoadedState(categories: localCats));
      } catch (e) {
        emit(LocalCategoriesErrorState(errorMessage: e.toString()));
      }
    });
  }
}
