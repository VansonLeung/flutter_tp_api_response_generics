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


Usage:

```
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

```
return APIResponseBase<UserProfileData>({
  "status": "success",
  "message": "ok",
  "data": {
    "name": "Name",
    "gender": "Female",
  }
}, UserProfileData.new);
```


