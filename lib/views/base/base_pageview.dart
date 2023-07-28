import '../../public.dart';

//封装视图view

class KBasePageView extends StatelessWidget {
  KBasePageView(
      {Key? key,
      required this.body,
      this.title,
      this.titleStr,
      this.bottom,
      this.hiddenAppBar,
      this.hiddenLeading,
      this.bottomNavigationBar,
      this.leadBack,
      this.actions,
      this.leading,
      this.hiddenResizeToAvoidBottomInset = true,
      this.elevation = 0,
      this.backgroundColor,
      this.safeAreaTop = true,
      this.safeAreaLeft = true,
      this.safeAreaBottom = true,
      this.safeAreaRight = true,
      this.overlayStyle,
      this.barColor,
      this.centerTitle = true,
      this.leadingWidth})
      : super(key: key);

  Widget body;
  Widget? title;
  String? titleStr;
  final PreferredSizeWidget? bottom;
  final bool? hiddenAppBar;
  final bool? hiddenLeading;
  final bool hiddenResizeToAvoidBottomInset; //是否弹出软键盘压缩界面
  final Widget? bottomNavigationBar;
  final VoidCallback? leadBack;
  final List<Widget>? actions;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final bool safeAreaTop;
  final bool safeAreaLeft;
  final bool safeAreaBottom;
  final bool safeAreaRight;
  final SystemUiOverlayStyle? overlayStyle;
  final Color? barColor;
  final bool centerTitle;
  final double? leadingWidth;

  static Widget getBack(VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      icon: LoadAssetsImage(
        "icons/arrow_back",
      ),
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
                title: titleStr != null ? titleWidget(titleStr!) : title,
                centerTitle: centerTitle,
                leadingWidth: leadingWidth ?? 40.w,
                titleSpacing: hiddenLeading == true ? 16.w : 0,
                elevation: elevation,
                bottom: bottom,
                backgroundColor: barColor ?? Get.theme.backgroundColor,
                actions: actions,
                systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
                leading: hiddenLeading == true
                    ? null
                    : Navigator.canPop(context) == false
                        ? leading ?? Container()
                        : leading ??
                            getBack(() {
                              if (leadBack != null) {
                                leadBack!();
                              } else {
                                Get.back(result: {});
                              }
                            }),
              ),
        backgroundColor: backgroundColor ?? Get.theme.backgroundColor,
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
        child: body);
  }

  static Widget titleWidget(String title) {
    return Text(
      title,
      style: Get.textTheme.titleLarge,
      textAlign: TextAlign.left,
    );
  }
}
