import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Model/Accountant/accountLoginModel.dart';
import 'package:shipment/Model/Accountant/accountantUpdateProfileModel.dart';
import 'package:shipment/Model/Accountant/getAccountantProfileModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivalChangestatusModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivalManagerLoginModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivalbookingModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivaldashboardSearvhModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivaldashboardStatsModel.dart';
import 'package:shipment/Model/ArrivalManager/getArrivalDashboardModel.dart';
import 'package:shipment/Model/ArrivalManager/getArrivalProfileModel.dart';
import 'package:shipment/Model/ArrivalManager/updateArrivalProfileModel.dart';
import 'package:shipment/Model/Client/GetReceptionDetailsModel.dart';
import 'package:shipment/Model/Client/SchduleShipmentReviewModel.dart';
import 'package:shipment/Model/Client/ScheduleItemModel.dart';
import 'package:shipment/Model/Client/ShowClientReviewModel.dart';
import 'package:shipment/Model/Client/SocialLoginModel.dart';
import 'package:shipment/Model/Client/ViewBookingModel.dart';
import 'package:shipment/Model/Client/ViewScheduleShipment.dart';
import 'package:shipment/Model/Client/addBookingModel.dart';
import 'package:shipment/Model/Client/addReceptionistModel.dart';
import 'package:shipment/Model/Client/clienclearNotificationModel.dart';
import 'package:shipment/Model/Client/clientDeactivatedModel.dart';
import 'package:shipment/Model/Client/clientListTransactionModel.dart';
import 'package:shipment/Model/Client/clientLoginModel.dart';
import 'package:shipment/Model/Client/clientNoticationModel.dart';
import 'package:shipment/Model/Client/clientRegisterModel.dart';
import 'package:shipment/Model/Client/clientResetPasswordModel.dart';
import 'package:shipment/Model/Client/clientSearchAllModel.dart';
import 'package:shipment/Model/Client/clientViewCardModel.dart';
import 'package:shipment/Model/Client/clientnotificationcountmodel.dart';
import 'package:shipment/Model/Client/clientsavecardmodel.dart';
import 'package:shipment/Model/Client/forgotpasswordmodel.dart';
import 'package:shipment/Model/Client/getClientProfile.dart';
import 'package:shipment/Model/Client/getPriceModel.dart';
import 'package:shipment/Model/Client/getReceptionistModel.dart';
import 'package:shipment/Model/Client/getScheduleDetailsModel.dart';
import 'package:shipment/Model/Client/getScheduleItemModel.dart';
import 'package:shipment/Model/Client/getTexTmode.dart';
import 'package:shipment/Model/Client/getViewRecepinstModel.dart';
import 'package:shipment/Model/Client/marketPlaceModel.dart';
import 'package:shipment/Model/Client/showScheduleItemsModel.dart';
import 'package:shipment/Model/Client/updateClientBookingModel.dart';
import 'package:shipment/Model/Client/updateClientProfile.dart';
import 'package:shipment/Model/Client/verifyordermodel.dart';
import 'package:shipment/Model/Client/viewMarketPlaceBooking.dart';
import 'package:shipment/Model/Client/viewProposalModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/assignPickupAgentModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/dapaturegetProfileModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depatureDashboardModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depatureLoginModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depatureUpdateProfileModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturechangestatusmodel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depatureordermodel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturesearchtitlesssModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depauterStatsdashboardModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/getPickupAgentModel.dart';
import 'package:shipment/Model/PickupAgent/pickDashboardStausModel.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentBookingMode.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentDashboardModel.dart';
import 'package:shipment/Model/PickupAgent/pickupChangstatusmodel.dart';
import 'package:shipment/Model/PickupAgent/pickupchangeStatusModel.dart';
import 'package:shipment/Model/PickupAgent/pickupdashboardSearchStatusModel.dart';
import 'package:shipment/Model/Receptionist/getReceptionistProfileModel.dart';
import 'package:shipment/Model/Receptionist/getReceptionistSearchModel.dart';
import 'package:shipment/Model/Receptionist/getReceptionistorderstatsmodel.dart';
import 'package:shipment/Model/Receptionist/receptionistBookingModel.dart';
import 'package:shipment/Model/Receptionist/receptionistLoginModel.dart';
import 'package:shipment/Model/Receptionist/receptionistUpdateProfileModel.dart';
import 'package:shipment/Model/Receptionist/receptionmarketchangeStatusModel.dart';
import 'package:shipment/Model/Shipment/AddEmployeeModel.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentLoginModel.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentProfileModel.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentUpdateprofileModel.dart';
import 'package:shipment/Model/Shipment/DisplayShipmentReviewModel.dart';
import 'package:shipment/Model/Shipment/ReviewCommentModel.dart';
import 'package:shipment/Model/Shipment/SendProposalModel.dart';
import 'package:shipment/Model/Shipment/ShipmentOrderModel.dart';
import 'package:shipment/Model/Shipment/ShipmentgetProfileModel.dart';
import 'package:shipment/Model/Shipment/acceptMarketplaceBookingModel.dart';
import 'package:shipment/Model/Shipment/addItemTypeModel.dart';
import 'package:shipment/Model/Shipment/broadCastMessageModel.dart';
import 'package:shipment/Model/Shipment/chat/chatHistoryModel.dart';
import 'package:shipment/Model/Shipment/chat/chatListModel.dart';
import 'package:shipment/Model/Shipment/chat/createRoomModel.dart';
import 'package:shipment/Model/Shipment/chat/sendMessageModel.dart';
import 'package:shipment/Model/Shipment/delItemsModel.dart';
import 'package:shipment/Model/Shipment/getCouponDataModel.dart';
import 'package:shipment/Model/Shipment/getCouponListModel.dart';
import 'package:shipment/Model/Shipment/getDepatureManagerListModel.dart';
import 'package:shipment/Model/Shipment/getMarketplaceBookingModel.dart';
import 'package:shipment/Model/Shipment/getShipmentConfirmOrderModel.dart';
import 'package:shipment/Model/Shipment/getShipmentEmployeeModel.dart';
import 'package:shipment/Model/Shipment/getShipmentMarkrtPlaceModel.dart';
import 'package:shipment/Model/Shipment/getShipmentStatsMode.dart';
import 'package:shipment/Model/Shipment/getarrivalMangerList.dart';
import 'package:shipment/Model/Shipment/marketplaceOrderDataModel.dart';
import 'package:shipment/Model/Shipment/previousbookingmodel.dart';
import 'package:shipment/Model/Shipment/scheduleShipmentRes.dart';
import 'package:shipment/Model/Shipment/shipmentAcceptedOrderModel.dart';
import 'package:shipment/Model/Shipment/shipmentConfirmordersModel.dart';
import 'package:shipment/Model/Shipment/shipmentForgotpasswordModel.dart';
import 'package:shipment/Model/Shipment/shipmentLoginModal.dart';
import 'package:shipment/Model/Shipment/shipmentNotificationModel.dart';
import 'package:shipment/Model/Shipment/shipmentRegisterModel.dart';
import 'package:shipment/Model/Shipment/shipmentResetPasswordModel.dart';
import 'package:shipment/Model/Shipment/shipmentSchedulModel.dart';
import 'package:shipment/Model/Shipment/shipmentSearchModel.dart';
import 'package:shipment/Model/Shipment/shipmentclearNotificationModel.dart';
import 'package:shipment/Model/Shipment/shipmentdonebookingModel.dart';
import 'package:shipment/Model/Shipment/shipmentnotificationcountmodel.dart';
import 'package:shipment/Model/Shipment/shipmentrjectorderModel.dart';

