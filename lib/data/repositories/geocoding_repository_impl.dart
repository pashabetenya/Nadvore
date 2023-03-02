import 'index.dart';

class GeocodingRepositoryImpl {
  GeocodingRepositoryImpl(
    this.geocoding,
    this.cache,
  );

  final GeocodingRemoteSource geocoding;

  final GeocodingCachingSource cache;

  Future<Either<Failure, GeographicCoordinatesModel>> getCoordinates(
    City city,
  ) async {
    final cachedCoordinates = await cache.getCachedCoordinates(city);

    if (cachedCoordinates is Left || cachedCoordinates.all((coordinates) => coordinates != null)) {
      return cachedCoordinates.map((coordinates) => coordinates!);
    }

    final coordinates = await geocoding.getCoordinates(city);

    await coordinates
        .map<Future<void>>(
          (coordinates) => cache.setCachedCoordinates(
            city,
            coordinates,
          ),
        )
        .getOrElse(() async {});

    return coordinates;
  }
}

final geocodingRepositoryImplProvider = Provider(
  (references) => GeocodingRepositoryImpl(
    references.watch(geocodingRemoteSourceProvider),
    references.watch(geocodingCachingDataSourceProvider),
  ),
);
