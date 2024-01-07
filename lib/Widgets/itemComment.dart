// ignore_for_file: camel_case_types, must_be_immutable

import 'dart:io';

import 'package:appclient/Widgets/showStar.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class itemComment extends StatefulWidget{
  var item;
  itemComment({super.key, required this.item});

  @override
  State<itemComment> createState() => _itemCommentState();
}

class _itemCommentState extends State<itemComment> {

  bool showMore = false;
  String sShow = "Xem thêm ";

  @override
  Widget build(BuildContext context) {
    if(widget.item == null){
      return const Text("");
    }
    List images = widget.item['images'] ?? [];
    String linkAvata = widget.item['user_id']['avata'].toString();
    String comment = widget.item['comment'] ?? "";

    if(comment.length >= 90 && !showMore){
      comment = "${comment.substring(0, 90)}....";
      sShow = "Xem Thêm";
    }else{
      sShow = "Ẩn bớt";
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 56,
                height: 56,
                child: Image.network(
                  "$BASE_API$linkAvata",
                  errorBuilder: (BuildContext context , Object error, StackTrace? stackTrace){
                    return const Icon(Icons.image);
                  }
                )
              )
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['user_id']['full_name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    widget.item['date'],
                    style: const TextStyle(
                      fontSize: 14,
                        color: Color(0xFF696969)
                    ),
                  ),
                ],
              )
            )
          ],
        ),

        const SizedBox(height: 8),
        showStar(countStar: widget.item['rating']),
        const SizedBox(height: 8),

        Row(
          children: [
            const Text(
              "Màu : ",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF696969)
              ),
            ),
            Text(
              widget.item['product_detail_id']['color_id']['name'],
              style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF696969)
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "Size : ",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF696969)
              )
            ),
            Text(
              widget.item['product_detail_id']['size_id']['name'],
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF696969)
              )
            )
          ]
        ),

        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Text(
            comment,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
        ),

        (comment.length >= 90) ?
          InkWell(
            onTap: () {
              comment = widget.item['comment'] ?? "";
              showMore = !showMore;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8 , left: 32 , right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(sShow , style: const TextStyle(
                    color: Color(0xFF8f8f8f),
                    ),
                  ),
                  Icon(
                    showMore ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: const Color(0xFF8f8f8f),
                  )
                ]
              ),
            )
          ) :
          const SizedBox(),

        const SizedBox(height: 8),
        Row(
         children: images.map((e) =>
           SizedBox(
             width: 64,
             height: 64,
             child: Image.network(
               "$BASE_API$e",
               errorBuilder: (BuildContext context , Object error, StackTrace? stackTrace){
                 return const Icon(Icons.image);
               }
             )
           )
         ).toList(),
        ),

        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 0.5,
          color: Colors.black45,
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}

class itemAddComment extends StatefulWidget{
  final TextEditingController starCtrl;
  final TextEditingController commentCtrl;
  final item;
  final Function pickImage;
  final List<XFile> images;
  final int index;
  final List<String> imagescall;
  const itemAddComment({
    super.key,
    required this.item ,
    required this.starCtrl ,
    required this.commentCtrl,
    required this.pickImage,
    required this.images,
    required this.index,
    required this.imagescall
  });

  @override
  State<itemAddComment> createState() => _itemAddCommentState();
}

class _itemAddCommentState extends State<itemAddComment> {
  int commentLeght = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                widget.item['product_data']['image'][0],
                  errorBuilder: (BuildContext context , Object error, StackTrace? stackTrace){
                    return const Icon(Icons.image);
                  }
              )
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['product_data']['name'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  Text(
                    "Size : ${widget.item['product_data']['size_name']}" ,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF696969)
                    ),
                  ),
                  Text(
                    "Color : ${widget.item['product_data']['color_name']}" ,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF696969)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        changeStar(starCtrl: widget.starCtrl),

        TextField(
          controller: widget.commentCtrl,
          onChanged: (value) {
            commentLeght = value.length;
            setState(() {});
          },
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: "Viết đánh giá của bạn",
            hintStyle: const TextStyle(
              color: Colors.grey
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6342E8))
            ),
            contentPadding: const EdgeInsets.all(8)
          ),
        ),

        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: Text(
            "$commentLeght/200",
            style: TextStyle(
              color: (commentLeght > 200) ? Colors.red : Colors.black
            ),
          ),
        ),

        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                   widget.pickImage(widget.index);
                },
                child: const Icon(Icons.image, color: Colors.grey,size: 56,),
              ),

              Row(
                children: (widget.images.isNotEmpty) ?
                widget.images.map((e) {
                  return Image.file(
                      File(e.path), width: 80, height: 80, fit: BoxFit.cover
                  );
                }
                ).toList()
                : widget.imagescall.map((e) =>
                    Image.network(
                        width: 80 ,height: 80,
                        '$BASE_API$e',
                        errorBuilder: (BuildContext context , Object error, StackTrace? stackTrace){
                          print('$BASE_API$e');
                          return const Icon(Icons.image);
                        }
                    )
                ).toList()
              )
            ]
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 8 , bottom: 8),
          color: Colors.black45,
          height: 0.5,
          width: double.infinity,
        )
      ]
    );
  }
}