import 'package:appclient/Widgets/showStar.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';

class itemComment extends StatelessWidget{
  var item;
  itemComment({required this.item});

  @override
  Widget build(BuildContext context) {
    if(item == null){
      return const Text("");
    }
    // List<String>? images = item.images ?? [];
    
    String linkAvata = item['user_id']['avata'].toString();

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
                    return Icon(Icons.image);
                  }
                )
              )
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['user_id']['full_name'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    item['date'],
                    style: TextStyle(
                      fontSize: 14,
                        color: Color(0xFF696969)
                    ),
                  ),
                ],
              )
            )
          ],
        ),

        showStar(countStar: 5),

        Row(
          children: [
            Text(
              "Màu : ",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF696969)
              ),
            ),
            Text(
              item['product_detail_id']['color_id']['name'],
              style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF696969)
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Size : ",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF696969)
              )
            ),
            Text(
              item['product_detail_id']['size_id']['name'],
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF696969)
              )
            )
          ]
        ),

        Container(
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Text(
            item['comment'],
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),

        // Row(
        //  children: [
        //    SizedBox(
        //        width: 56,
        //        height: 56,
        //        child: Icon(Icons.image , size: 56,)
        //    ),
        //    SizedBox(
        //        width: 56,
        //        height: 56,
        //        child: Icon(Icons.image , size: 56,)
        //    )
        //  ],
        // ),

        // Row(
        //   children: images!.map((e) => SizedBox(
        //       width: 56,
        //       height: 56,
        //       child: Icon(Icons.image , size: 56,)
        //   )).toList(),
        // ),

        SizedBox(height: 56)
      ],
    );
  }

}