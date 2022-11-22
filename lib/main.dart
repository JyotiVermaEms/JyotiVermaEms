import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shipment/component/Accountant/Dashboad/Dashboard.dart';
import 'package:shipment/component/Arrival%20Manager/ArrivalChar.dart';
import 'package:shipment/component/Arrival%20Manager/Dashboard.dart';
import 'package:shipment/component/Arrival%20Manager/Order/OrderManagement.dart';
import 'package:shipment/component/Arrival%20Manager/OrderHistory/orderhistory.dart';
import 'package:shipment/component/Arrival%20Manager/Profile.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Dashboard.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Order.dart';
import 'package:shipment/component/Departure%20Manager/Res_orderhistory.dart';
import 'package:shipment/component/Departure%20Manager/Settings.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/component/Pickup%20Agent/Order/inprogressorderList.dart';
import 'package:shipment/component/Pickup%20Agent/PickupAgentSettings.dart';
import 'package:shipment/component/Pickup%20Agent/Profile/Profile.dart';
import 'package:shipment/component/Pickup%20Agent/Res_pickupAgentOrderhistory.dart';
import 'package:shipment/component/Pickup%20Agent/pickup_message.dart';
// import 'package:shipment/component/Departure%20Manager/Dashboard/Dashboard.dart';
import 'package:shipment/component/Res_Client/Booking_Dashboard.dart';
import 'package:shipment/component/Res_Client/Chat_Screen.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/ResMarketbookingshow.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/Res_Market_Place.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/notificationdashboard.dart';
import 'package:shipment/component/Res_Client/ResMarketPlaceBooking.dart';
import 'package:shipment/component/Res_Client/Res_Client_Profile.dart';
import 'package:shipment/component/Res_Client/Res_Setting.dart';
import 'package:shipment/component/Res_Client/Res_Transaction.dart';
import 'package:shipment/component/Res_Client/Res_subusers.dart';
import 'package:shipment/component/Res_Client/res_ClientOrderHistory.dart';
import 'package:shipment/component/Res_Receptionist/Res_Booking.dart';
import 'package:shipment/component/Res_Receptionist/Res_Profile.dart';
import 'package:shipment/component/Res_Receptionist/Res_Setting_Rece.dart';
import 'package:shipment/component/Res_Receptionist/Res_dashboard.dart';
import 'package:shipment/component/Res_Receptionist/Res_orderhistory.dart';
// import 'package:shipment/component/Res_Receptionist/Res_Setting_Rece.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ResMarketPlace/Res_marketplace_Shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ResSchedulShipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ResShipmentadd_Company.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Notification.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Profile.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Settings.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_shipment_subusers.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/Res_Order.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/Res_OrderRecieved.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/Res_orderHistory.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Accountant/Login/LoginScreend.dart';
import 'package:shipment/pages/Arrival%20Manager/Login/LoginScreen.dart';
import 'package:shipment/pages/Arrival%20Manager/Notification/arrivalNotification.dart';

import 'package:shipment/pages/Chhose%20Screen/ClientScreen.dart';
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/SignupScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/Socail_Login_Mobile.dart';
import 'package:shipment/pages/Client/subscriptionScreen.dart';
import 'package:shipment/pages/Departure%20Manager/Login/LoginScreen.dart';
import 'package:shipment/pages/Departure%20Manager/Notification/departureNotification.dart';
import 'package:shipment/pages/Pickup%20Agent/LoginScreen.dart';
import 'package:shipment/pages/Pickup%20Agent/Notification/notification.dart';
import 'package:shipment/pages/Receptionist/Login/LoginReception.dart';
import 'package:shipment/pages/Receptionist/Notification/notification.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/LoginScreenShipment.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/SignupShipmentfirst.dart';
import 'package:shipment/pages/Shipment/subscritionscreen2.dart';
import 'package:shipment/pages/Splash.dart';

import 'component/Arrival Manager/Settings/Settings.dart';
import 'component/Departure Manager/Profile.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBLD6cGYyPsFc32eYDByJ9eLCE53Ntcsnc", // Your apiKey
      appId: "1:1050628517372:web:1c7d79559e1e23149dd679", // Your appId
      messagingSenderId: "1050628517372", // Your messagingSenderId
      projectId: "shipment-f4fd0", // Your projectId
    ),
  );

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('es', 'US')
        ],
        // comment

        path:
            'assets/translation', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: '/',
        routes: routes,
        scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}));
  }
}

// var data = {};

