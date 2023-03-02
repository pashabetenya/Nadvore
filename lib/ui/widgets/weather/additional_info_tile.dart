import 'index.dart';

class AdditionalInfoTile extends StatelessWidget {
  const AdditionalInfoTile({
    super.key,
    this.title,
    this.value,
  });

  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(title!, style: kAdditionalInfoTileTitle(context)),
            ),
            Text(value!, style: kAdditionalInfoTileValue(context)),
          ],
        ),
      );
}
