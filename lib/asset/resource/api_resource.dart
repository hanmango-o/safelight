class ApiResource {
  static String API_weather(double lat, double long) {
    return 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=e5a7b17b215d3503ab23e2066fba37dc';
  }
}
