import 'package:dople_clone/model/pokemon_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/api_service.dart';
import 'view_model/pokemon_list_view_model.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio()
    ..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    ),
);

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(ref.watch(dioProvider)),
);

final favoritesBoxProvider = Provider<Box>((ref) => Hive.box('favoritesBox'));

final pokemonListProvider =
    StateNotifierProvider<PokemonListViewModel, AsyncValue<List<PokemonItem>>>(
      (ref) => PokemonListViewModel(
        ref.watch(apiServiceProvider),
        ref.watch(favoritesBoxProvider),
      ),
    );
