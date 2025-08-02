import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../helper/response_model.dart';
import '../../model/diet_recall_model.dart';
import '../../repo/authRepo.dart';

class DietController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  DietController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingList = false.obs;

  DietRecallListResponse? dietRecallListResponse;
  RxList<DietRecall> dietRecallList = <DietRecall>[].obs;

  getDietRecallList() async {
    isLoadingList.value = true;
    Response response =
        await authRepo.getDataSet(apiName: AppConstants.GET_DIET_RECALES);
    if (response.statusCode == 200) {
      dietRecallListResponse = DietRecallListResponse.fromJson(response.body);
      dietRecallList.addAll(dietRecallListResponse!.recalls);
    } else {
      dietRecallListResponse = null;
    }
    isLoadingList.value = false;
    update();
  }

  addDietRecall(Map<String, dynamic> dietData) async {
    isLoading.value = true;
    Response response = await authRepo.postDataSet(
      sendData: dietData,
      apiName: AppConstants.GET_DIET_RECALES,
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
