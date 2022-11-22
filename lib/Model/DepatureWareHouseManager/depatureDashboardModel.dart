// class DepatureDashboardModel {
//   DepatureDashboardModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//   late final bool status;
//   late final String message;
//   late final List<DashboardData> data;

//   DepatureDashboardModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data =
//         List.from(json['data']).map((e) => DashboardData.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['message'] = message;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class DashboardData {
//   DashboardData({
//     required this.id,
//     required this.title,
//     required this.shipmentType,
//     required this.from,
//     required this.to,
//     required this.departureDate,
//     required this.arrivalDate,
//     required this.departureWarehouse,
//     required this.destinationWarehouse,
//     required this.itemType,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.sid,
//     required this.status,
//     required this.permissionStatus,
//     required this.bookingId,
//     required this.available,
//     required this.totalContainer,
//     required this.availableContainer,
//     required this.bookings,
//   });
//   late final int id;
//   late final String title;
//   late final String shipmentType;
//   late final String from;
//   late final String to;
//   late final String departureDate;
//   late final String arrivalDate;
//   late final String departureWarehouse;
//   late final String destinationWarehouse;
//   late final List<ItemType> itemType;
//   late final String createdAt;
//   late final String updatedAt;
//   late final int sid;
//   late final String status;
//   late final String permissionStatus;
//   late final int bookingId;
//   late final List<Available> available;
//   late final int totalContainer;
//   late final int availableContainer;
//   late final List<Bookings> bookings;

//   DashboardData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     shipmentType = json['shipment_type'];
//     from = json['from'];
//     to = json['to'];
//     departureDate = json['departure_date'];
//     arrivalDate = json['arrival_date'];
//     departureWarehouse = json['departure_warehouse'];
//     destinationWarehouse = json['destination_warehouse'];
//     itemType =
//         List.from(json['item_type']).map((e) => ItemType.fromJson(e)).toList();
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     sid = json['sid'];
//     status = json['status'];
//     permissionStatus = json['permission_status'];
//     bookingId = json['booking_id'];
//     available =
//         List.from(json['available']).map((e) => Available.fromJson(e)).toList();
//     totalContainer = json['total_container'];
//     availableContainer = json['available_container'];
//     bookings =
//         List.from(json['bookings']).map((e) => Bookings.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['title'] = title;
//     _data['shipment_type'] = shipmentType;
//     _data['from'] = from;
//     _data['to'] = to;
//     _data['departure_date'] = departureDate;
//     _data['arrival_date'] = arrivalDate;
//     _data['departure_warehouse'] = departureWarehouse;
//     _data['destination_warehouse'] = destinationWarehouse;
//     _data['item_type'] = itemType.map((e) => e.toJson()).toList();
//     _data['created_at'] = createdAt;
//     _data['updated_at'] = updatedAt;
//     _data['sid'] = sid;
//     _data['status'] = status;
//     _data['permission_status'] = permissionStatus;
//     _data['booking_id'] = bookingId;
//     _data['available'] = available.map((e) => e.toJson()).toList();
//     _data['total_container'] = totalContainer;
//     _data['available_container'] = availableContainer;
//     _data['bookings'] = bookings.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class ItemType {
//   ItemType({
//     required this.itemType,
//     required this.categoryName,
//     this.icon,
//     required this.shippingFee,
//     required this.pickupFee,
//     required this.quantity,
//   });
//   late final String itemType;
//   late final String categoryName;
//   late final Null icon;
//   late final int shippingFee;
//   late final int pickupFee;
//   late final int quantity;

//   ItemType.fromJson(Map<String, dynamic> json) {
//     itemType = json['item_type'];
//     categoryName = json['category_name'];
//     icon = null;
//     shippingFee = json['shipping_fee'];
//     pickupFee = json['pickup_fee'];
//     quantity = json['quantity'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['item_type'] = itemType;
//     _data['category_name'] = categoryName;
//     _data['icon'] = icon;
//     _data['shipping_fee'] = shippingFee;
//     _data['pickup_fee'] = pickupFee;
//     _data['quantity'] = quantity;
//     return _data;
//   }
// }

// class Available {
//   Available({
//     required this.category,
//     required this.available,
//     this.icon,
//   });
//   late final String category;
//   late final String available;
//   late final Null icon;

//   Available.fromJson(Map<String, dynamic> json) {
//     category = json['category'];
//     available = json['available'];
//     icon = null;
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['category'] = category;
//     _data['available'] = available;
//     _data['icon'] = icon;
//     return _data;
//   }
// }

