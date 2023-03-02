import 'index.dart';

class DarkThemeDialog extends ConsumerWidget {
  static const dialogOptions = {
    'Default': DarkThemeModel.grey,
    'Black': DarkThemeModel.black,
  };

  const DarkThemeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateNotifier = ref.watch(themeStateNotifierProvider.notifier);
    final darkTheme = ref.watch(
      themeStateNotifierProvider.select((state) => state.darkTheme),
    );

    final radios = [
      for (final entry in dialogOptions.entries)
        RadioListTile<DarkThemeModel>(
          title: Text(
            entry.key,
            style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
          ),
          value: entry.value,
          groupValue: darkTheme,
          onChanged: (newValue) {
            themeStateNotifier.setDarkTheme(newValue!);
            Navigator.pop(context);
          },
        )
    ];

    return SimpleDialog(
      title: Text(
        'Dark Theme',
        style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
      ),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: radios,
        ),
      ],
    );
  }
}
