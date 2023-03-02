import 'index.dart';

FloatingSearchBarController useFloatingSearchBarController() {
  final controller = useMemoized(
    () => FloatingSearchBarController(),
    const [],
  );

  useEffect(() => controller.dispose, const []);

  return controller;
}

GlobalKey<T> useGlobalKey<T extends State<StatefulWidget>>() =>
    useMemoized(() => GlobalKey<T>(), const []);