// class Bookings {
//   Bookings({
//     required this.id,
//     required this.title,
//     required this.uid,
//     required this.bookingDate,
//     required this.arrivalDate,
//     required this.bookingType,
//     required this.from,
//     required this.to,
//     required this.shipmentCompany,
//     this.bookingItem,
//     required this.status,
//     required this.accepted,
//     required this.rejected,
//     required this.pickupReview,
//     required this.scheduleId,
//     required this.pickupagentId,
//     required this.pickupItemimage,
//     required this.pickupItemimage1,
//     required this.pickupComment,
//     required this.pickupComment1,
//     required this.departureImage,
//     required this.departureComment,
//     this.arrivalImage,
//     required this.arrivalComment,
//     this.receptionistImage,
//     required this.receptionistInfo,
//     required this.receptionistId,
//     required this.transactionId,
//     required this.totalAmount,
//     required this.cardType,
//     this.reason,
//     this.pickupReason,
//     required this.createdAt,
//     required this.updatedAt,
//     this.receptionistComment,
//     required this.booking,
//   });
//   late final int id;
//   late final String title;
//   late final int uid;
//   late final String bookingDate;
//   late final String arrivalDate;
//   late final String bookingType;
//   late final String from;
//   late final String to;
//   late final String shipmentCompany;
//   late final Null bookingItem;
//   late final String status;
//   late final int accepted;
//   late final int rejected;
//   late final List<PickupReview> pickupReview;
//   late final String scheduleId;
//   late final String? pickupagentId;
//   late final String? pickupItemimage;
//   late final String? pickupItemimage1;
//   late final String? pickupComment;
//   late final String? pickupComment1;
//   late final String? departureImage;
//   late final String departureComment;
//   late final List<dynamic>? arrivalImage;
//   late final String arrivalComment;
//   late final Null receptionistImage;
//   late final List<ReceptionistInfo> receptionistInfo;
//   late final int receptionistId;
//   late final String transactionId;
//   late final String totalAmount;
//   late final String cardType;
//   late final Null reason;
//   late final String? pickupReason;
//   late final String createdAt;
//   late final String updatedAt;
//   late final Null receptionistComment;
//   late final List<Booking> booking;

//   Bookings.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     uid = json['uid'];
//     bookingDate = json['booking_date'];
//     arrivalDate = json['arrival_date'];
//     bookingType = json['booking_type'];
//     from = json['from'];
//     to = json['to'];
//     shipmentCompany = json['shipment_company'];
//     bookingItem = null;
//     status = json['status'];
//     accepted = json['accepted'];
//     rejected = json['rejected'];
//     pickupReview = List.from(json['pickup_review'])
//         .map((e) => PickupReview.fromJson(e))
//         .toList();
//     scheduleId = json['schedule_id'];
//     pickupagentId = json['pickupagent_id'];
//     pickupItemimage =
//         json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
//     pickupItemimage1 = json['pickup_itemimage1'];
//     pickupComment = json['pickup_comment'];
//     pickupComment1 = json['pickup_comment1'];
//     departureImage = json['departure_image'];
//     departureComment = json['departure_comment'];
//     arrivalImage = null;
//     arrivalComment = json['arrival_comment'];
//     receptionistImage = null;
//     receptionistInfo = List.from(json['receptionist_info'])
//         .map((e) => ReceptionistInfo.fromJson(e))
//         .toList();
//     receptionistId = json['receptionist_id'];
//     transactionId = json['transaction_id'];
//     totalAmount = json['total_amount'];
//     cardType = json['card_type'];
//     reason = null;
//     pickupReason = null;
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     receptionistComment = null;
//     booking =
//         List.from(json['booking']).map((e) => Booking.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['title'] = title;
//     _data['uid'] = uid;
//     _data['booking_date'] = bookingDate;
//     _data['arrival_date'] = arrivalDate;
//     _data['booking_type'] = bookingType;
//     _data['from'] = from;
//     _data['to'] = to;
//     _data['shipment_company'] = shipmentCompany;
//     _data['booking_item'] = bookingItem;
//     _data['status'] = status;
//     _data['accepted'] = accepted;
//     _data['rejected'] = rejected;
//     _data['pickup_review'] = pickupReview.map((e) => e.toJson()).toList();
//     _data['schedule_id'] = scheduleId;
//     _data['pickupagent_id'] = pickupagentId;
//     _data['pickup_itemimage'] = pickupItemimage;
//     _data['pickup_itemimage1'] = pickupItemimage1;
//     _data['pickup_comment'] = pickupComment;
//     _data['pickup_comment1'] = pickupComment1;
//     _data['departure_image'] = departureImage;
//     _data['departure_comment'] = departureComment;
//     _data['arrival_image'] = arrivalImage;
//     _data['arrival_comment'] = arrivalComment;
//     _data['receptionist_image'] = receptionistImage;
//     _data['receptionist_info'] =
//         receptionistInfo.map((e) => e.toJson()).toList();
//     _data['receptionist_id'] = receptionistId;
//     _data['transaction_id'] = transactionId;
//     _data['total_amount'] = totalAmount;
//     _data['card_type'] = cardType;
//     _data['reason'] = reason;
//     _data['pickup_reason'] = pickupReason;
//     _data['created_at'] = createdAt;
//     _data['updated_at'] = updatedAt;
//     _data['receptionist_comment'] = receptionistComment;
//     _data['booking'] = booking.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class PickupReview {
//   PickupReview({
//     required this.pickupType,
//     required this.pickupLocation,
//     required this.pickupDate,
//     required this.pickupTime,
//     this.pickupDistance,
//     this.pickupEstimate,
//   });
//   late final String pickupType;
//   late final String pickupLocation;
//   late final String pickupDate;
//   late final String pickupTime;
//   late final String? pickupDistance;
//   late final String? pickupEstimate;