import 'package:shipment/Model/Shipment/shipmentupdateprofileModel.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Model/Shipment/subscriptionlistModel.dart';
import 'package:shipment/Model/Shipment/userDeactivatedModel.dart';
import 'package:shipment/Model/Shipment/viewShipmentMarketPlaceBookingModel.dart';
import 'package:shipment/Model/chatSearchListModel.dart';
import 'package:shipment/Model/test_model.dart';

import '../constants.dart';

class Providers {
  var authToken,
      ReceptionistToken,
      shipmentauthToken,
      pickAgentToken,
      accountantToken,
      depatureToken,
      arrivalManagerToken;
  String baseUrl = 'https://shipment.engineermaster.in/api/';
  String chatBaseUrl = 'http://44.194.48.17:4000/api/v1/';

  Future<ClientRegisterModel> registrationClient(signupData) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'registerClient'),
      body: signupData,
    );
    print(response.body);
    return ClientRegisterModel.fromJson(json.decode(response.body));
  }

  Future<ClientLoginModel> loginCommon(loginData) async {
    print("Login ====> Client $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'loginAll'),
      body: loginData,
    );
    print(response.body);

    return ClientLoginModel.fromJson(json.decode(response.body));
  }

  Future<ClientLoginModel> loginClient(loginData) async {
    print("Login====> true $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'login'),
      body: loginData,
    );
    print(response.body);

    return ClientLoginModel.fromJson(json.decode(response.body));
  }

  Future<ClientForgotPasswordModel> ForgotPassword(ForgotPassworddata) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'forgot-password'),
      body: ForgotPassworddata,
    );
    print(response.body);

    return ClientForgotPasswordModel.fromJson(json.decode(response.body));
  }

  Future<ClientForgotPasswordModel> AllForgotPassword(
      ForgotPassworddata) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'all-forgot-password'),
      body: ForgotPassworddata,
    );
    print(response.body);

    return ClientForgotPasswordModel.fromJson(json.decode(response.body));
  }

  Future<VerifyOtpmodel> verifyOtp(VerifyOtpdata) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'verifyOtp'),
      body: VerifyOtpdata,
    );
    print(response.body);

    return VerifyOtpmodel.fromJson(json.decode(response.body));
  }

  Future<ResendOtpModel> resendOtp(ResendOtpdata) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'resendOtp'),
      body: ResendOtpdata,
    );
    print(response.body);

    return ResendOtpModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentRegisterModel> registrationShipment(shipmentData) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'registerShipment'),
      body: shipmentData,
    );
    print(response.body);
    return ShipmentRegisterModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentLoginModal> loginShipment(loginData) async {
    print("Login $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'loginShipment'),
      body: loginData,
    );
    print(response.body);

    return ShipmentLoginModal.fromJson(json.decode(response.body));
  }

  Future<ShipmentForgotPasswordModel> shipmentForgotPassword(
      forgotPassworddata) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'forgot-password-shipment'),
      body: forgotPassworddata,
    );
    print(response.body);

    return ShipmentForgotPasswordModel.fromJson(json.decode(response.body));
  }

  Future<GetClientProfile> getClientProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'clientProfile'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return GetClientProfile.fromJson(json.decode(response.body));
  }

  Future<ResetPasswordModel> getResetPassword(resetData) async {
    print("Reset $resetData");
    final client = new http.Client();
    final response = await client.put(
      Uri.parse(baseUrl + 'resetPassword'),
      body: resetData,
    );
    print(">>>>>>>>>>>>>>>>>>>" + response.body);

    return ResetPasswordModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentResetPasswordModel> getShipmentResetPassword(resetData) async {
    print("Reset $resetData");
    final client = new http.Client();
    final response = await client.put(
      Uri.parse(baseUrl + 'passwordReset'),
      body: resetData,
    );
    print(">>>>>>>>>>>>>>>>>>>" + response.body);

    return ShipmentResetPasswordModel.fromJson(json.decode(response.body));
  }

  Future<UpdateClientProfile> updateClient(udpateData) async {
    print("Login $udpateData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateClientProfile'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
      body: udpateData,
    );
    print(response.body);

    return UpdateClientProfile.fromJson(json.decode(response.body));
  }

  Future<ShipmentgetProfileModel> getshipmentProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentProfile'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return ShipmentgetProfileModel.fromJson(json.decode(response.body));
  }

  Future<UpdateShipmentProfile> updateShipment(udpateData) async {
    print("Login $udpateData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateShipmentProfile'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: udpateData,
    );
    print(response.body);

    return UpdateShipmentProfile.fromJson(json.decode(response.body));
  }

  Future<ScheduleModel> getschedules() async {
    final prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final client = new http.Client();
    final response = await client.get(
      Uri.parse("${baseUrl}schedules"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );
    print("schedule response>>>>>>>>>>>>___________" + response.body);
    return ScheduleModel.fromJson(json.decode(response.body));
  }

  Future<ViewScheduleShipment> getScheduleShipment() async {
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewScheduleShipment'),
    );

    print("Print here>>>" + response.body);
    return ViewScheduleShipment.fromJson(json.decode(response.body));
  }

  Future<ConfirmOrdersModel> shipmentcnfirmtOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("ConfirmToken $shipmentauthToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'confirmedOrders'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );
    print(response.body);

    return ConfirmOrdersModel.fromJson(json.decode(response.body));
  }

  Future<ViewBookingModel> getViewBooking() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    final client = new http.Client();
    //print("object $authToken");
    final response = await client.get(
      Uri.parse("${baseUrl}viewBooking"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    // print('api calling');
    //print(response.body);
    return ViewBookingModel.fromJson(json.decode(response.body));
  }

  Future<ViewMarketBookingModel> getViewMarketAcceotBooking() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    final client = new http.Client();
    print("object $authToken");
    final response = await client.get(
      Uri.parse(baseUrl + 'viewAcceptedMarket'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    // print('api calling');
    print(response.body);
    return ViewMarketBookingModel.fromJson(json.decode(response.body));
  }

  Future<GetReceptionistModel> getReceptionist() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    final client = new http.Client();

    print("object $authToken");
    final response = await client.get(
      Uri.parse(baseUrl + 'viewReceptionist'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    // print('api calling');
    print(response.body);
    return GetReceptionistModel.fromJson(json.decode(response.body));
  }

  Future<SaveCardModel> saveCardApiCall(saveData) async {
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.post(
      Uri.parse(baseUrl + 'saveCard'),
      headers: {'Accept': 'application/json', "token": authToken},
      body: saveData,
    );
    print(response.body);
    return SaveCardModel.fromJson(json.decode(response.body));
  }

  Future<ViewCardModel> getViewCard() async {
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.get(
      Uri.parse(baseUrl + 'viewCard'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return ViewCardModel.fromJson(json.decode(response.body));
  }

  Future<ListTransactionModel> getListTransaction() async {
    // final String url = 'http://13.233.199.47/api/listTransaction';
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.get(
      Uri.parse(baseUrl + 'listTransaction'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(" body  ${response.body}");
    return ListTransactionModel.fromJson(json.decode(response.body));
  }

  Future<MarketPlaceListTransaction> getMarketPlaceListTransaction() async {
    // final String url = 'http://13.233.199.47/api/listTransaction';
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.get(
      Uri.parse("${baseUrl}listTransactionMarket"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(" body  ${response.body}");
    return MarketPlaceListTransaction.fromJson(json.decode(response.body));
  }

  Future<AddBookingModel> createBooking(bookingData) async {
    final client = new http.Client();
    print("1");
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.post(
      Uri.parse(baseUrl + 'bookingAdd'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
      body: bookingData,
    );
    print("2");
    print(response.body);
    return AddBookingModel.fromJson(json.decode(response.body));
  }

  Future<ClientBookingModel> shipmentClientBooking(data) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'get-bookings'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        // "token": shipmentauthToken
      },
      body: data,
    );
    print("shddddddddddd??????????" + response.body);

    return ClientBookingModel.fromJson(json.decode(response.body));
  }

  Future<ShowScheduleItemsModel> getScheduleItemList() async {
    final prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final client = new http.Client();

    print("object $shipmentauthToken");
    final response = await client.get(
      Uri.parse("${baseUrl}schedule-items"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    // final client = new http.Client();
    // final response = await client.get(
    //   Uri.parse(baseUrl + 'schedule-items'),
    // );

    print(response.body);
    return ShowScheduleItemsModel.fromJson(json.decode(response.body));
  }

  Future<MarketPlaceModel> marketPlace(marketPlaceData) async {
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.post(
      Uri.parse(baseUrl + 'marketPlace'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
      body: marketPlaceData,
    );
    print("objectobjectobjectobject");
    print(response.body);
    return MarketPlaceModel.fromJson(json.decode(response.body));
  }

  Future<GetScheduleDetails> getScheduleDetails(id) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'scheduleDetail'),
      body: id,
    );
    print(response.body);
    return GetScheduleDetails.fromJson(json.decode(response.body));
  }

  Future<GetPriceModel> getItemPrice(data) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'calculation'),
      body: data,
    );
    print(response.body);
    return GetPriceModel.fromJson(json.decode(response.body));
  }

  Future<GetScheduleItemModel> getScheduleItem(id) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'scheduleCategory'),
      body: id,
    );
    print(response.body);
    return GetScheduleItemModel.fromJson(json.decode(response.body));
  }

  Future<UpdateClientBookingModel> updateBookinClient(data) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateBooking'),
      body: data,
    );
    print(response.body);
    return UpdateClientBookingModel.fromJson(json.decode(response.body));
  }

  Future<AddReceptionistModel> addReceptionist(receptionistData) async {
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.post(
      Uri.parse(baseUrl + 'addReceptionist'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
      body: receptionistData,
    );
    print(response.body);
    return AddReceptionistModel.fromJson(json.decode(response.body));
  }

  Future<ScheduleShipmentRes> scheduleShipmentApi(receptionistData) async {
    final client = new http.Client();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final response = await client.post(
      Uri.parse(baseUrl + 'scheduleShipment'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: receptionistData,
    );
    print(response.body);
    return ScheduleShipmentRes.fromJson(json.decode(response.body));
  }
  //scheduleShipmentApi

  Future<ScheduleItemModel> getItemList() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    final client = new http.Client();

    print("object $shipmentauthToken");
    final response = await client.get(
      Uri.parse("${baseUrl}schedule-items"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return ScheduleItemModel.fromJson(json.decode(response.body));
  }

  Future<ResetPasswordModel> clientResetPassword(data) async {
    final client = new http.Client();
    final response = await client.put(
      Uri.parse(baseUrl + 'resetPassword'),
      body: data,
    );

    print(response.body);
    return ResetPasswordModel.fromJson(json.decode(response.body));
  }

  Future<ViewMarketPlaceBooking> showMarketPlaceBooking() async {
    // final String url = 'http://18.188.73.21/api/listTransaction';
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.get(
      Uri.parse("${baseUrl}viewMarketPlace"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(" body  ${response.body}");
    return ViewMarketPlaceBooking.fromJson(json.decode(response.body));
  }

  Future<ShowClientReviewModel> viewClientReview(data) async {
    // final String url = 'http://18.188.73.21/api/listTransaction';
    final client = new http.Client();
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final response = await client.post(
      Uri.parse("${baseUrl}displayClientReview"),
      body: data,
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": authToken
      },
    );

    print(" body  ${response.body}");
    return ShowClientReviewModel.fromJson(json.decode(response.body));
  }

  Future<SocialLoginModel> socialLogin(socialData) async {
    print("Login $socialData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'social-auth'),
      body: socialData,
    );
    print(response.body);

    return SocialLoginModel.fromJson(json.decode(response.body));
  }

  Future<SocialLoginModel> socialclientLogin(socialData) async {
    print("Login $socialData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'client-social-login'),
      body: socialData,
    );
    print(response.body);

    return SocialLoginModel.fromJson(json.decode(response.body));
  }

  Future<SocialLoginModel> socialfbLogin(socialData) async {
    print("Login $socialData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'client-social-login'),
      body: socialData,
    );
    print(response.body);

    return SocialLoginModel.fromJson(json.decode(response.body));
  }

  Future<SearchClientModel> searchClient(searchData) async {
    print("data  $searchData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'search-all'),
      body: searchData,
    );
    print(response.body);

    return SearchClientModel.fromJson(json.decode(response.body));
  }

  Future<SchduleShipmentReviewModel> scheduleshipmentReview(data) async {
    print("data  $data");
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'clientReview'),
      body: data,
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": authToken
      },
    );
    print(response.body);

    return SchduleShipmentReviewModel.fromJson(json.decode(response.body));
  }

  Future<ClientDeactivateModel> getDeativate() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    final client = new http.Client();
    print("object $authToken");
    final response = await client.get(
      Uri.parse("${baseUrl}deactivateProfile"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    // print('api calling');
    print(response.body);
    return ClientDeactivateModel.fromJson(json.decode(response.body));
  }

  Future<ClientDeactivateModel> getShipmentDeativate() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    final client = new http.Client();
    print("object $authToken");
    final response = await client.get(
      Uri.parse("${baseUrl}deactivateProfileShipment"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    // print('api calling');
    print(response.body);
    return ClientDeactivateModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentSearchModel> searchShipment(searchData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("data  $searchData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'search-title'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: searchData,
    );
    print(response.body);

    return ShipmentSearchModel.fromJson(json.decode(response.body));
  }

  // Future<ShipmentSearchModel> searchArrival(searchData) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   arrivalManagerToken = prefs.getString('Arrival_Manager_token');
  //   final client = new http.Client();
  //   final response = await client.post(
  //     Uri.parse(baseUrl + 'search-titles'),
  //     headers: {
  //       // 'Content-type': 'application/json',
  //       // 'Accept': 'application/json',
  //       "token": arrivalManagerToken
  //     },
  //     body: searchData,
  //   );
  //   print(response.body);

  //   return ShipmentSearchModel.fromJson(json.decode(response.body));
  // }

  Future<DepatureSearchTileModel> searchPickupAgent(searchData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'search-titles'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": pickAgentToken
      },
      body: searchData,
    );
    print(response.body);

    return DepatureSearchTileModel.fromJson(json.decode(response.body));
  }

  Future<DepatureSearchTileModel> searchDepatureManager(searchData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'search-titles'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": depatureToken
      },
      body: searchData,
    );
    print(response.body);

    return DepatureSearchTileModel.fromJson(json.decode(response.body));
  }

  Future<DoneBookingModel> getDoneBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'doneBookings'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return DoneBookingModel.fromJson(json.decode(response.body));
  }

  Future<AcceptedOrderModel> getAcceptedOrder(Data) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'acceptOrders'),
      body: Data,
    );

    return AcceptedOrderModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentOrderModel> shipmentActiveOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentOrders'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );
    //print(response.body);
    return ShipmentOrderModel.fromJson(json.decode(response.body));
  }

  Future<GetShipmentConfirmBookingModel> getshipmentconfirmBookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'confirmedBookings'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return GetShipmentConfirmBookingModel.fromJson(json.decode(response.body));
  }

  // Future<TimerModel> getTimerFunction1() async {
  //   final client = new http.Client();
  //   final response = await client.get(
  //     Uri.parse(baseUrl + 'getTimer'),
  //   );

  //   print(response.body);
  //   return TimerModel.fromJson(json.decode(response.body));
  // }

  Future<ShipmentMarketPlaceModel> getshipmentMarktPlace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentMarketPlace'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return ShipmentMarketPlaceModel.fromJson(json.decode(response.body));
  }

  Future<GetMarketplaceBookingModel> getShipmentMarketPlaceBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentBookings'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return GetMarketplaceBookingModel.fromJson(json.decode(response.body));
  }

  Future<GetCouponListModel> getCouponList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'all-coupons'),
    );

    print(response.body);
    return GetCouponListModel.fromJson(json.decode(response.body));
  }

  Future<TaxgetModel> getTaxList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'settings'),
    );

    print(response.body);
    return TaxgetModel.fromJson(json.decode(response.body));
  }

  Future<GetCouponDataModel> getCoupon(Data) async {
    // final prefs = await SharedPreferences.getInstance();
    // authToken = prefs.getString('auth_token');
    // print("Token $authToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'check-coupon'),
      // headers: {
      //   // 'Content-type': 'application/json',
      //   'Accept': 'application/json',
      //   "token": authToken
      // },
      body: Data,
    );

    return GetCouponDataModel.fromJson(json.decode(response.body));
  }

  Future<GetReceptionDetailsModel> getReceptionDetails(Data) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'receptionist-details'),
      body: Data,
    );
    // solve-=-=-=-=-=-=-

    return GetReceptionDetailsModel.fromJson(json.decode(response.body));
  }

  Future<MarketplaceOrderDataModel> marketplaceOrderDetails(data) async {
    print(";;;;;;;;;;;;" + data.toString());
    final client = new http.Client();

    final response = await client.post(
      Uri.parse(baseUrl + 'market-details'),
      body: data,
    );

    print(response.body);

    return MarketplaceOrderDataModel.fromJson(json.decode(response.body));
  }

  Future<SendProposalModel> sendOrderProposal(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'sendProposal'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: data,
    );

    print(response.body);

    return SendProposalModel.fromJson(json.decode(response.body));
  }

  Future<AcceptMarketplaceBookingModel> acceptmarketplacebookin(Data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'acceptBooking'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: Data,
    );

    return AcceptMarketplaceBookingModel.fromJson(json.decode(response.body));
  }

  Future<PickupAgentLoginModel> loginPickupAgent(loginData) async {
    print("Login $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'loginEmployee'),
      body: loginData,
    );
    print(response.body);

    return PickupAgentLoginModel.fromJson(json.decode(response.body));
  }

  Future<PickupAgentProfileModel> getpickupAgentProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    print("Token $pickAgentToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'employeeDetails'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
    );

    print(response.body);
    return PickupAgentProfileModel.fromJson(json.decode(response.body));
  }

  Future<PickupAgentUpdateProfileModel> updatepickupAgentProfile(
      udpateData) async {
    print("Login $udpateData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    print("Token $pickAgentToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateShipmentProfile'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
      body: udpateData,
    );
    print(response.body);

    return PickupAgentUpdateProfileModel.fromJson(json.decode(response.body));
  }

  Future<DisplayShipmentReviewModel> getshipmentreview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'displayShipmentReview'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    return DisplayShipmentReviewModel.fromJson(json.decode(response.body));
  }

  Future<DepatureManagerLoginModel> loginDepatureManager(loginData) async {
    print("Login $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'loginEmployee'),
      body: loginData,
    );
    print(response.body);

    return DepatureManagerLoginModel.fromJson(json.decode(response.body));
  }

  Future<DepatureManagerProfileModel> getDepatureProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    print("Token $depatureToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'employeeDetails'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": depatureToken
      },
    );

    print(response.body);
    return DepatureManagerProfileModel.fromJson(json.decode(response.body));
  }

  Future<UpdateDepatureProflieModel> updateDepatureProfile(udpateData) async {
    print("Login $udpateData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    print("Token $depatureToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateShipmentProfile'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": depatureToken
      },
      body: udpateData,
    );
    print(response.body);

    return UpdateDepatureProflieModel.fromJson(json.decode(response.body));
  }

  Future<PickupAgentListModel> getPickupAgentlist() async {
    final prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    final client = new http.Client();

    print("object $depatureToken");
    final response = await client.get(
      Uri.parse("${baseUrl}pickupAgents"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": depatureToken
      },
    );

    print('api calling');
    print(response.body);
    return PickupAgentListModel.fromJson(json.decode(response.body));
  }

  Future<AccountantLoginModel> loginAccountant(loginData) async {
    print("Login $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'loginEmployee'),
      body: loginData,
    );
    print(response.body);

    return AccountantLoginModel.fromJson(json.decode(response.body));
  }

  Future<AccountantProfileModel> getAccountantProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountantToken = prefs.getString('Shipemnt_auth_token');
    print("Token $accountantToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'employeeDetails'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": accountantToken
      },
    );

    print(response.body);
    return AccountantProfileModel.fromJson(json.decode(response.body));
  }

  Future<AcountantUpdateProfileModel> updatedAcountantProfile(
      udpateData) async {
    print("Login $udpateData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountantToken = prefs.getString('Shipemnt_auth_token');
    print("Token $accountantToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateShipmentProfile'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": accountantToken
      },
      body: udpateData,
    );
    print(response.body);

    return AcountantUpdateProfileModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalManagerLoginModel> loginArrivalManager(loginData) async {
    print("Login $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'loginEmployee'),
      body: loginData,
    );
    print(response.body);

    return ArrivalManagerLoginModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalgetProfileModel> getArrivalManagerProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    print("Token $arrivalManagerToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'employeeDetails'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": arrivalManagerToken
      },
    );

    print(response.body);
    return ArrivalgetProfileModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalUpdateProflieModel> updateArrivalProfile(udpateData) async {
    print("Login $udpateData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    print("Token $arrivalManagerToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateShipmentProfile'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": arrivalManagerToken
      },
      body: udpateData,
    );
    print(response.body);

    return ArrivalUpdateProflieModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalDashboardSearchModel> searchArrivalManager(searchData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'search-titles'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": arrivalManagerToken
      },
      body: searchData,
    );
    print(response.body);

    return ArrivalDashboardSearchModel.fromJson(json.decode(response.body));
  }

  Future<AddEmployeeModel> addEmployee(employeeDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'addEmployee'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: employeeDetails,
    );

    print(response.body);
    return AddEmployeeModel.fromJson(json.decode(response.body));
  }

  Future<ReviewCommentModel> reviewComment(comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");
    final client = new http.Client();
    final response = await client.put(
      Uri.parse(baseUrl + 'clientReviewResponse'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: comment,
    );

    print(response.body);
    return ReviewCommentModel.fromJson(json.decode(response.body));
  }

  Future<GetArrivalManagerListModel> getArrivalManagerlist() async {
    final prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final client = new http.Client();

    print("object $shipmentauthToken");
    final response = await client.get(
      Uri.parse("${baseUrl}arrivalManager"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print('api calling');
    print(response.body);
    return GetArrivalManagerListModel.fromJson(json.decode(response.body));
  }

  Future<DepatureDashboardModel> getDepartureDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    final client = new http.Client();
    final response = await client.get(
      Uri.parse("${baseUrl}departureDashboard"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": depatureToken
      },
    );
    print(response.body);
    return DepatureDashboardModel.fromJson(json.decode(response.body));
  }

  Future<DepatureStatsModel> getdepaturehboardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    print("depaturetoken-- $depatureToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'departureStats'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": depatureToken
      },
    );

    print("hfjkhjfdjkhfjkd" + response.body);
    return DepatureStatsModel.fromJson(json.decode(response.body));
  }

  // Future<DoneBookingModel> departureOrderhistory() async {

  //   final client = new http.Client();
  //   final response = await client.get(
  //     Uri.parse("${baseUrl}departureOrders"),
  //     headers: {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       "token":
  //           "f3a677a133c847dccf58220b7ff0b678ca9728178718f75eaa06b77753289e40"
  //     },
  //   );

  //   print(response.body);
  //   return DoneBookingModel.fromJson(json.decode(response.body));
  // }

  Future<DepartureMarketOrderModel> departureMarketOrderhistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    print("depatureToken $depatureToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewAcceptedMarketShipment'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": depatureToken
      },
    );

    // print(response.body);
    return DepartureMarketOrderModel.fromJson(json.decode(response.body));
  }

  Future<PickupMarketOrderModel> pickupAgentMarketOrderhistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    print("pickAgentToken $pickAgentToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewAcceptedMarketShipment'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
    );

    // print(response.body);
    return PickupMarketOrderModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalMarketOrderModel> ArrivalMarketOrderhistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    print("arrivalManagerToken $arrivalManagerToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewAcceptedMarketShipment'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": arrivalManagerToken
      },
    );

    // print(response.body);
    return ArrivalMarketOrderModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistMarketOrderModel> receptionistMarketOrderhistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReceptionistToken = prefs.getString('receptionist_token');
    print("ReceptionistToken $ReceptionistToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewAcceptedMarket'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": ReceptionistToken
      },
    );

    // print(response.body);
    return ReceptionistMarketOrderModel.fromJson(json.decode(response.body));
  }

  Future<DepatureOrderModel> departureOrderhistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    print("depatureToken $depatureToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'departureOrders'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": depatureToken
      },
    );

    // print(response.body);
    return DepatureOrderModel.fromJson(json.decode(response.body));
  }

  Future<AssignPickupAgentModel> assignPickupAgent(pickupdata) async {
    print("Login $pickupdata");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'assignAgent'),
      body: pickupdata,
    );
    print(response.body);

    return AssignPickupAgentModel.fromJson(json.decode(response.body));
  }

  Future<AssignPickupAgentModel> assignMarketPickupAgent(pickupdata) async {
    print("Login $pickupdata");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'assignAgentMarket'),
      body: pickupdata,
    );
    print(response.body);

    return AssignPickupAgentModel.fromJson(json.decode(response.body));
  }

  Future<DepatureManagerListModel> getDepatureManagerlist() async {
    final prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final client = new http.Client();

    print("object $shipmentauthToken");
    final response = await client.get(
      Uri.parse("${baseUrl}departureManager"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print('api calling');
    print(response.body);
    return DepatureManagerListModel.fromJson(json.decode(response.body));
  }

  Future<UserManageMentModel> getViewReceptionist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $pickAgentToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewReceptionist'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return UserManageMentModel.fromJson(json.decode(response.body));
  }

  Future<ShipMentEmployeeModel> getShipmentEmployee() async {
    // final String url = 'http://18.188.73.21/api/shipmentEmployees';
    final prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final client = new http.Client();

    print("object $shipmentauthToken");
    final response = await client.get(
      Uri.parse("${baseUrl}shipmentEmployees"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    // print('api calling');
    print(response.body);
    return ShipMentEmployeeModel.fromJson(json.decode(response.body));
  }

  Future<AddItemTypeModel> addItem(itemType) async {
    // print("Login $pickupdata");
    final prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'addItems'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: itemType,
    );
    print(response.body);

    return AddItemTypeModel.fromJson(json.decode(response.body));
  }

  Future<AddItemTypeModel> addClientItem(itemType) async {
    // print("Login $pickupdata");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'addItems'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
      body: itemType,
    );
    print(response.body);

    return AddItemTypeModel.fromJson(json.decode(response.body));
  }

  // Future<ReceptionistLoginModel> loginReceptionist(loginData) async {
  //   print("Login $loginData");
  //   final client = new http.Client();
  //   final response = await client.post(
  //     Uri.parse(baseUrl + 'loginReceptionist'),
  //     body: loginData,
  //   );
  //   print(response.body);

  //   return ReceptionistLoginModel.fromJson(json.decode(response.body));
  // }

  // Future<ReceptionistProfileModel> getReceptionisProfile() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   ReceptionistToken = prefs.getString('receptionist_token');
  //   print("Token $ReceptionistToken");
  //   final String url = 'http://18.188.73.21/api/receptionistProfile';
  //   final client = new http.Client();
  //   final response = await client.get(
  //     Uri.parse('http://18.188.73.21/api/receptionistProfile'),
  //     headers: {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       "token": ReceptionistToken
  //     },
  //   );

  //   print(response.body);
  //   return ReceptionistProfileModel.fromJson(json.decode(response.body));
  // }

  // Future<ReceptionistUpdateProfileModel> updateReceptionist(udpateData) async {
  //   print("Login $udpateData");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   ReceptionistToken = prefs.getString('receptionist_token');
  //   print("Token $ReceptionistToken");
  //   final client = new http.Client();
  //   final response = await client.post(
  //     Uri.parse(baseUrl + 'updateReceptionistProfile'),
  //     headers: {
  //       // 'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       "token": ReceptionistToken
  //     },
  //     body: udpateData,
  //   );
  //   print(response.body);

  //   return ReceptionistUpdateProfileModel.fromJson(json.decode(response.body));
  // }

  Future<DelItemsModel> deleteshipmentItem(id) async {
    // print("Login $pickupdata");
    final prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'removeItems'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: id,
    );
    print(response.body);

    return DelItemsModel.fromJson(json.decode(response.body));
  }

  Future<DelItemsModel> deleteClientItem(id) async {
    // print("Login $pickupdata");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'removeItems'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
      body: id,
    );
    print(response.body);

    return DelItemsModel.fromJson(json.decode(response.body));
  }

  Future<ShowScheduleItemsModel> getClientItemList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();

    print("object $shipmentauthToken");
    final response = await client.get(
      Uri.parse("${baseUrl}schedule-items"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    // final client = new http.Client();
    // final response = await client.get(
    //   Uri.parse(baseUrl + 'schedule-items'),
    // );

    print(response.body);
    return ShowScheduleItemsModel.fromJson(json.decode(response.body));
  }

  Future<SocialLoginModel> socialShipmentLogin(socialData) async {
    print("Login -=-=-= $socialData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'shipment-social-login'),
      body: socialData,
    );
    print("response.statusCode Shipment-=-= ${response.statusCode}");

    print("response.body Shipment-=-= ${response.body}");

    return SocialLoginModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentStatsModel> getShipmentStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("shipmenttoken-- $shipmentauthToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentStats'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print("hfjkhjfdjkhfjkd" + response.body);
    return ShipmentStatsModel.fromJson(json.decode(response.body));
  }

  Future<PickupAgentDashboardModal> getpickupAgentDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    final client = new http.Client();
    final response = await client.get(
      Uri.parse("${baseUrl}pickupDashboard"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
    );
    print(response.body);
    return PickupAgentDashboardModal.fromJson(json.decode(response.body));
  }

  Future<PickupDashboardStatus> getpickupdashboardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    print("pickupAgentToken-- $pickAgentToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'pickupStats'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
    );

    print("hfjkhjfdjkhfjkd" + response.body);
    return PickupDashboardStatus.fromJson(json.decode(response.body));
  }

  Future<PickupDashboardSearchStatusModel> searchPickupAgentStatus(
      searchData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'pickup-search'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": pickAgentToken
      },
      body: searchData,
    );
    print(response.body);

    return PickupDashboardSearchStatusModel.fromJson(
        json.decode(response.body));
  }

  Future<PickupBookingModel> getpickupBookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    print("pickupAgentToken-- $pickAgentToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'pickupBookings'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
    );

    print("Pickup bookings show here" + response.body);
    return PickupBookingModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalDashboardModel> getArrivalDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    final client = new http.Client();
    final response = await client.get(
      Uri.parse("${baseUrl}arrivalDashboard"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": arrivalManagerToken
      },
    );
    print(response.body);
    return ArrivalDashboardModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalBookingModel> getArrivalBookings() async {
    final prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    final client = new http.Client();
    final response = await client.get(
      Uri.parse("${baseUrl}arrivalOrders"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": arrivalManagerToken
      },
    );
    print(response.body);
    return ArrivalBookingModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalDashboardStatesModel> getArrivalStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    print("arrival token-- $arrivalManagerToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'arrivalStats'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": arrivalManagerToken
      },
    );

    print("hfjkhjfdjkhfjkd" + response.body);
    return ArrivalDashboardStatesModel.fromJson(json.decode(response.body));
  }

  Future<DepatureSearchTileModel> searchDepature(searchData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("data  $searchData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'search-title'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: searchData,
    );
    print(response.body);

    return DepatureSearchTileModel.fromJson(json.decode(response.body));
  }

  Future<RecepChangStatusMode> changePickupStatus(pickupData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    print("data  $pickupData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'changeStatus'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": pickAgentToken
      },
      body: pickupData,
    );
    print("response.body--- ${response.body}");

    return RecepChangStatusMode.fromJson(json.decode(response.body));
  }

  Future<PickupMarketChangeStatusModel> changePickupMarketStatus(
      pickupData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    print("data  $pickupData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'changeStatusMarket'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": pickAgentToken
      },
      body: pickupData,
    );
    print("response.body--- ${response.body}");

    return PickupMarketChangeStatusModel.fromJson(json.decode(response.body));
  }

  Future<DepatureChangeStatusModel> changeDepatureStatus(depatureData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    print("data  $depatureData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'changeStatus'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": depatureToken
      },
      body: depatureData,
    );
    print("response.body--- ${response.body}");

    return DepatureChangeStatusModel.fromJson(json.decode(response.body));
  }

  Future<PickupMarketChangeStatusModel> changeMarketDepatureStatus(
      depatureData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depatureToken = prefs.getString('depature_token');
    print("data  $depatureData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'changeStatusMarket'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": depatureToken
      },
      body: depatureData,
    );
    print("response.body--- ${response.body}");

    return PickupMarketChangeStatusModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalChangeStatusModel> changeArrivalStatus(arrivalData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    print("data  $arrivalData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'changeStatus'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": arrivalManagerToken
      },
      body: arrivalData,
    );
    print("response.body--- ${response.body}");

    return ArrivalChangeStatusModel.fromJson(json.decode(response.body));
  }

  Future<ArrivalMarketChangeStatusModel> changeMarketArrivalStatus(
      arrivalData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    print("data  $arrivalData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'changeStatusMarket'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": arrivalManagerToken
      },
      body: arrivalData,
    );
    print("response.body--- ${response.body}");

    return ArrivalMarketChangeStatusModel.fromJson(json.decode(response.body));
  }
  //  Future<PickupMarketChangeStatusModel> changeMrketArrivalStatus(arrivalData) async {

  Future<ArrivalMarketChangeStatusModel> changeMrketArrivalStatus(
      arrivalData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('Arrival_Manager_token');
    print("data  $arrivalData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'changeStatusMarket'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": arrivalManagerToken
      },
      body: arrivalData,
    );
    print("response.body--- ${response.body}");

    return ArrivalMarketChangeStatusModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistChangStatusModel> changeReceptionistStatus(
      pickupData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('receptionist_token');
    print("data  $pickupData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'receptionistStatus'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": arrivalManagerToken
      },
      body: pickupData,
    );
    print("response.body--- ${response.body}");

    return ReceptionistChangStatusModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistMrktchangestatsModel> changeMarketReceptionistStatus(
      pickupData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrivalManagerToken = prefs.getString('receptionist_token');
    print("data  $pickupData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'receptionistStatusMarket'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": arrivalManagerToken
      },
      body: pickupData,
    );
    print("response.body--- ${response.body}");

    return ReceptionistMrktchangestatsModel.fromJson(
        json.decode(response.body));
  }

  Future<MapModel> getMap(value) async {
    final client = http.Client();
    final response = await client.post(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?key=$kGoogleApiKey&query=$value'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: null,
    );
    print(response.body);

    return MapModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistLoginModel> loginReceptionist(loginData) async {
    print("Login $loginData");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'loginReceptionist'),
      body: loginData,
    );
    print(response.body);

    return ReceptionistLoginModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistProfileModel> getReceptionisProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReceptionistToken = prefs.getString('receptionist_token');
    print("Token $ReceptionistToken");
    // final String url = 'http://18.188.73.21/api/receptionistProfile';
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'receptionistProfile'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": ReceptionistToken
      },
    );

    print(response.body);
    return ReceptionistProfileModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistUpdateProfileModel> updateReceptionist(udpateData) async {
    print("Login $udpateData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReceptionistToken = prefs.getString('receptionist_token');
    print("Token $ReceptionistToken");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateReceptionistProfile'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": ReceptionistToken
      },
      body: udpateData,
    );
    print(response.body);

    return ReceptionistUpdateProfileModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistBookingModel> getReceptionistBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReceptionistToken = prefs.getString('receptionist_token');
    print("Token $ReceptionistToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'receptionistDashboard'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": ReceptionistToken
      },
    );

    print(response.body);
    return ReceptionistBookingModel.fromJson(json.decode(response.body));
  }

  Future<ClientNotificationModel> getClientNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'clientNotification'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return ClientNotificationModel.fromJson(json.decode(response.body));
  }

  Future<ClientClearNotificationModel> getClientClearNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'clientClear'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return ClientClearNotificationModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentNotificationModel> getShipmentNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentNotification'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return ShipmentNotificationModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentNotificationModel> getShipmentSubPanelNotification(
      token) async {
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentNotification'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": token
      },
    );

    print(response.body);
    return ShipmentNotificationModel.fromJson(json.decode(response.body));
  }

  Future<ClientNotificationModel> getClientSubPanelNotification(token) async {
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'clientNotification'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": token
      },
    );

    print(response.body);
    return ClientNotificationModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentClearNotificationModel> getShipmentClearNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentClear'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return ShipmentClearNotificationModel.fromJson(json.decode(response.body));
  }

  Future<ShipmentClearNotificationModel> getShipmentSubPanelClearNotification(
      token) async {
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentClear'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": token
      },
    );

    print(response.body);
    return ShipmentClearNotificationModel.fromJson(json.decode(response.body));
  }

  Future<ClientClearNotificationModel> getClientSubPanelClearNotification(
      token) async {
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'clientClear'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": token
      },
    );

    print(response.body);
    return ClientClearNotificationModel.fromJson(json.decode(response.body));
  }

  //================chat
  Future<ChatSearchListModel> chatSearchList(searchData, token) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'clientnameSearch'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        'token': token
      },
      body: searchData,
    );
    //print(response.body);

    return ChatSearchListModel.fromJson(json.decode(response.body));
  }

  Future<ChatSearchListModel> chatShipmentSearchList(searchData) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'shipmentnameSearch'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
      },
      body: searchData,
    );
    //print(response.body);

    return ChatSearchListModel.fromJson(json.decode(response.body));
  }

  Future<ChatHistoryModel> ChatHistory(data) async {
    print("-=-=>>>data ChatHistory $data");

    final client = http.Client();
    final response = await client.post(
      // Uri.parse(baseUrl + 'chatHistory'),
      Uri.parse(chatBaseUrl + 'chatHistory'),

      //headers: {"token": pickAgentToken},
      body: data,
    );
    print("-=-=-=>>>> ChatHistory ${response.body}");
    return ChatHistoryModel.fromJson(json.decode(response.body));
  }

  Future<ChatListModel> getChatList(data) async {
    print("-=-= getChatList $getChatList");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(chatBaseUrl + 'chatlist'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
      },
      body: data,
    );

    print("getChatList response" + response.body);
    return ChatListModel.fromJson(json.decode(response.body));
  }

  Future<CreateRoomModel> createChatRoom(data) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(chatBaseUrl + 'createRoom'),
      headers: {"Content-Type": "application/json"},
      body: data,
    );

    print("createRoom response" + response.body);
    return CreateRoomModel.fromJson(json.decode(response.body));
  }

  Future<CreateRoomModel> createChatGroupRoom(data) async {
    print("-=-=data $data");
    final client = http.Client();
    final response = await client.post(
      Uri.parse(chatBaseUrl + 'createGroupRoom'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        // 'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );

    print("createRoom response" + response.body);
    return CreateRoomModel.fromJson(json.decode(response.body));
  }

  Future<AddGroupMemberModel> addGroupMember(data) async {
    print("-=-=data $data");
    final client = http.Client();
    final response = await client.post(
      Uri.parse(chatBaseUrl + 'addMemberInGroup'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        // 'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );

    print("createRoom response" + response.body);
    return AddGroupMemberModel.fromJson(json.decode(response.body));
  }

  Future<SendMsgModel> sendChatMessage(data) async {
    print("sendChatMessage $data");
    final client = new http.Client();
    final response = await client.post(
      // Uri.parse(chatBaseUrl + 'sendMessage'),
      Uri.parse(chatBaseUrl + 'sendMessage'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
      },
      body: data,
    );

    print("sendMessage response" + response.body);
    return SendMsgModel.fromJson(json.decode(response.body));
  }
//================chat

  Future<UserDeactivatedModel> userDeactivated(receptionistId) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'deactivateProfileReceptionist'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
      },
      body: receptionistId,
    );
    print(response.body);

    return UserDeactivatedModel.fromJson(json.decode(response.body));
  }

  Future<UserDeactivatedModel> employeeDeactivated(receptionistId) async {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'deactivateProfileEmployee'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
      },
      body: receptionistId,
    );
    print(response.body);

    return UserDeactivatedModel.fromJson(json.decode(response.body));
  }

  Future<ViewProposalModel> getViewProposal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewProposal'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return ViewProposalModel.fromJson(json.decode(response.body));
  }

  Future<ClientNotificationCountModel> getClientNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("Token $authToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'clientNotificationCount'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": authToken
      },
    );

    print(response.body);
    return ClientNotificationCountModel.fromJson(json.decode(response.body));
  }

  Future<ShipMentNotificationCountModel> getShipmentNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentNotificationCount'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
    );

    print(response.body);
    return ShipMentNotificationCountModel.fromJson(json.decode(response.body));
  }

  Future<UpdateShipmentdoc> updateDoc(udpateData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');

    final client = http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateDocs'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: udpateData,
    );

    return UpdateShipmentdoc.fromJson(json.decode(response.body));
  }

  Future<UpdateShipmentdoc> updateDriveDoc(udpateData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');

    final client = http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateDrivingLicence'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: udpateData,
    );

    return UpdateShipmentdoc.fromJson(json.decode(response.body));
  }

  Future<UpdateShipmentdoc> updateTaxDoc(udpateData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');

    final client = http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'updateTaxDocs'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: udpateData,
    );

    return UpdateShipmentdoc.fromJson(json.decode(response.body));
  }

  Future<GetAdvertismentModel> getAdvertismentAPI() async {
    final client = http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'viewAdvertisment'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print("response.body-=-= ${response.body}");

    return GetAdvertismentModel.fromJson(json.decode(response.body));
  }

  //=======sub panel notifictaion count======
  Future<ShipMentNotificationCountModel> getShipmentSubPanelNotificationCount(
      token) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    // print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'shipmentNotificationCount'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": token
      },
    );

    print(response.body);
    return ShipMentNotificationCountModel.fromJson(json.decode(response.body));
  }

  Future<ShipMentNotificationCountModel> getClientSubPanelNotificationCount(
      token) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    // print("Token $shipmentauthToken");

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'clientNotificationCount'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": token
      },
    );

    print(response.body);
    return ShipMentNotificationCountModel.fromJson(json.decode(response.body));
  }

  Future<PreviousBookingShipmentModel> previousBookingshow(Data) async {
    print("show cling prvious Booking $Data");
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'previousBooking'),
      body: Data,
    );
    print(response.body);

    return PreviousBookingShipmentModel.fromJson(json.decode(response.body));
  }

  Future<ResceptionistDahboardStatsModel>
      getReceptionistdashboardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReceptionistToken = prefs.getString('receptionist_token');
    print("Receptionist Token-- $ReceptionistToken");
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'receptionistStats'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": ReceptionistToken
      },
    );

    print("hfjkhjfdjkhfjkd" + response.body);
    return ResceptionistDahboardStatsModel.fromJson(json.decode(response.body));
  }

  Future<ReceptionistSearchModel> searchReceptionistStatus(searchData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReceptionistToken = prefs.getString('receptionist_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'receptionistSearch'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": ReceptionistToken
      },
      body: searchData,
    );
    print(response.body);

    return ReceptionistSearchModel.fromJson(json.decode(response.body));
  }

  Future<AcceptProposalStatusModel> acceptProposalStatus(data1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print("data  $data1");
    print("-=-authToken $authToken");
    final client = http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'acceptProposal'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "token": authToken
      },
      body: data1,
    );
    print("response.body--- ${response.body}");

    return AcceptProposalStatusModel.fromJson(json.decode(response.body));
  }

  //======broadcast send and get
  Future<SendBroadcastMessageModel> sendBroadcastMSG(data) async {
    final client = new http.Client();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    final response = await client.post(
      Uri.parse(baseUrl + 'broadcast'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: data,
    );

    print("send broadcast response" + response.body);
    return SendBroadcastMessageModel.fromJson(json.decode(response.body));
  }

  //=======get messages
  Future<GetBroadcastMessageModel> getAllBroadcastMSG(data, token) async {
    final client = new http.Client();

    final response = await client.post(
      Uri.parse(baseUrl + 'getClientBroadcast'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": token
      },
      body: data,
    );

    print("getAllBroadcastMSG response" + response.body);
    return GetBroadcastMessageModel.fromJson(json.decode(response.body));
  }

  Future<AddItemTypeModel> editDeleteItem(itemType) async {
    // print("Login $pickupdata");
    final prefs = await SharedPreferences.getInstance();
    //
    if (prefs.getString('auth_token') != null) {
      shipmentauthToken = prefs.getString('auth_token');
    } else {
      shipmentauthToken = prefs.getString('Shipemnt_auth_token');
    }

    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'editItems'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": shipmentauthToken
      },
      body: itemType,
    );
    print(response.body);

    return AddItemTypeModel.fromJson(json.decode(response.body));
  }

