import 'package:flutter/material.dart';

class HomeState {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  factory HomeState.initial() {
    return HomeState(
      selectedIndex: 0,
      views: const [
        Center(child: Text('Dashboard')),
        Center(child: Text('Donors')),
        Center(child: Text('Requests')),
        Center(child: Text('Profile')),
      ],
    );
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }
}
