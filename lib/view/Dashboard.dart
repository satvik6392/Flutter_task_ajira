import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:satvik_task/blocs/export_blocs.dart';
import 'package:satvik_task/helper/export_helpers.dart';
import 'package:satvik_task/localDB/export_db.dart';
import 'export_view.dart';

import '../model/export_models.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc()..add(GetUserProfile()),
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: MyWidgets.myAppbar(title: "All users"),

            // in Body Event is called immediately if it doesn't get data then it get data from local database
            body: BlocConsumer<UserBloc, UserState>(
              bloc: UserBloc()..add(GetUserProfile()),
              listener: (context, state) {
                if (state is GetUserProfileFailed) {
                  showSnackbar(
                      context: context,
                      message: "internet error! users not refreshed.");
                }
              },
              builder: (context, state) {
                if (state is GetUserProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // showing data from local database
                  // if data is coming from api successfully then updating in local db also
                  return FutureBuilder(
                      future: UserProfileDatabaseHelper().getUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                UserModel user = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyWidgets.profileListTile(
                                      user: user,
                                      onTap: () {
                                        // going to a particular user's profile
                                        navigatorPush(UserProfile(user: user));
                                      }),
                                );
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      });
                }
              },
            )));
  }
}
