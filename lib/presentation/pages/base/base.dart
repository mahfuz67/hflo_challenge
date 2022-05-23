import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hormoniousflo_challenge/presentation/pages/base/pages/home.dart';

import '../../bloc/bottom_navigation_bloc.dart';
import '../../components/nav_item.dart';
import '../../themes/colors.dart';

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(builder: (context, idx) {
      return Scaffold(
        body: IndexedStack(
          index: idx,
          children: [
            const Home(),
            Center(
              child: Text('page ${idx + 1}'),
            ),
            Center(
              child: Text('page ${idx + 1}'),
            ),
            Center(
              child: Text('page ${idx + 1}'),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          elevation: 10,
          color: AppColors.white,
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 60,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: NavItem(
                    label: 'Profile',
                    icon: Icons.person,
                    value: 0,
                    isSelected: idx == 0,
                    onChanged: (int value) {
                      context.read<BottomNavCubit>().setIndex(value);
                    },
                    groupValue: idx,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: NavItem(
                    label: 'Program',
                    icon: Icons.menu,
                    value: 1,
                    isSelected: idx == 1,
                    onChanged: (int value) {
                      context.read<BottomNavCubit>().setIndex(value);
                    },
                    groupValue: idx,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        null,
                        size: 25,
                        color: AppColors.blueGrey[300],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Check-in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.blueGrey[300],
                        ),
                      )
                    ],
                  ),
                ),
                // NavItem(
                //   label: 'Check-in',
                //   value: 2,
                //   isSelected: idx == 2,
                //   onChanged: (int value) {
                //     context.read<BottomNavCubit>().setIndex(value);
                //   },
                //   groupValue: idx,
                // ),
                Expanded(
                  flex: 1,
                  child: NavItem(
                    label: 'Lifestyle',
                    icon: Icons.local_florist,
                    value: 2,
                    isSelected: idx == 2,
                    onChanged: (int value) {
                      context.read<BottomNavCubit>().setIndex(value);
                    },
                    groupValue: idx,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: NavItem(
                    label: 'Settings',
                    icon: Icons.settings,
                    value: 3,
                    isSelected: idx == 3,
                    onChanged: (int value) {
                      context.read<BottomNavCubit>().setIndex(value);
                    },
                    groupValue: idx,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          elevation: 2,
          backgroundColor: AppColors.primary,
          child: const Center(
              child: Icon(
            Icons.add,
            color: Colors.white,
          )),
        ),
      );
    });
  }
}