//   PickupReview.fromJson(Map<String, dynamic> json) {
//     pickupType = json['pickup_type'];
//     pickupLocation = json['pickup_location'];
//     pickupDate = json['pickup_date'];
//     pickupTime = json['pickup_time'];
//     pickupDistance = null;
//     pickupEstimate = null;
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['pickup_type'] = pickupType;
//     _data['pickup_location'] = pickupLocation;
//     _data['pickup_date'] = pickupDate;
//     _data['pickup_time'] = pickupTime;
//     _data['pickup_distance'] = pickupDistance;
//     _data['pickup_estimate'] = pickupEstimate;
//     return _data;
//   }
// }

// class ReceptionistInfo {
//   ReceptionistInfo({
//     required this.receptionistName,
//     required this.receptionistEmail,
//     required this.receptionistPhone,
//     this.receptionistAddress,
//     required this.receptionistCountry,
//   });
//   late final String receptionistName;
//   late final String receptionistEmail;
//   late final String receptionistPhone;
//   late final String? receptionistAddress;
//   late final String receptionistCountry;

//   ReceptionistInfo.fromJson(Map<String, dynamic> json) {
//     receptionistName = json['receptionist_name'];
//     receptionistEmail = json['receptionist_email'];
//     receptionistPhone = json['receptionist_phone'];
//     receptionistAddress = null;
//     receptionistCountry = json['receptionist_country'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['receptionist_name'] = receptionistName;
//     _data['receptionist_email'] = receptionistEmail;
//     _data['receptionist_phone'] = receptionistPhone;
//     _data['receptionist_address'] = receptionistAddress;
//     _data['receptionist_country'] = receptionistCountry;
//     return _data;
//   }
// }

// class Booking {
//   Booking({
//     required this.id,
//     required this.uid,
//     required this.category,
//     required this.itemName,
//     required this.itemImage,
//     required this.quantity,
//     required this.description,
//     required this.bookingId,
//     required this.scheduleId,
//   });
//   late final int id;
//   late final int uid;
//   late final String category;
//   late final String itemName;
//   late final List<String> itemImage;
//   late final int quantity;
//   late final String description;
//   late final int bookingId;
//   late final int scheduleId;

//   Booking.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     uid = json['uid'];
//     category = json['category'];
//     itemName = json['item_name'];
//     itemImage = List.castFrom<dynamic, String>(json['item_image']);
//     quantity = json['quantity'];
//     description = json['description'];
//     bookingId = json['booking_id'];
//     scheduleId = json['schedule_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['uid'] = uid;
//     _data['category'] = category;
//     _data['item_name'] = itemName;
//     _data['item_image'] = itemImage;
//     _data['quantity'] = quantity;
//     _data['description'] = description;
//     _data['booking_id'] = bookingId;
//     _data['schedule_id'] = scheduleId;
//     return _data;
//   }
// }
// class DepatureDashboardModel {
//   DepatureDashboardModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//   late final bool status;
//   late final String message;
//   late final List<DashboardData> data;

//   DepatureDashboardModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data =
//         List.from(json['data']).map((e) => DashboardData.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['message'] = message;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class DashboardData {
//   DashboardData({
//     required this.id,
//     required this.title,
//     required this.shipmentType,
//     required this.from,
//     required this.to,
//     required this.departureDate,
//     required this.arrivalDate,
//     required this.departureWarehouse,
//     required this.destinationWarehouse,
//     required this.itemType,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.sid,
//     required this.status,
//     required this.permissionStatus,
//     required this.bookingId,
//     required this.available,
//     required this.totalContainer,
//     required this.availableContainer,
//     required this.bookings,
//   });
//   late final int id;
//   late final String title;
//   late final String shipmentType;
//   late final String from;
//   late final String to;
//   late final String departureDate;
//   late final String arrivalDate;
//   late final String departureWarehouse;
//   late final String destinationWarehouse;
//   late final List<ItemType> itemType;
//   late final String createdAt;
//   late final String updatedAt;
//   late final int sid;
//   late final String status;
//   late final String permissionStatus;
//   late final int bookingId;
//   late final List<Available> available;
//   late final int totalContainer;
//   late final int availableContainer;
//   late final List<Bookings> bookings;

