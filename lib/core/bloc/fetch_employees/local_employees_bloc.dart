import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/repository/local_portfolio_photos_repository.dart';
import 'package:vteme_tg_miniapp/core/repository/local_employees_repository.dart';

part 'local_employees_event.dart';

part 'local_employees_state.dart';

class LocalEmployeesBloc
    extends Bloc<LocalEmployeesEvent, LocalEmployeesState> {
  final LocalEmployeesRepository localEmployeesRepository;

  LocalEmployeesBloc(this.localEmployeesRepository)
      : super(LocalEmployeesInitial()) {
    on<FetchAllEmployeesData>((event, emit) async {
      emit(LocalEmployeesLoading());
      try {
        var emps = await localEmployeesRepository.fetchAllEmployeesData();
        emit(LocalEmployeesLoaded(employees: emps));
      } catch (e) {
        emit(LocalEmployeesError(errorMessage: e.toString()));
      }
    });
  }
}
