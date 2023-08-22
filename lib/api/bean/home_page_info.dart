import 'package:jd_demo/api/result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_page_info.g.dart';

class HomePageInfoResult extends BaseResult<HomePageInfo> {
  HomePageInfoResult();

  @override
  HomePageInfo? convertData(dataJson) => HomePageInfo.fromJson(dataJson);

  factory HomePageInfoResult.fromJson(Map<String, dynamic> json) =>
      HomePageInfoResult().convertResult(json) as HomePageInfoResult;
}

@JsonSerializable()
class HomePageInfo {
  List<BannerInfo>? bannerList;
  String? adUrl;
  List<NineMenuInfo>? nineMenuList;
  List<TabInfo>? tabList;

  HomePageInfo({this.bannerList, this.adUrl, this.nineMenuList, this.tabList});

  factory HomePageInfo.fromJson(Map<String, dynamic> json) => _$HomePageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HomePageInfoToJson(this);
}

@JsonSerializable()
class BannerInfo {
  final String? imgUrl;
  final String? type;

  BannerInfo(this.imgUrl, this.type);

  factory BannerInfo.fromJson(Map<String, dynamic> json) => _$BannerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BannerInfoToJson(this);
}

@JsonSerializable()
class NineMenuInfo {
  final String? menuIcon;
  final String? menuName;
  final String? menuCode;
  final String? h5url;

  NineMenuInfo({this.menuIcon, this.menuName, this.menuCode, this.h5url});

  factory NineMenuInfo.fromJson(Map<String, dynamic> json) => _$NineMenuInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NineMenuInfoToJson(this);
}

@JsonSerializable()
class TabInfo {
  final String? name;
  final String? code;

  TabInfo(this.name, this.code);

  factory TabInfo.fromJson(Map<String, dynamic> json) => _$TabInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TabInfoToJson(this);
}