//   DashboardData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     shipmentType = json['shipment_type'];
//     from = json['from'];
//     to = json['to'];
//     departureDate = json['departure_date'];
//     arrivalDate = json['arrival_date'];
//     departureWarehouse = json['departure_warehouse'];
//     destinationWarehouse = json['destination_warehouse'];
//     itemType =
//         List.from(json['item_type']).map((e) => ItemType.fromJson(e)).toList();
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     sid = json['sid'];
//     status = json['status'] == null ? "" : json['status'];
//     permissionStatus = json['permission_status'];
//     bookingId = json['booking_id'];
//     available =
//         List.from(json['available']).map((e) => Available.fromJson(e)).toList();
//     totalContainer = json['total_container'];
//     availableContainer = json['available_container'];
//     bookings =
//         List.from(json['bookings']).map((e) => Bookings.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['title'] = title;
//     _data['shipment_type'] = shipmentType;
//     _data['from'] = from;
//     _data['to'] = to;
//     _data['departure_date'] = departureDate;
//     _data['arrival_date'] = arrivalDate;
//     _data['departure_warehouse'] = departureWarehouse;
//     _data['destination_warehouse'] = destinationWarehouse;
//     _data['item_type'] = itemType.map((e) => e.toJson()).toList();
//     _data['created_at'] = createdAt;
//     _data['updated_at'] = updatedAt;
//     _data['sid'] = sid;
//     _data['status'] = status;
//     _data['permission_status'] = permissionStatus;
//     _data['booking_id'] = bookingId;
//     _data['available'] = available.map((e) => e.toJson()).toList();
//     _data['total_container'] = totalContainer;
//     _data['available_container'] = availableContainer;
//     _data['bookings'] = bookings.map((e) => e.toJson()).toList();

//     return _data;
//   }
// }

// class ItemType {
//   ItemType({
//     required this.itemType,
//     required this.categoryName,
//     this.icon,
//     required this.shippingFee,
//     required this.pickupFee,
//     required this.quantity,
//   });
//   late final String itemType;
//   late final String categoryName;
//   late final Null icon;
//   late final int shippingFee;
//   late final int pickupFee;
//   late final int quantity;

//   ItemType.fromJson(Map<String, dynamic> json) {
//     itemType = json['item_type'] == null ? "" : json['item_type'];
//     categoryName = json['category_name'];
//     icon = null;
//     shippingFee = json['shipping_fee'];
//     pickupFee = json['pickup_fee'];
//     quantity = json['quantity'] == null ? 0 : json['quantity'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['item_type'] = itemType;
//     _data['category_name'] = categoryName;
//     _data['icon'] = icon;
//     _data['shipping_fee'] = shippingFee;
//     _data['pickup_fee'] = pickupFee;
//     _data['quantity'] = quantity;
//     return _data;
//   }
// }

// class Available {
//   Available({
//     required this.category,
//     required this.available,
//     this.icon,
//   });
//   late final String category;
//   late final String available;
//   late final Null icon;

//   Available.fromJson(Map<String, dynamic> json) {
//     category = json['category'];
//     available = json['available'] == null ? "" : json['available'];
//     icon = null;
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['category'] = category;
//     _data['available'] = available;
//     _data['icon'] = icon;
//     return _data;
//   }
// }

// class Bookings {
//   Bookings({
//     required this.id,
//     required this.title,
//     required this.uid,
//     required this.bookingDate,
//     required this.arrivalDate,
//     required this.bookingType,
//     required this.from,
//     required this.to,
//     required this.shipmentCompany,
//     this.bookingItem,
//     required this.status,
//     required this.accepted,
//     required this.rejected,
//     required this.pickupReview,
//     required this.scheduleId,
//     required this.pickupagentId,
//     required this.pickupItemimage,
//     required this.receptionistInfo,
//     required this.transactionId,
//     required this.totalAmount,
//     required this.cardType,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.booking,
//     required this.departureImage,
//     required this.departureComment,
//     required this.pickupItemimage1,
//     required this.pickupComment,
//     required this.pickupComment1,
//   });
//   late final int id;
//   late final String title;
//   late final int uid;
//   late final String bookingDate;
//   late final String arrivalDate;
//   late final String bookingType;
//   late final String from;
//   late final String to;
//   late final String shipmentCompany;
//   late final Null bookingItem;
//   late final String status;
//   late final int accepted;
//   late final int rejected;
//   late final List<PickupReview> pickupReview;
//   late final String scheduleId;
//   late final String? pickupagentId;
//   late final String? pickupItemimage;
//   late final List<ReceptionistInfo> receptionistInfo;
//   late final String transactionId;
//   late final String totalAmount;
//   late final String cardType;
//   late final String createdAt;
//   late final String updatedAt;
//   late final List<Booking> booking;
//   late final String departureImage;
//   late final String departureComment;

//   late final String? pickupItemimage1;

//   late final String? pickupComment;
//   late final String? pickupComment1;

//   Bookings.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     uid = json['uid'];
//     bookingDate = json['booking_date'];
//     arrivalDate = json['arrival_date'];
//     bookingType = json['booking_type'];
//     from = json['from'];
//     to = json['to'];
//     shipmentCompany = json['shipment_company'];
//     bookingItem = null;
//     status = json['status'] == null ? "" : json['status'];
//     accepted = json['accepted'];
//     rejected = json['rejected'];
//     pickupReview = json['pickup_review'] != null
//         ? List.from(json['pickup_review'])
//             .map((e) => PickupReview.fromJson(e))
//             .toList()
//         : [];
//     scheduleId = json['schedule_id'];
//     pickupagentId =
//         json['pickupagent_id'] == null ? "" : json['pickupagent_id'];

