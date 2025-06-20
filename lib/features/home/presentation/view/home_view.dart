import 'package:bloodbank/features/home/presentation/view_model/home_state.dart';
import 'package:bloodbank/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeViewModel(),
      child: const HomeScaffold(),
    );
  }
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Bank"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<HomeViewModel>().logout(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return state.views[state.selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              context.read<HomeViewModel>().onTabTapped(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Donors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bloodtype),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
