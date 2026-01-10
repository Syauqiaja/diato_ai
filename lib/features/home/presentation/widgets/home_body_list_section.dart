import 'package:diato_ai/features/home/presentation/widgets/penelitian_item.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:flutter/material.dart';

class HomeBodyListSection extends StatefulWidget {
  const HomeBodyListSection({super.key});

  @override
  State<HomeBodyListSection> createState() => _HomeBodyListSectionState();
}

class _HomeBodyListSectionState extends State<HomeBodyListSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        itemCount: 6,
        padding: EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (context, index) => hSpace(8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return PenelitianItem(
            onTap: (){
              
            },
          );
        },
      ),
    );
  }
}
