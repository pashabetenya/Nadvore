import 'main.dart' as m;
import 'index.dart';

Future<void> main() => m.main(
      builder: DevicePreview.appBuilder,
      topLevelBuilder: (widget) => DevicePreview(builder: (context) => widget),
      getLocale: DevicePreview.locale,
    );
