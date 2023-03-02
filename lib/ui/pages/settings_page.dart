import 'index.dart';
import 'package:weather/ui/states/unit_system_state_notifier.dart' hide Error;
import 'package:weather/ui/states/api_key_state_notifier.dart' as a;

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeStateNotifierProvider.select((state) => state.theme));
    final darkTheme = ref.watch(
      themeStateNotifierProvider.select((state) => state.darkTheme),
    );
    final apiKey = ref.watch(a.apiKeyStateNotifierProvider.select((state) => state.apiKey!));

    final unitSystem = ref.watch(
      unitSystemStateNotifierProvider.select((state) => state.unitSystem!),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle!.color,
            fontSize: Theme.of(context).textTheme.headline6!.fontSize,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SettingsHeader(title: 'General'),
            SettingsTile(
                title: 'Unit system',
                subtitle: () {
                  switch (unitSystem) {
                    case UnitSystem.metric:
                      return 'Metric';

                    case UnitSystem.imperial:
                      return 'Imperial';
                  }
                }(),
                leading: Icon(Icons.straighten_outlined, color: Theme.of(context).iconTheme.color),
                onTap: () {
                  showDialog<void>(
                      context: context, builder: (context) => const UnitSystemDialog());
                }),
            const SettingsDivider(),
            const SettingsHeader(title: 'Interface'),
            SettingsTile(
                title: 'Theme',
                subtitle: () {
                  switch (theme) {
                    case ThemeModel.light:
                      return 'Light';

                    case ThemeModel.dark:
                      return 'Dark';

                    case ThemeModel.systemDefault:
                      return 'System default';

                    default:
                      throw Error();
                  }
                }(),
                padding: 80.0,
                onTap: () {
                  showDialog<void>(context: context, builder: (context) => const ThemeDialog());
                }),
            SettingsTile(
                title: 'Dark theme',
                subtitle: () {
                  switch (darkTheme) {
                    case DarkThemeModel.grey:
                      return 'Default';

                    case DarkThemeModel.black:
                      return 'Black';

                    default:
                      throw Error();
                  }
                }(),
                padding: 80.0,
                onTap: () {
                  showDialog<void>(context: context, builder: (context) => const DarkThemeDialog());
                }),
            const SettingsDivider(),
            const SettingsHeader(title: 'API Key'),
            SettingsTile(
                title: 'API Key',
                subtitle: apiKey.isCustom
                    ? 'Currently, using custom API key.'
                    : 'Currently, using default API key (not recommended).',
                leading: Icon(Icons.keyboard_outlined, color: Theme.of(context).iconTheme.color),
                onTap: () async {
                  await showDialog<void>(
                      context: context, builder: (context) => const ApiKeyDialog());
                }),
            SettingsTile(
                title: 'Reset API Key',
                leading: Icon(Icons.restore_outlined, color: Theme.of(context).iconTheme.color),
                onTap: () {
                  showDialog<void>(
                      context: context, builder: (context) => const ApiKeyResetDialog());
                }),
          ],
        ),
      ),
    );
  }
}
