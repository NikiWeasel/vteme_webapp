part of 'local_categories_bloc.dart';

@immutable
sealed class LocalCategoriesEvent {}

class FetchCategoriesData extends LocalCategoriesEvent {}
