import 'dart:io';

String formatCookies(List<Cookie> cookies) {
  return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
}