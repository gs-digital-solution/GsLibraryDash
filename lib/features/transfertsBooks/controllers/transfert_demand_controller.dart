import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/services/transfert_service.dart';

import '../../auth/auth/controller/authController.dart';
import '../models/transfert.dart';

class TransfertDemandController extends GetxController
    with StateMixin<List<TransfertDevice>> {
  RxList<TransfertDevice> categoryList = <TransfertDevice>[].obs;

  final TransfertService categoryService = Get.put(TransfertService());
  final AuthController authController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value = await categoryService.getTransfertBookRequest();
      if (categoryList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(
          categoryList.reversed.toList(),
          status: RxStatus.success(),
        );
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  Future<void> validateTransfert(
      {TransfertDevice? transfertDevice, BuildContext? context}) async {
    try {
      bool value = await categoryService.validateTransfert(
        id: transfertDevice!.sId,
        deviceId: transfertDevice.newDeviceId,
        userId: transfertDevice.user!.sId,
      );
      transfertDevice.status!.value = 1;
      showCustomToast(
          context: context!, message: "Transfert effectué avec succès.");
    } on AppException catch (e) {
      showCustomToast(context: context!, message: e.message!);
    }
  }

  Future<void> cancelTransfert(
      {TransfertDevice? transfertDevice, BuildContext? context}) async {
    try {
      bool value = await categoryService.cancelTransfertBook(
        id: transfertDevice!.sId,
      );
      transfertDevice.status!.value = -1;
      showCustomToast(
          context: context!, message: "Demande de transfert Rejetée");
    } on AppException catch (e) {
      showCustomToast(context: context!, message: e.message!);
    }
  }
}
