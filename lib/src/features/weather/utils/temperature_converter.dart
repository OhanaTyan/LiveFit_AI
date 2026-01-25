class TemperatureConverter {
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9/5) + 32;
  }

  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5/9;
  }

  static String formatTemperature(double temp, String unit) {
    if (unit == 'fahrenheit') {
      return '${celsiusToFahrenheit(temp).round()}°F';
    } else {
      return '${temp.round()}°C';
    }
  }
}
