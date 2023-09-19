import 'package:get/get.dart';

class OrderNowController extends GetxController {
  RxString _deliverySystem = "JNE".obs;
  RxString _paymentSystem = "Debit".obs;

  String get deliverySys => _deliverySystem.value;
  String get paymentSys => _paymentSystem.value;

  setDeliverySystem( String newDeliverySystem) {
    _deliverySystem.value = newDeliverySystem;
  }

  setPaymentSystem( String newPaymentSystem) {
    _paymentSystem.value = newPaymentSystem;
  }
}