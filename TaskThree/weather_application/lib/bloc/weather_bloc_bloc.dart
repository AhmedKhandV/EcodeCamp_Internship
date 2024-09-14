import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../data/my_data.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBloc() : super(WeatherBlocInitial()) {
    // Handle geolocation-based weather fetching
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
        Weather weather = await wf.currentWeatherByLocation(
          event.position.latitude,
          event.position.longitude,
        );
        emit(WeatherBlocSuccess(weather, [])); // No forecast for geolocation-based
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });

    // Handle city-based weather fetching (search functionality)
    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
        Weather weather = await wf.currentWeatherByCityName(event.cityName);
        List<Weather> forecast = await wf.fiveDayForecastByCityName(event.cityName);
        emit(WeatherBlocSuccess(weather, forecast));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}
