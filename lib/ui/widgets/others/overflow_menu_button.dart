import 'index.dart';

enum Menu { settings, help }

class OverflowMenuButton extends StatelessWidget {
  const OverflowMenuButton({super.key});

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        offset: const Offset(512.0, -512.0),
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
        tooltip: 'More options',
        itemBuilder: (context) => [
          PopupMenuItem(
            value: Menu.settings,
            child: ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const SettingPage(),
                  ),
                );
              },
            ),
          ),
        ],
      );
}
