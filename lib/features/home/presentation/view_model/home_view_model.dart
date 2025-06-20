import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel() : super(HomeState.initial());

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    // Handle logout logic if needed
    Navigator.pushReplacementNamed(context, '/login');
  }
}
