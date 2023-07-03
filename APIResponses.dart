abstract class InnerBaseResponseDataInterface {
  InnerBaseResponseDataInterface(Map<String, dynamic> json);
}


class APIResponseBase<T extends InnerBaseResponseDataInterface> {
  String? status;
  String? message;
  T? data;

  APIResponseBase(Map<String, dynamic> json, T Function(Map<String, dynamic>) constructor) {
    status = json['status'];
    message = json['message'];
    data = constructor(json);
  }
}


class UserProfileData extends InnerBaseResponseDataInterface {
  String? name;
  String? gender;

  UserProfileData(Map<String, dynamic> json) : super(json) {
    name = json['data']['status'];
    gender = json['data']['message'];
  }

  static parseAsAPIUserProfileResponse(Map<String, dynamic> json) {
    return APIResponseBase<UserProfileData>(json, UserProfileData.new);
  }
}

