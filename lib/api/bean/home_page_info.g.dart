// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomePageInfo _$HomePageInfoFromJson(Map<String, dynamic> json) => HomePageInfo(
      bannerList: (json['bannerList'] as List<dynamic>?)
          ?.map((e) => BannerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      adUrl: json['adUrl'] as String?,
      nineMenuList: (json['nineMenuList'] as List<dynamic>?)
          ?.map((e) => NineMenuInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      tabList: (json['tabList'] as List<dynamic>?)
          ?.map((e) => TabInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomePageInfoToJson(HomePageInfo instance) =>
    <String, dynamic>{
      'bannerList': instance.bannerList,
      'adUrl': instance.adUrl,
      'nineMenuList': instance.nineMenuList,
      'tabList': instance.tabList,
    };

BannerInfo _$BannerInfoFromJson(Map<String, dynamic> json) => BannerInfo(
      json['imgUrl'] as String?,
      json['type'] as String?,
    );

Map<String, dynamic> _$BannerInfoToJson(BannerInfo instance) =>
    <String, dynamic>{
      'imgUrl': instance.imgUrl,
      'type': instance.type,
    };

NineMenuInfo _$NineMenuInfoFromJson(Map<String, dynamic> json) => NineMenuInfo(
      menuIcon: json['menuIcon'] as String?,
      menuName: json['menuName'] as String?,
      menuCode: json['menuCode'] as String?,
      h5url: json['h5url'] as String?,
    );

Map<String, dynamic> _$NineMenuInfoToJson(NineMenuInfo instance) =>
    <String, dynamic>{
      'menuIcon': instance.menuIcon,
      'menuName': instance.menuName,
      'menuCode': instance.menuCode,
      'h5url': instance.h5url,
    };

TabInfo _$TabInfoFromJson(Map<String, dynamic> json) => TabInfo(
      json['name'] as String?,
      json['code'] as String?,
    );

Map<String, dynamic> _$TabInfoToJson(TabInfo instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
    };
