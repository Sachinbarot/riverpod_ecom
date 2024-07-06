dynamic authToken;
dynamic userId;
var userName;

//apis

var baseUrl = "https://api.escuelajs.co/api/v1/";
var registerUrl = baseUrl + "users/";
var loginUrl = baseUrl + "auth/login";
var productlistUrl = baseUrl + ("products");
var userProfile = baseUrl + ("auth/profile");
var updateProfile = baseUrl + ("users/$userId");