//     receptionistInfo = List.from(json['receptionist_info'])
//         .map((e) => ReceptionistInfo.fromJson(e))
//         .toList();
//     transactionId =
//         json['transaction_id'] == "null" ? "" : json['transaction_id'];
//     totalAmount = json['total_amount'] == "null" ? "" : json['total_amount'];
//     cardType = json['card_type'] == "null" ? "" : json['card_type'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     booking =
//         List.from(json['booking']).map((e) => Booking.fromJson(e)).toList();
//     departureImage =
//         json['departure_image'] == null ? "" : json['departure_image'];
//     departureComment =
//         json['departure_comment'] == null ? "" : json['departure_comment'];
//     pickupItemimage =
//         json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
//     pickupItemimage1 =
//         json['pickup_itemimage1'] == null ? "" : json['pickup_itemimage1'];
//     pickupComment =
//         json['pickup_comment'] == null ? "" : json['pickup_comment'];
//     pickupComment1 =
//         json['pickup_comment1'] == null ? "" : json['pickup_comment1'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['title'] = title;
//     _data['uid'] = uid;
//     _data['booking_date'] = bookingDate;
//     _data['arrival_date'] = arrivalDate;
//     _data['booking_type'] = bookingType;
//     _data['from'] = from;
//     _data['to'] = to;
//     _data['shipment_company'] = shipmentCompany;
//     _data['booking_item'] = bookingItem;
//     _data['status'] = status;
//     _data['accepted'] = accepted;
//     _data['rejected'] = rejected;
//     _data['pickup_review'] = pickupReview.map((e) => e.toJson()).toList();
//     _data['schedule_id'] = scheduleId;
//     _data['pickupagent_id'] = pickupagentId;

//     _data['receptionist_info'] =
//         receptionistInfo.map((e) => e.toJson()).toList();
//     _data['transaction_id'] = transactionId;
//     _data['total_amount'] = totalAmount;
//     _data['card_type'] = cardType;
//     _data['created_at'] = createdAt;
//     _data['updated_at'] = updatedAt;
//     _data['booking'] = booking.map((e) => e.toJson()).toList();
//     _data['departure_image'] = departureImage;
//     _data['departure_comment'] = departureComment;
//     _data['pickupagent_id'] = pickupagentId;
//     _data['pickup_itemimage'] = pickupItemimage;
//     _data['pickup_itemimage1'] = pickupItemimage1;
//     _data['pickup_comment'] = pickupComment;
//     _data['pickup_comment1'] = pickupComment1;
//     _data['departure_image'] = departureImage;
//     _data['departure_comment'] = departureComment;
//     return _data;
//   }
// }

// class PickupReview {
//   PickupReview({
//     required this.pickupType,
//     required this.pickupLocation,
//     required this.pickupDate,
//     required this.pickupTime,
//     required this.pickupDistance,
//     required this.pickupEstimate,
//   });
//   late final String pickupType;
//   late final String pickupLocation;
//   late final String pickupDate;
//   late final String pickupTime;
//   late final String pickupDistance;
//   late final String pickupEstimate;

//   PickupReview.fromJson(Map<String, dynamic> json) {
//     pickupType = json['pickup_type'];
//     pickupLocation =
//         json['pickup_location'] == "null" ? " " : json['pickup_location'];
//     pickupDate = json['pickup_date'];
//     pickupTime = json['pickup_time'];
//     pickupDistance =
//         json['pickup_distance'] == null ? "" : json['pickup_distance'];
//     pickupEstimate =
//         json['pickup_estimate'] == null ? "" : json['pickup_estimate'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['pickup_type'] = pickupType;
//     _data['pickup_location'] = pickupLocation;
//     _data['pickup_date'] = pickupDate;
//     _data['pickup_time'] = pickupTime;
//     _data['pickup_distance'] = pickupDistance;
//     _data['pickup_estimate'] = pickupEstimate;
//     return _data;
//   }
// }

// class ReceptionistInfo {
//   ReceptionistInfo({
//     required this.receptionistName,
//     required this.receptionistEmail,
//     required this.receptionistPhone,
//     required this.receptionistAddress,
//     required this.receptionistCountry,
//   });
//   late final String receptionistName;
//   late final String receptionistEmail;
//   late final String receptionistPhone;
//   late final String receptionistAddress;
//   late final String receptionistCountry;

//   ReceptionistInfo.fromJson(Map<String, dynamic> json) {
//     receptionistName = json['receptionist_name'];
//     receptionistEmail = json['receptionist_email'];
//     receptionistPhone = json['receptionist_phone'];
//     receptionistAddress = json['receptionist_address'] == null
//         ? ""
//         : json['receptionist_address'];
//     receptionistCountry = json['receptionist_country'] == null
//         ? ""
//         : json['receptionist_country'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['receptionist_name'] = receptionistName;
//     _data['receptionist_email'] = receptionistEmail;
//     _data['receptionist_phone'] = receptionistPhone;
//     _data['receptionist_address'] = receptionistAddress;
//     return _data;
//   }
// }

