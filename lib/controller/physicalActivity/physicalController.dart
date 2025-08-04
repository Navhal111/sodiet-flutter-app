import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../helper/response_model.dart';
import '../../repo/authRepo.dart';

class PhysicalActivityController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  PhysicalActivityController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingList = false.obs;

  getDietRecallList() async {
    isLoadingList.value = true;
    Response response =
        await authRepo.getDataSet(apiName: AppConstants.GET_PA_RECALL);
    ResponseModel responseModel;
    Map<String, dynamic> responcejson = response.body;
    if (response.statusCode == 200) {
    } else {}
    isLoadingList.value = false;
  }

  addDietRecall(Map<String, dynamic> dietData) async {
    isLoading.value = true;
    Response response = await authRepo.postDataSet(
      sendData: dietData,
      apiName: AppConstants.GET_PA_RECALL,
    );
    ResponseModel responseModel;
    Map<String, dynamic> responcejson = response.body;
    if (response.statusCode == 200) {
      getDietRecallList();
      // Handle success
    } else {
      // Handle error
    }
    isLoading.value = false;
  }
}
