import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:satvik_task/blocs/album_bloc/bloc/album_bloc.dart';
import 'package:satvik_task/helper/export_helpers.dart';
import 'package:satvik_task/helper/my_widgets/my_widgets.dart';
import 'package:satvik_task/localDB/export_db.dart';
import 'package:satvik_task/model/album_model.dart';
import 'package:satvik_task/model/export_models.dart';
import 'package:satvik_task/view/photo_view.dart';

class PhotosPage extends StatefulWidget {
  final AlbumModel album;
  const PhotosPage({super.key, required this.album});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlbumBloc()..add(GetPhotos(albumId: widget.album.id.toString())),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: MyWidgets.myAppbar(title: widget.album.title),
        body: BlocConsumer<AlbumBloc, AlbumState>(
          listener: (context, state) {
            if (state is GetPhotoFailed) {
              showSnackbar(context: context, message: "Internet error! photos cann't be refreshed.");
            }
          },
          builder: (context, state) {
            if (state is GetPhotoLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return FutureBuilder<List<PhotoModel>>(
                future: PhotoDatabaseHelper.instance
                    .getPhotos(albumId: widget.album.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No photos found.'));
                  }
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final photo = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            navigatorPush(PhototView(photo: photo));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           PhototView(photo: photo),
                            //     ));
                          },
                          child: MyWidgets.photoThumbnail(photo: photo));
                      });
                });
          },
        ),
      ),
    );
  }
}