// class Booking {
//   Booking({
//     required this.id,
//     required this.uid,
//     required this.category,
//     required this.itemName,
//     required this.itemImage,
//     required this.quantity,
//     required this.description,
//     required this.bookingId,
//     required this.scheduleId,
//   });
//   late final int id;
//   late final int uid;
//   late final String category;
//   late final String itemName;
//   late final List<String> itemImage;
//   late final int quantity;
//   late final String description;
//   late final int bookingId;
//   late final int scheduleId;

//   Booking.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     uid = json['uid'];
//     category = json['category'];
//     itemName = json['item_name'] == null ? "" : json['item_name'];
//     itemImage = List.castFrom<dynamic, String>(json['item_image']);
//     quantity = json['quantity'];
//     description = json['description'];
//     bookingId = json['booking_id'];
//     scheduleId = json['schedule_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['uid'] = uid;
//     _data['category'] = category;
//     _data['item_name'] = itemName;
//     _data['item_image'] = itemImage;
//     _data['quantity'] = quantity;
//     _data['description'] = description;
//     _data['booking_id'] = bookingId;
//     _data['schedule_id'] = scheduleId;
//     return _data;
//   }
// }
class DepatureDashboardModel {
  DepatureDashboardModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<DashboardData> data;

  DepatureDashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        List.from(json['data']).map((e) => DashboardData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class DashboardData {
  DashboardData({
    required this.id,
    required this.title,
    required this.shipmentType,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.arrivalDate,
    required this.departureWarehouse,
    required this.destinationWarehouse,
    required this.itemType,
    required this.createdAt,
    required this.updatedAt,
    required this.sid,
    required this.status,
    required this.permissionStatus,
    required this.bookingId,
    required this.available,
    required this.totalContainer,
    required this.availableContainer,
    required this.bookings,
  });
  late final int id;
  late final String title;
  late final String shipmentType;
  late final String from;
  late final String to;
  late final String departureDate;
  late final String arrivalDate;
  late final String departureWarehouse;
  late final String destinationWarehouse;
  late final List<ItemType> itemType;
  late final String createdAt;
  late final String updatedAt;
  late final int sid;
  late final String status;
  late final String permissionStatus;
  late final int bookingId;
  late final List<Available> available;
  late final int totalContainer;
  late final int availableContainer;
  late final List<Bookings> bookings;

  DashboardData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shipmentType = json['shipment_type'];
    from = json['from'];
    to = json['to'];
    departureDate = json['departure_date'];
    arrivalDate = json['arrival_date'];
    departureWarehouse = json['departure_warehouse'];
    destinationWarehouse = json['destination_warehouse'];
    itemType =
        List.from(json['item_type']).map((e) => ItemType.fromJson(e)).toList();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sid = json['sid'];
    status = json['status'];
    permissionStatus = json['permission_status'];
    bookingId = json['booking_id'];
    available =
        List.from(json['available']).map((e) => Available.fromJson(e)).toList();
    totalContainer = json['total_container'];
    availableContainer = json['available_container'];
    bookings =
        List.from(json['bookings']).map((e) => Bookings.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['shipment_type'] = shipmentType;
    _data['from'] = from;
    _data['to'] = to;
    _data['departure_date'] = departureDate;
    _data['arrival_date'] = arrivalDate;
    _data['departure_warehouse'] = departureWarehouse;
    _data['destination_warehouse'] = destinationWarehouse;
    _data['item_type'] = itemType.map((e) => e.toJson()).toList();
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['sid'] = sid;
    _data['status'] = status;
    _data['permission_status'] = permissionStatus;
    _data['booking_id'] = bookingId;
    _data['available'] = available.map((e) => e.toJson()).toList();
    _data['total_container'] = totalContainer;
    _data['available_container'] = availableContainer;
    _data['bookings'] = bookings.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ItemType {
  ItemType({
    required this.itemType,
    required this.categoryName,
    this.icon,
    required this.shippingFee,
    required this.pickupFee,
    this.quantity,
  });
  late final String itemType;
  late final String categoryName;
  late final Null icon;
  late final int shippingFee;
  late final int pickupFee;
  late final int? quantity;

  ItemType.fromJson(Map<String, dynamic> json) {
    itemType = json['item_type'];
    categoryName = json['category_name'];
    icon = null;
    shippingFee = json['shipping_fee'];
    pickupFee = json['pickup_fee'];
    quantity = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['item_type'] = itemType;
    _data['category_name'] = categoryName;
    _data['icon'] = icon;
    _data['shipping_fee'] = shippingFee;
    _data['pickup_fee'] = pickupFee;
    _data['quantity'] = quantity;
    return _data;
  }
}

class Available {
  Available({
    required this.category,
    this.available,
    this.icon,
  });
  late final String category;
  late final String? available;
  late final Null icon;

  Available.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    available = null;
    icon = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category;
    _data['available'] = available;
    _data['icon'] = icon;
    return _data;
  }
}

class Bookings {
  Bookings({
    required this.id,
    required this.title,
    required this.uid,
    required this.bookingDate,
    required this.arrivalDate,
    required this.bookingType,
    required this.from,
    required this.to,
    required this.shipmentCompany,
    required this.bookingItem,
    required this.status,
    required this.accepted,
    required this.rejected,
    required this.pickupReview,
    required this.scheduleId,
    this.pickupagentId,
    required this.pickupAccept,
    this.pickupItemimage,
    this.pickupItemimage1,
    this.pickupComment,
    this.pickupComment1,
    this.departureImage,
    required this.departureComment,
    this.arrivalImage,
    required this.arrivalComment,
    required this.receptionistImage,
    required this.receptionistInfo,
    required this.receptionistId,
    required this.transactionId,
    required this.totalAmount,
    required this.cardType,
    required this.reason,
    required this.pickupReason,
    required this.createdAt,
    required this.updatedAt,
    required this.expiredAt,
    required this.receptionistComment,
    required this.booking,
  });
  late final int id;
  late final String title;
  late final int uid;
  late final String bookingDate;
  late final String arrivalDate;
  late final String bookingType;
  late final String from;
  late final String to;
  late final String shipmentCompany;
  late final String bookingItem;
  late final String status;
  late final int accepted;
  late final int rejected;
  late final List<PickupReview> pickupReview;
  late final String scheduleId;
  late final String? pickupagentId;
  late final int pickupAccept;
  late final String? pickupItemimage;
  late final String? pickupItemimage1;
  late final String? pickupComment;
  late final String? pickupComment1;
  late final String? departureImage;
  late final String departureComment;
  late final String? arrivalImage;
  late final String arrivalComment;
  late final String receptionistImage;
  late final List<ReceptionistInfo> receptionistInfo;
  late final int receptionistId;
  late final String transactionId;
  late final String totalAmount;
  late final String cardType;
  late final String reason;
  late final String pickupReason;
  late final String createdAt;
  late final String updatedAt;
  late final String expiredAt;
  late final String receptionistComment;
  late final List<Booking> booking;

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    uid = json['uid'];
    bookingDate = json['booking_date'];
    arrivalDate = json['arrival_date'];
    bookingType = json['booking_type'];
    from = json['from'];
    to = json['to'];
    shipmentCompany = json['shipment_company'];
    bookingItem = json['booking_item'] == null ? "" : json['booking_item'];
    status = json['status'];
    accepted = json['accepted'];
    rejected = json['rejected'];
    pickupReview = List.from(json['pickup_review'])
        .map((e) => PickupReview.fromJson(e))
        .toList();
    scheduleId = json['schedule_id'];
    pickupagentId =
        json['pickupagent_id'] == null ? "" : json['pickupagent_id'];
    pickupAccept = json['pickup_accept'] == null ? "" : json['pickup_accept'];
    pickupItemimage =
        json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
    pickupItemimage1 =
        json['pickup_itemimage1'] == null ? "" : json['pickup_itemimage1'];
    pickupComment =
        json['pickup_comment'] == null ? "" : json['pickup_comment'];
    pickupComment1 =
        json['pickup_comment1'] == null ? "" : json['pickup_comment1'];
    departureImage =
        json['departure_image'] == null ? "" : json['departure_image'];
    departureComment =
        json['departure_comment'] == null ? "" : json['departure_comment'];
    arrivalImage = json['arrival_image'] == null ? "" : json['arrival_image'];
    arrivalComment =
        json['arrival_comment'] == null ? "" : json['arrival_comment'];
    receptionistImage =
        json['receptionist_image'] == null ? "" : json['receptionist_image'];
    receptionistInfo = List.from(json['receptionist_info'])
        .map((e) => ReceptionistInfo.fromJson(e))
        .toList();
    receptionistId = json['receptionist_id'];
    transactionId = json['transaction_id'];
    totalAmount = json['total_amount'];
    cardType = json['card_type'];
    reason = json['reason'] == null ? "" : json['reason'];
    pickupReason = json['pickup_reason'] == null ? "" : json['pickup_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expiredAt = json['expired_at'] == null ? "" : json['expired_at'];
    receptionistComment = json['receptionist_comment'] == null
        ? ""
        : json['receptionist_comment'];
    booking =
        List.from(json['booking']).map((e) => Booking.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['uid'] = uid;
    _data['booking_date'] = bookingDate;
    _data['arrival_date'] = arrivalDate;
    _data['booking_type'] = bookingType;
    _data['from'] = from;
    _data['to'] = to;
    _data['shipment_company'] = shipmentCompany;
    _data['booking_item'] = bookingItem;
    _data['status'] = status;
    _data['accepted'] = accepted;
    _data['rejected'] = rejected;
    _data['pickup_review'] = pickupReview.map((e) => e.toJson()).toList();
    _data['schedule_id'] = scheduleId;
    _data['pickupagent_id'] = pickupagentId;
    _data['pickup_accept'] = pickupAccept;
    _data['pickup_itemimage'] = pickupItemimage;
    _data['pickup_itemimage1'] = pickupItemimage1;
    _data['pickup_comment'] = pickupComment;
    _data['pickup_comment1'] = pickupComment1;
    _data['departure_image'] = departureImage;
    _data['departure_comment'] = departureComment;
    _data['arrival_image'] = arrivalImage;
    _data['arrival_comment'] = arrivalComment;
    _data['receptionist_image'] = receptionistImage;
    _data['receptionist_info'] =
        receptionistInfo.map((e) => e.toJson()).toList();
    _data['receptionist_id'] = receptionistId;
    _data['transaction_id'] = transactionId;
    _data['total_amount'] = totalAmount;
    _data['card_type'] = cardType;
    _data['reason'] = reason;
    _data['pickup_reason'] = pickupReason;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['expired_at'] = expiredAt;
    _data['receptionist_comment'] = receptionistComment;
    _data['booking'] = booking.map((e) => e.toJson()).toList();
    return _data;
  }
}

class PickupReview {
  PickupReview({
    required this.pickupType,
    required this.pickupLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupDistance,
    required this.pickupEstimate,
  });
  late final String pickupType;
  late final String pickupLocation;
  late final String pickupDate;
  late final String pickupTime;
  late final String pickupDistance;
  late final String pickupEstimate;

  PickupReview.fromJson(Map<String, dynamic> json) {
    pickupType = json['pickup_type'];
    pickupLocation = json['pickup_location'];
    pickupDate = json['pickup_date'];
    pickupTime = json['pickup_time'];
    pickupDistance =
        json['pickup_distance'] == null ? "" : json['pickup_distance'];
    pickupEstimate =
        json['pickup_estimate'] == null ? "" : json['pickup_estimate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pickup_type'] = pickupType;
    _data['pickup_location'] = pickupLocation;
    _data['pickup_date'] = pickupDate;
    _data['pickup_time'] = pickupTime;
    _data['pickup_distance'] = pickupDistance;
    _data['pickup_estimate'] = pickupEstimate;
    return _data;
  }
}

class ReceptionistInfo {
  ReceptionistInfo({
    required this.receptionistName,
    required this.receptionistEmail,
    required this.receptionistPhone,
    required this.receptionistAddress,
    required this.receptionistCountry,
  });
  late final String receptionistName;
  late final String receptionistEmail;
  late final String receptionistPhone;
  late final String receptionistAddress;
  late final String receptionistCountry;

  ReceptionistInfo.fromJson(Map<String, dynamic> json) {
    receptionistName = json['receptionist_name'];
    receptionistEmail = json['receptionist_email'];
    receptionistPhone = json['receptionist_phone'];
    receptionistAddress = json['receptionist_address'] == null
        ? ""
        : json['receptionist_address'];
    receptionistCountry = json['receptionist_country'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['receptionist_name'] = receptionistName;
    _data['receptionist_email'] = receptionistEmail;
    _data['receptionist_phone'] = receptionistPhone;
    _data['receptionist_address'] = receptionistAddress;
    _data['receptionist_country'] = receptionistCountry;
    return _data;
  }
}

class Booking {
  Booking({
    required this.id,
    required this.uid,
    required this.category,
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.description,
    required this.bookingId,
    required this.scheduleId,
  });
  late final int id;
  late final int uid;
  late final String category;
  late final List<ItemName> itemName;
  late final List<String> itemImage;
  late final int quantity;
  late final String description;
  late final int bookingId;
  late final int scheduleId;

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    category = json['category'];
    itemName =
        List.from(json['item_name']).map((e) => ItemName.fromJson(e)).toList();
    itemImage = List.castFrom<dynamic, String>(json['item_image']);
    quantity = json['quantity'];
    description = json['description'];
    bookingId = json['booking_id'];
    scheduleId = json['schedule_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['category'] = category;
    _data['item_name'] = itemName.map((e) => e.toJson()).toList();
    _data['item_image'] = itemImage;
    _data['quantity'] = quantity;
    _data['description'] = description;
    _data['booking_id'] = bookingId;
    _data['schedule_id'] = scheduleId;
    return _data;
  }
}

class ItemName {
  ItemName({
    required this.id,
    required this.itemname,
    required this.qty,
    required this.pickupfee,
    required this.shippingFee,
  });
  late final int id;
  late final String itemname;
  late final String qty;
  late final String pickupfee;
  late final String shippingFee;

  ItemName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemname = json['itemname'];
    qty = json['qty'];
    pickupfee = json['pickupfee'];
    shippingFee = json['shippingFee'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['itemname'] = itemname;
    _data['qty'] = qty;
    _data['pickupfee'] = pickupfee;
    _data['shippingFee'] = shippingFee;
    return _data;
  }
}
