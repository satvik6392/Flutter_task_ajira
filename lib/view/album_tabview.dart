import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:satvik_task/blocs/export_blocs.dart';
import 'package:satvik_task/helper/export_helpers.dart';
import 'package:satvik_task/localDB/album_db.dart';
import 'package:satvik_task/view/photos_page.dart';

import '../model/export_models.dart';

class AlbumTabBarView extends StatefulWidget {
  final userId;
  const AlbumTabBarView({super.key, required this.userId});

  @override
  State<AlbumTabBarView> createState() => _AlbumTabBarViewState();
}

class _AlbumTabBarViewState extends State<AlbumTabBarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) => AlbumBloc()..add(GetAlbums(userId: widget.userId)),
        child: BlocConsumer<AlbumBloc, AlbumState>(
          listener: (context, state) {
            if (state is GetAlbumFailed) {
              showSnackbar(context: context, message: "Internet error! albums not refreshed.");
            }
          },
          builder: (context, state) {
            if (state is GetAlbumLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // in this we are getting data from local database, after api call it updated into local database
            return FutureBuilder<List<AlbumModel>>(
                future: AlbumDatabaseHelper.instance
                    .getAlbums(userId: int.parse(widget.userId)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No albums found.'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing:
                          10.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      AlbumModel album = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          navigatorPush(PhotosPage(album: album));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyWidgets.albumContainer(album: album)),
                      );
                    },
                  );
                });
          },
        ),
      ),
    );
  }
}
