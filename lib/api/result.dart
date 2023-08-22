abstract class BaseResult<T> {
  String? code;
  String? msg;
  T? data;

  BaseResult convertResult(Map<String, dynamic> json) {
    code = json['code'] as String?;
    msg = json['msg'] as String?;
    if (json['data'] == null) {
      return this;
    }
    data = convertData(json['data']);
    return this;
  }

  T? convertData(dynamic dataJson);
}
