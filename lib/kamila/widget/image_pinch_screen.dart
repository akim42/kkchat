import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:kkenglish/core/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final image;
  const ImageViewer({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool loading = false;

  double progress = 0.0;

  final Dio dio = Dio();

  Future<bool> saveFile(String url, String fileName) async {
    Directory directory;

    try{
      if(Platform.isAndroid){
        if(await _requestPermission(Permission.storage)){
          directory = (await getExternalStorageDirectory())!;
          String newPath = '';
          List<String> folders = directory.path.split('/');
          for(int x = 1; x<folders.length;x++){
            String folder = folders[x];
            if(folder != 'Android'){
              newPath += "/"+folder;
            } else {
              break;
            }
          }
          newPath = newPath+'/KKenglish';
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
      } else {
        if(await _requestPermission(Permission.photos)){
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      if(!await directory.exists()){
        await directory.create(recursive: true);
      }
      if(await directory.exists()){
        File saveFile = File(directory.path+"/images/$fileName");
        await dio.download(url, saveFile.path, onReceiveProgress: (dowloaded, totalSize){
          setState(() {
            progress = dowloaded/totalSize;
          });
        });
        if(Platform.isIOS){
          await ImageGallerySaver.saveFile(saveFile.path,isReturnPathOfIOS: true);
        }
        return true;
      }
    } catch(e) {
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if(await permission.isGranted){
      return true;
    } else {
      var result = await permission.request();
      if(result == PermissionStatus.granted){
        return true;
      } else{
        return false;
      }
    }
  }

  downloadFile(String url, String fileName) async {
    setState(() {
      loading = true;
    });

    bool downloaded = await saveFile(url, fileName);
    if(downloaded) {
    } else {
    }

    setState(() {
      loading = false;
    });
  }

  double _scale = 1.0;
  double _previousScale = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 30, bottom: 10),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.greyDark,size: 30,)
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
                  // child: Text(widget.senderName, style: AppColors.style20bb)
              ),
              Padding(
                padding: EdgeInsets.only(right: 10, top: 30, bottom: 10),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: GestureDetector(
                      onTap: () {
                        saveFile(widget.image, widget.image+".jpg");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Изображение сохранено'),
                        ));
                      },
                      child: Icon(Icons.save_alt_rounded, color: AppColors.greyDark,size: 30,)
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: size.height-80,
              width: size.width,
              child: PhotoView(
                imageProvider: NetworkImage(widget.image,),
              )
          ),
        ],
      ),
    );
  }
}
