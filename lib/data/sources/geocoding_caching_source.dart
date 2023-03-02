import 'index.dart';

@visibleForTesting
const geocodingCachePreferencesKey = 'geocoding_cache';

class Cache {
  Cache(this.map) : super();

  factory Cache.fromJson(Map<String, dynamic> json) => Cache(json.map(
        (cityName, cacheItemJson) => MapEntry(
          City(name: cityName),
          CacheItem.fromJson(cacheItemJson as Map<String, dynamic>),
        ),
      ));

  final Map<City, CacheItem> map;

  Map<String, dynamic> toJson() => map.map(
        (city, cacheItem) => MapEntry(city.name, cacheItem.toJson()),
      );
}

class CacheItem extends Equatable {
  const CacheItem({required this.date, required this.coordinates});

  factory CacheItem.fromJson(Map<String, dynamic> json) => CacheItem(
        date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
        coordinates: GeographicCoordinatesModel.fromLocalJson(
          json['coordinates'] as Map<String, dynamic>,
        ),
      );

  final DateTime date;

  final GeographicCoordinatesModel coordinates;

  dynamic toJson() => {
        'date': date.millisecondsSinceEpoch,
        'coordinates': coordinates.toJson(),
      };

  @override
  List<Object?> get props => [date, coordinates];
}

class GeocodingCachingSource {
  GeocodingCachingSource(this.preferences)
      : cache = preferences.containsKey(geocodingCachePreferencesKey)
            ? Cache.fromJson(
                Map.of(
                  jsonDecode(preferences.getString(geocodingCachePreferencesKey)!)
                      as Map<String, dynamic>,
                ),
              )
            : Cache({});

  final SharedPreferences preferences;

  final Cache cache;

  Future<void> flushCache() => preferences.setString(
        geocodingCachePreferencesKey,
        jsonEncode(cache.toJson()),
      );

  Future<Either<Failure, GeographicCoordinatesModel?>> getCachedCoordinates(
    City city, {
    @visibleForTesting Duration invalidationDuration = const Duration(days: 7),
  }) async {
    if (!cache.map.containsKey(city)) {
      return const Right(null);
    }

    final item = cache.map[city]!;

    if (DateTime.now().toUtc().difference(item.date) >= invalidationDuration) {
      cache.map.remove(city);

      await flushCache();

      return const Right(null);
    }

    return Right(item.coordinates);
  }

  Future<Either<Failure, void>> setCachedCoordinates(
    City city,
    GeographicCoordinatesModel coordinates,
  ) async {
    cache.map[coordinates.city] =
        cache.map[city] = CacheItem(date: DateTime.now().toUtc(), coordinates: coordinates);

    await flushCache();

    return const Right(null);
  }
}

final geocodingCachingDataSourceProvider = Provider(
  (references) => GeocodingCachingSource(references.watch(sharedPreferencesProvider)),
);
