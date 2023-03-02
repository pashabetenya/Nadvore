import 'index.dart';

class ApiKeyDialog extends HookConsumerWidget {
  const ApiKeyDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKeyStateNotifier = ref.watch(apiKeyStateNotifierProvider.notifier);
    final apiKey = ref.watch(apiKeyStateNotifierProvider.select((state) => state.apiKey!));

    final failure = useState<Failure?>(null);

    ref.listen<Failure?>(
      apiKeyStateNotifierProvider.select((state) => state is Error ? state.failure : null),
      (prev, next) {
        if (next != null) {
          failure.value = next;
        }
      },
    );

    ref.listen<ApiKeyState>(apiKeyStateNotifierProvider, (prev, next) {
      if (next is Loaded) {
        Navigator.pop(context);
        showSnackBar(context, text: 'API Key updated successfully.');
      }
    });

    final textController = useTextEditingController(text: apiKey.isCustom ? apiKey.apiKey : null);

    Future<void> submit() async {
      final newApiKeyString = textController.text;

      return apiKeyStateNotifier.setApiKey(
        newApiKeyString.isEmpty ? const ApiKeyModel.apiKey() : ApiKeyModel.custom(newApiKeyString),
      );
    }

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: TextField(
        controller: textController,
        cursorColor: Theme.of(context).colorScheme.secondary,
        autofocus: true,
        decoration: InputDecoration(
          errorMaxLines: 3,
          focusColor: Theme.of(context).colorScheme.secondary,
          hintText: 'Enter API Key',
          hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
          errorText: () {
            if (failure.value is InvalidApiKey) {
              return "Looks like this is an invalid API key. Please check that it's correct and try again.";
            }
          }(),
        ),
        onEditingComplete: submit,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        TextButton(
          onPressed: submit,
          child: Text('Save', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
      ],
    );
  }
}
