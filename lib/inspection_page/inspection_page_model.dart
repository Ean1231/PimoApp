import '/components/inspection_list2_widget.dart';
import '/components/inspection_list3_widget.dart';
import '/components/inspection_list_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InspectionPageModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;
  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for inspectionList component.
  late InspectionListModel inspectionListModel;
  // Model for inspectionList2 component.
  late InspectionList2Model inspectionList2Model;
  // Model for inspectionList3 component.
  late InspectionList3Model inspectionList3Model;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    inspectionListModel = createModel(context, () => InspectionListModel());
    inspectionList2Model = createModel(context, () => InspectionList2Model());
    inspectionList3Model = createModel(context, () => InspectionList3Model());
  }

  void dispose() {
    unfocusNode.dispose();
    inspectionListModel.dispose();
    inspectionList2Model.dispose();
    inspectionList3Model.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.

}
