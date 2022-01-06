import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kkenglish/bloc/delete_save_bloc.dart';
import 'package:kkenglish/core/style.dart';
import 'package:provider/provider.dart';
import 'package:kkenglish/config.dart';

class NavbarDeleteSave extends StatefulWidget {
  final String senderName;
  const NavbarDeleteSave({Key? key, required this.senderName}) : super(key: key);

  @override
  State<NavbarDeleteSave> createState() => _NavbarDeleteSaveState();
}

class _NavbarDeleteSaveState extends State<NavbarDeleteSave> {

  @override
  Widget build(BuildContext context) {
    return Row(
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
              child: Text(widget.senderName, style: AppColors.style20bb)
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, top: 30, bottom: 10),
            child: SizedBox(
                height: 40,
                width: 40,
            ),
          ),
        ],
    );
  }
}
