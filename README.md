Someone asked me:

```
想問大家如果backend api response永遠wrap左一層，我想用generic type去parse JSON, let's say
{ String message, T data }
類似咁樣
我要點樣先做到，有冇咩library之類 🙇
我做左d research，之前一直都唔support呢樣野，好似因為d runtime reflection既問題？但我未見到2023有冇一個好既solution
```

```
姐係server既所有response都係
{
  String message,
  int statusCode,
  T data (可以return任何data)
}

我想寫個generic response class, 然後pass返個data type入個generic response class黎減少code repetition.
如 WebserviceResponse<UserProfile>
咁個response就會咁樣去parse
{
  String message,
  int statusCode,
  UserProfile data
}
大家會用咩方法去做到呢個dynamic parsing 😹
```


And here is my solution:

```dart
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


```


Usage:

```dart
return UserProfileData.parseAsAPIUserProfileResponse({
  "status": "success",
  "message": "ok",
  "data": {
    "name": "Name",
    "gender": "Female",
  }
});
```


Or:

```dart
return APIResponseBase<UserProfileData>({
  "status": "success",
  "message": "ok",
  "data": {
    "name": "Name",
    "gender": "Female",
  }
}, UserProfileData.new);
```


According to ref: https://github.com/dart-lang/sdk/issues/30074, dart does not and will not support class full constructor generics. Fortunately Dart allows passing functions (and constructor) as parameters and even into a constructor. The above solution is hacky yet clean.

