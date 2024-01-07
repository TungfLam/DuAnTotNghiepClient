import 'package:appclient/Widgets/showStar.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';

class itemComment extends StatefulWidget{
  var item;
  itemComment({required this.item});

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

        Row(
         children: images.map((e) =>
           SizedBox(
             width: 64,
             height: 64,
             child: Image.network(
               "$e",
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