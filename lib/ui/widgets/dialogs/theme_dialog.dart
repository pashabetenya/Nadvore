import 'index.dart';

class ThemeDialog extends ConsumerWidget {
  static const dialogOptions = {
    'Light': ThemeModel.light,
    'Dark': ThemeModel.dark,
    'System Default': ThemeModel.systemDefault,
  };

  const ThemeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateNotifier = ref.watch(themeStateNotifierProvider.notifier);
    final theme = ref.watch(themeStateNotifierProvider.select((state) => state.theme));

    final radios = [
      for (final entry in dialogOptions.entries)
        RadioListTile<ThemeModel>(
          title: Text(
            entry.key,
            style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
          ),
          value: entry.value,
          groupValue: theme,
          onChanged: (newValue) async {
            await themeStateNotifier.setTheme(newValue!);

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
        )
    ];

    return SimpleDialog(
      title: Text(
        'Theme',
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
