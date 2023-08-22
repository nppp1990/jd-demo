import 'package:jd_demo/api/bean/home_page_info.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'request.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/home/queryHomePageInfo")
  Future<HomePageInfoResult> getHomePageInfo();
}