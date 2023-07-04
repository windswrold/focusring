import '../../public.dart';

class DialogDefaultHeader extends StatelessWidget {
  const DialogDefaultHeader(
      {Key? key, this.onCancel, this.onConfirm, required this.title})
      : super(key: key);

  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            "cancel".tr,
            style: Get.textTheme.bodyMedium,
          ),
        ),
        Text(
          title,
          style: Get.textTheme.bodyLarge,
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text("save".tr, style: Get.textTheme.titleMedium),
        )
      ],
    );
  }
}
