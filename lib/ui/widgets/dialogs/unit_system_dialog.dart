import 'index.dart';
import 'package:weather/ui/states/unit_system_state_notifier.dart';

class UnitSystemDialog extends ConsumerWidget {
  static const dialogOptions = {
    'Metric': UnitSystem.metric,
    'Imperial': UnitSystem.imperial,
  };

  const UnitSystemDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitSystemState = ref.watch(unitSystemStateNotifierProvider);
    final unitSystemStateNotifier = ref.watch(unitSystemStateNotifierProvider.notifier);

    final radios = [
      for (final entry in dialogOptions.entries)
        RadioListTile<UnitSystem>(
          title: Text(
            entry.key,
            style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
          ),
          value: entry.value,
          groupValue: unitSystemState.unitSystem,
          onChanged: (newValue) {
            unitSystemStateNotifier.setUnitSystem(newValue!);
            Navigator.pop(context);
          },
        )
    ];

    return SimpleDialog(
      title: Text(
        'Unit System',
        style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
      ),
      children: [Column(mainAxisSize: MainAxisSize.min, children: radios)],
    );
  }
}