//=========edit delete item==========

  //=========accept/reject pickup booking==========
  Future<AddItemTypeModel> pickupAgentAcceptReject(itemType) async {
    // print("Login $pickupdata");
    final prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'pickupAccept'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
      body: itemType,
    );
    print(response.body);

    return AddItemTypeModel.fromJson(json.decode(response.body));
  }

  Future<AddItemTypeModel> pickupAgentAcceptRejectMArket(itemType) async {
    // print("Login $pickupdata");
    final prefs = await SharedPreferences.getInstance();
    pickAgentToken = prefs.getString('Pickup_Agent_token');
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(baseUrl + 'pickupAcceptMarket'),
      headers: {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        "token": pickAgentToken
      },
      body: itemType,
    );
    print(response.body);

    return AddItemTypeModel.fromJson(json.decode(response.body));
  }

//=========accept/reject pickup booking==========
  Future<GetBroadcastMessageModel> getAllUserBroadcastMSG(data) async {
    final client = new http.Client();

    final response = await client.post(
      Uri.parse(baseUrl + 'getClientBroadcast'),
      // headers: {
      //   // 'Content-type': 'application/json',
      //   'Accept': 'application/json',
      // },
      body: data,
    );

    print("getAllBroadcastMSG response" + response.body);
    return GetBroadcastMessageModel.fromJson(json.decode(response.body));
  }

  Future<SubscriptionListModel> getSubscriptionList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final client = new http.Client();
    final response = await client.get(
      Uri.parse(baseUrl + 'subscriptionPlanList'),
      // headers: {
      //   'Content-type': 'application/json',
      //   'Accept': 'application/json',
      //   "token": shipmentauthToken
      // },
    );

    print("hfjkhjfdjkhfjkd" + response.body);
    return SubscriptionListModel.fromJson(json.decode(response.body));
  }
}
