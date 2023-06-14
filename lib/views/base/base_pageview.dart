import '../../public.dart';

//封装视图view

class KBasePageView extends StatelessWidget {
  KBasePageView(
      {Key? key,
      required this.child,
      this.title,
      this.bottom,
      this.hiddenAppBar,
      this.hiddenLeading,
      this.bottomNavigationBar,
      this.leadBack,
      this.actions,
      this.leading,
      this.hiddenResizeToAvoidBottomInset = true,
      this.elevation = 0,
      this.backgroundColor = Colors.white,
      this.safeAreaTop = true,
      this.safeAreaLeft = true,
      this.safeAreaBottom = true,
      this.safeAreaRight = true,
      this.overlayStyle,
      this.barColor,
      this.centerTitle = true})
      : super(key: key);

  Widget child;
  Widget? title;
  final PreferredSizeWidget? bottom;
  final bool? hiddenAppBar;
  final bool? hiddenLeading;
  final bool hiddenResizeToAvoidBottomInset; //是否弹出软键盘压缩界面
  final Widget? bottomNavigationBar;
  final VoidCallback? leadBack;
  final List<Widget>? actions;
  final Widget? leading;
  final double elevation;
  final Color backgroundColor;
  final bool safeAreaTop;
  final bool safeAreaLeft;
  final bool safeAreaBottom;
  final bool safeAreaRight;
  final SystemUiOverlayStyle? overlayStyle;
  final Color? barColor;
  final bool centerTitle;

  static Widget getBack(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Center(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //全局拦截键盘处理
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: hiddenResizeToAvoidBottomInset,
        appBar: hiddenAppBar == true
            ? null
            : AppBar(
                title: title,
                centerTitle: centerTitle,
                elevation: elevation,
                bottom: bottom,
                backgroundColor: barColor ?? Colors.white,
                actions: actions,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                leading: hiddenLeading == true
                    ? Container()
                    : leading ??
                        getBack(() {
                          if (leadBack != null) {
                            leadBack!();
                          } else {
                            Get.back(result: {});
                          }
                        })),
        backgroundColor: backgroundColor,
        bottomNavigationBar: this.bottomNavigationBar,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
        top: safeAreaTop,
        left: safeAreaLeft,
        bottom: safeAreaBottom,
        right: safeAreaRight,
        child: child);
  }
}
