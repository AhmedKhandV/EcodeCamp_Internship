import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/bloc/weather_bloc_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Function to get weather icons based on code
  Widget getWeatherIcon(int code) {
    if (code >= 200 && code < 300) {
      return Image.asset('assets/1.png');
    } else if (code >= 300 && code < 400) {
      return Image.asset('assets/2.png');
    } else if (code >= 500 && code < 600) {
      return Image.asset('assets/3.png');
    } else if (code >= 600 && code < 700) {
      return Image.asset('assets/4.png');
    } else if (code >= 700 && code < 800) {
      return Image.asset('assets/5.png');
    } else if (code == 800) {
      return Image.asset('assets/6.png');
    } else if (code > 800 && code <= 804) {
      return Image.asset('assets/7.png');
    } else {
      return Image.asset('assets/7.png');
    }
  }

  // Function to handle search event
  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<WeatherBloc>().add(FetchWeatherByCity(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search city...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            border: InputBorder.none,
          ),
          onSubmitted: _onSearch,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Background Circles and Shapes
                Align(
                  alignment: const AlignmentDirectional(3, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-3, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF673AB7),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -1.2),
                  child: Container(
                    height: 300,
                    width: 600,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFAB40),
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
                // Weather Information Block
                BlocBuilder<WeatherBloc, WeatherBlocState>(
                  builder: (context, state) {
                    if (state is WeatherBlocLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is WeatherBlocSuccess) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              '📍 ${state.weather.areaName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          getWeatherIcon(state.weather.weatherConditionCode!),
                          Center(
                            child: Text(
                              '${state.weather.temperature!.celsius!.round()}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 55,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              state.weather.weatherMain!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              DateFormat('EEEE dd •').add_jm().format(DateTime.now()), // Use current time
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Sunrise and Sunset Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Sunrise Info
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/11.png', // Sunrise icon
                                    scale: 8,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sunrise',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        DateFormat().add_jm().format(state.weather.sunrise!),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Sunset Info
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/12.png', // Sunset icon
                                    scale: 8,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sunset',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        DateFormat().add_jm().format(state.weather.sunset!),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),

                          // Temp Max and Min Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/13.png',
                                    scale: 8,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Temp Max',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${state.weather.tempMax!.celsius!.round()} °C',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/14.png',
                                    scale: 8,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Temp Min',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${state.weather.tempMin!.celsius!.round()} °C',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

// 5-Day Forecast
// 5-Day Forecast
const Text(
  '5-Day Forecast',
  style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 10),
Expanded(
  child: ConstrainedBox(
  constraints: BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * 0.25,
  ),
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 5, // Limit to 5 days
    itemBuilder: (context, index) {
      // Find the next unique day
      DateTime forecastDate = state.weather.date!.add(Duration(days: index));
      final forecast = state.forecast.firstWhere(
        (f) => DateFormat('yyyy-MM-dd').format(f.date!) == DateFormat('yyyy-MM-dd').format(forecastDate),
        orElse: () => state.forecast.last,
      );
      
      return Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent, // Set background to transparent
          borderRadius: BorderRadius.circular(0), // No border radius for borderless appearance
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: getWeatherIcon(forecast.weatherConditionCode!),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('E').format(forecastDate),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${forecast.temperature!.celsius!.round()}°C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      );
    },
  ),
),

),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),

                         
                        ],
                      );
                    } else if (state is WeatherBlocFailure) {
                      return const Center(
                        child: Text(
                          'Error fetching weather data',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
