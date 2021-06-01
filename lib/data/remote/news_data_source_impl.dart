import 'dart:math';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants.dart';
import '../../util/ext/date_time.dart';
import '../model/news.dart';
import '../provider/dio_provider.dart';
import 'news_data_source.dart';

class NewsDataSourceImpl implements NewsDataSource {
  NewsDataSourceImpl(this._reader);

  final Reader _reader;

  late final Dio _dio = _reader(dioProvider);

  @override
  Future<News> getNews() {
    return _dio.get<Map<String, dynamic>>(
      '/v2/everything',
      queryParameters: <String, String>{
        'q': ['anim', 'manga'][Random().nextInt(2)], // For checking reload.
        'from': DateTime.now()
            .subtract(
              const Duration(days: 28),
            )
            .toLocal()
            .formatYYYYMMdd(),
        'sortBy': 'publishedAt',
        'language': 'en',
        'apiKey': Constants.of().apiKey,
      },
    ).then((response) => News.fromJson(response.data!));
  }
}
