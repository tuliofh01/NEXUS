module model.Item;

import control.DbCtrl;
import control.LogCtrl;

class Item
{

  uint itemId;

  string itemTitle;
  string itemPicture;
  string itemDescription;

  float unitPrice;
  uint amountAvailable;

  bool displayStatus = false;

  this(uint itemId, string itemTitle, string itemDescription, float unitPrice, uint amountAvailable = 0)
  {
    this.itemId = itemId;
    this.itemTitle = itemTitle;
    this.itemDescription = itemDescription;
    this.unitPrice = unitPrice;
    this.amountAvailable = amountAvailable;
  }

  bool verifyAvailability()
  {
    if (displayStatus)
      return true;
    else
      return false;
  }

  void restock(uint amount)
  {

  }

  void dispatchSelf(uint amount)
  {

  }

  void setDisplayability(bool status = false)
  {
    this.displayStatus = status;
  }

}
