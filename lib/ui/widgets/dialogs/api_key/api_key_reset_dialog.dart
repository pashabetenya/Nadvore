import 'index.dart';

class ApiKeyResetDialog extends ConsumerWidget {
  const ApiKeyResetDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AlertDialog(
        title: Text(
          'Reset API Key?',
          style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(apiKeyStateNotifierProvider.notifier)
                  .setApiKey(const ApiKeyModel.apiKey());

              // ignore: use_build_context_synchronously
              showSnackBar(context, text: 'API key reset successfully.');

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(
              'Reset',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      );
}
