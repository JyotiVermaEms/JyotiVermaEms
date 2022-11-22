class ItemDetail {
  var itemid,
      itemtotal,
      itemName,
      categoryName,
      description,
      qty,
      pickupfee,
      shipinfee,
      icon,
      nameItem,
      tempItem,
      amounttotal;

  List? imageList;
  ItemDetail(
      {this.itemid,
      this.itemtotal,
      this.categoryName,
      this.description,
      this.imageList,
      this.itemName,
      this.qty,
      this.pickupfee,
      this.shipinfee,
      this.icon,
      this.nameItem,
      this.tempItem,
      this.amounttotal});
}

// =================================================================================
class ItemDetail1 {
  var itemName,
      categoryName,
      description,
      qty,
      pickupfee,
      shipinfee,
      icon,
      nameItem;

  ItemDetail1(
      {this.categoryName,
      this.description,
      this.itemName,
      this.qty,
      this.pickupfee,
      this.shipinfee,
      this.icon,
      this.nameItem});
}
