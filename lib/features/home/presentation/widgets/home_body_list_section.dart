import 'package:diato_ai/features/home/presentation/cubit/article_cubit.dart';
import 'package:diato_ai/features/home/presentation/widgets/penelitian_item.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBodyListSection extends StatefulWidget {
  const HomeBodyListSection({super.key});

  @override
  State<HomeBodyListSection> createState() => _HomeBodyListSectionState();
}

class _HomeBodyListSectionState extends State<HomeBodyListSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        if(state is ArticleLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if(state is ArticleError) {
          return Center(
            child: Text('Gagal memuat artikel'),
          );
        }

        if(state is ArticleLoaded) {
          final articles = state.articles;
          return ListView.separated(
            itemCount: articles.length,
            padding: EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => vSpace(16),
            itemBuilder: (context, index) {
              final article = articles[index];
              return PenelitianItem(
                title: article.title,
                cover: article.cover,
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(article.url))) {
                    await launchUrl(Uri.parse(article.url));
                  } else {
                    
                  }
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }


}
