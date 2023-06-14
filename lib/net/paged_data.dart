// import 'api_stream/api_stream.dart';

// class ApiModel<T> {
//   bool isFromLocal = false;
// }

// class CSPagedData<T> extends ApiModel<T> {
//   final Key easyRefreshKey, listViewKey;
//   int rows;
//   bool _nextPage = false;
//   bool get nextPage {
//     return _nextPage;
//   }

//   set nextPage(bool value) {
//     if (!value) currentPage = 1;
//     _nextPage = value;
//   }

//   int currentPage = 1;
//   BuildContext? context;
//   final int defaultFirstPage;
//   int get requestPage {
//     int page = defaultFirstPage;
//     if (nextPage) {
//       page = 1 + currentPage;
//     }
//     return page;
//   }

//   VMApiStream? apiHandler;
//   // State? pageState;

//   final List<T> sources = [];
//   EasyRefreshController? refreshController = EasyRefreshController();
//   bool hasMore = false;

//   CSPagedData({int defaultFirstPage = 1, this.rows = 20, String nameKey = ''})
//       : this.defaultFirstPage = defaultFirstPage,
//         this.easyRefreshKey = Key(nameKey),
//         this.listViewKey = Key(nameKey);

//   Future<void> dealRemoteSources(List<T> value) async {
//     try {
//       if (nextPage) {
//         if (value.length > 0) currentPage += 1;
//       } else {
//         sources.clear();
//       }
//       sources.addAll(value);
//       hasMore = value.length >= rows;
//       refreshController?.finishLoad(noMore: !hasMore);
//       // context?.markNeedsBuild();
//       // await context?.hideLoading();
//     } catch (e) {
//       final t = e;
//     }
//   }

//   Future<void> dealFailure(dynamic value) async {
//     try {
//       refreshController?.finishRefresh(success: false);
//       refreshController?.finishLoad(success: false);
//       if (value is String)
//         HWToast.showText(value);
//       else if (value is VMResult) {
//         final VMResult result = value;
//         HWToast.showText(result.error);
//       }
//     } catch (e) {
//       final t = e;
//     }
//   }

//   Future<void> dealCancelled() async {
//     try {
//       refreshController?.finishRefresh(success: false);
//       refreshController?.finishLoad(success: false);
//       HWToast.hideAll();
//       // return context.hideLoading();
//     } catch (e) {
//       final t = e;
//     }
//   }

//   // BorderRadius borderRadius(int index, {@required double radius}) {
//   //   return MSBorderRadius(index: index, sum: sources.length, radius: radius);
//   // }

//   void destroy() {
//     refreshController = null;
//     context = null;
//   }
// }
