import '../public.dart';

class TraLedButton extends StatelessWidget {
  const TraLedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 61.w, right: 61.w, top: 12.w),
      child: Row(
        children: [
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_left@3x.png",
            title: "",
          ),
          Expanded(
            child: Text(
              "data",
              textAlign: TextAlign.center,
            ),
          ),
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_right@3x.png",
            title: "",
          ),
        ],
      ),
    );
  }
}
