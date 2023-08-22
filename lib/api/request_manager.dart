import 'package:dio/dio.dart';
import 'package:jd_demo/api/bean/home_page_info.dart';
import 'package:jd_demo/api/bean/request.dart';


class RequestManager {
  static const contentTypeJson = "application/json";
  static const contentTypeFormData = "multipart/form-data";
  static const contentTypeForm = "application/x-www-form-urlencoded";
  static final Dio _dio = Dio();

  static final RequestManager instance = RequestManager._init();

  RequestManager._init();

  factory RequestManager() => instance;

  Future<HomePageInfoResult> getHomePageInfo() async {
    final client = RestClient(_dio);
    print('------start get info');
    return client.getHomePageInfo();
  }
}