var routes = <String, WidgetBuilder>{
  Routes.SPLASHROUTE: (BuildContext context) => new SplashScreen(),
  Routes.CLIENTLOGINROUTE: (BuildContext context) => new LoginScreenClient(),
  Routes.CLIENTPROFILEROUTE: (BuildContext context) => new ResClientProfile(),
  Routes.CLIENTSIGNUPROUTE: (BuildContext context) => new SignupScreenClient(),
  Routes.WELCOMEROUTE: (BuildContext context) => new ClientScreen(),
  Routes.CLIENTDASHBOARDROUTE: (BuildContext context) => new DashboardHome(),
  Routes.CLIENTMARKETPLACEROUTE: (BuildContext context) => new ResMarketPlace(),
  Routes.CLIENTBOOKINGROUTE: (BuildContext context) => new BookingDashboard(),
  Routes.CLIENTORDERHISTORYROUTE: (BuildContext context) =>
      new ClientReorderhitory(),
  Routes.CLIENTTRANSACTIONROUTE: (BuildContext context) => new ResTransaction(),
  Routes.CLIENTNOTIFICATIONROUTE: (BuildContext context) =>
      new NotificationScreen(),
  Routes.CLIENTMESSAGEROUTE: (BuildContext context) => new ChatScreen(''),
  Routes.CLIENTSUBUSERSROUTE: (BuildContext context) => ClinetSubUsers(),
  Routes.CLIENTSETTINGROUTE: (BuildContext context) => new ResSettings(),
  Routes.CLIENTMARKETPLACEBOOKINGROUTE: (BuildContext context) =>
      new ResMarketPlaceBooking(),
  Routes.CLIENTMARKETPLACEBOOKINSHOWGROUTE: (BuildContext context) =>
      new MarketBooking(),
  Routes.SHIPMENTLOGINROUTE: (BuildContext context) =>
      new LoginScreenShipment(),
  Routes.SHIPMENTSIGNUPROUTE: (BuildContext context) => new SignupScreenfirst(),
  Routes.SHIPMENTDASHBOARD: (BuildContext context) =>
      new ResDashboardshipment(),
  Routes.SHIPMENTPROFILE: (BuildContext context) => new ResShipmentProfile(),
  Routes.SHIPMENTORDERROUTE: (BuildContext context) => new ResOrders(),
  Routes.SHIPMENTBOOKINGREQUESTROUTE: (BuildContext context) =>
      new ResOrderRecieved(),
  Routes.SHIPMENTORDERHISTORYROUTE: (BuildContext context) =>
      new Resorderhistory(),
  Routes.SHIPMENTMARKETPLACEROUTE: (BuildContext context) =>
      new ResMarketPlaceShipment(),
  Routes.SHIPMENTSCHEDULESHIPMENTROUTE: (BuildContext context) =>
      new ResScheduleShipment(),
  Routes.SHIPMENTNOTIFICATIONROUTE: (BuildContext context) =>
      new ShipmentNotificationScreen(),
  Routes.SHIPMENTUPDATEPROFILE: (BuildContext context) =>
      new ResShipmentAdd_Company(),
  Routes.SHIPMENTSETTINGROUTE: (BuildContext context) =>
      new ResShipmentSettings(),
  Routes.SHIPMENTSUBUSERSROUTE: (BuildContext context) => Shipment_subUser(),
  Routes.ACCOUNTANTLOGINROUTE: (BuildContext context) =>
      new LoginAccountant(roles: "2"),
  Routes.ACCOUNTANTDASHBOARD: (BuildContext context) =>
      new AAccountantDashboard(),
  Routes.DEPATURELOGINROUTE: (BuildContext context) =>
      new DepLoginScreen(roles: "3"),
  Routes.DEPATUREPROFILE: (BuildContext context) => new Profile(),
  Routes.DEPATUREDASHBOARD: (BuildContext context) => new Dashboard(),
  Routes.DEPATUREORDER: (BuildContext context) => new Orders(),
  Routes.DEPATUREORDERHISTORY: (BuildContext context) => new DepOrdersHistory(),
  Routes.DEPATURENOTIFICATION: (BuildContext context) =>
      new DepartureNotificationScreen(),
  Routes.DEPATURESETTING: (BuildContext context) => new DepSettings(),
  Routes.ARRIVALLOGINROUTE: (BuildContext context) =>
      new LoginScreenArrival(roles: "4"),
  Routes.ARRIVALPROFILEROUTE: (BuildContext context) => new ArrivalProfile(),
  Routes.ARRIVALDASHBOARD: (BuildContext context) => new PreArrivalDashboard(),
  Routes.ARRIVALORDER: (BuildContext context) => new OrderManagement(),
  Routes.ARRIVALORDERHISTORY: (BuildContext context) => new ResOrderHistory(),
  Routes.ARRIVALCHAT: (BuildContext context) => Arrivalchat(),
  Routes.ARRIVALNOTIFICATION: (BuildContext context) =>
      ArrivalNotificationScreen(),
  Routes.ARRIVALSETTING: (BuildContext context) => Settings(),
  Routes.PICKUPAGENTLOGINROUTE: (BuildContext context) =>
      new LoginScreen(roles: "5"),
  Routes.PICKUPAGENTPROFILE: (BuildContext context) => new PickupAgentProfile(),
  Routes.PICKUPAGENTDASHBOARD: (BuildContext context) =>
      new PrePickupAgentDashboard(),
  Routes.PICKUPAGENTORDER: (BuildContext context) => new inprogressOrderList(),
  Routes.PICKUPAGENTORDERHISTORY: (BuildContext context) =>
      new PickupagentOrderHistory(),
  Routes.PICKUPAGENTMESSAGE: (BuildContext context) => new Pickup_messages(),
  Routes.PICKUPAGENTNOTIFICATION: (BuildContext context) =>
      new PickupNotificationScreen(),
  Routes.PICKUPAGENTSETTING: (BuildContext context) =>
      new PickupagentSettings(),
  Routes.RECEPTIONISTLOGINROUTE: (BuildContext context) => new LoginReception(),
  Routes.RECEPTIONISTDASHBOARD: (BuildContext context) =>
      new PreReceptionistDashboard(),
  Routes.RECEPTIONISTPROFILE: (BuildContext context) => new ResProfile(),
  Routes.RECEPTIONISTBOOKING: (BuildContext context) => new ResBookings(),
  Routes.RECEPTIONISTORDERHISTORY: (BuildContext context) =>
      new ResptionistOrderHistory(),
  Routes.RECEPTIONISTNOTIFICATION: (BuildContext context) =>
      new ReceptionistNotificationScreen(),
  Routes.RECEPTIONISTSETTING: (BuildContext context) =>
      new ReceptionistSettings(),
  Routes.SUBSCRTIONSCREEN: (BuildContext context) => new SubscriptionScreen(),
  Routes.SUBSCRTIONSCREEN2: (BuildContext context) => new SubscriptionScreen2(),
};
