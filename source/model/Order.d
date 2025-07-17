module model.Order;

import control.LogCtrl;
import control.DbCtrl;

import utils.Resources;

import model.User;
import model.Item;

import std.array;
import std.exception;

class MissingItemsInStockException : Exception {
  string message = "This item is missing in stock!";
  LogCtrl loggingController = new LogCtrl(Sy.LogFile);
  this(){
    super();
  }
    void logError(int messageType)
    {
      this.loggingController.issueLogMessage(LogMessageTypes.W, this.message);
    }

}  
  
clas  s Order{
  
    uint id;
  User owner;
    string targetAddress;
    string attachedMessage;

    float finalPrice = 0;
    Item[] includedItems = [];
  
    string paymentOption;
  bool isOver = false;
  
    DbCtrl dbHandler = new DbCtrl(EnvConstants.DBFile);
  LogCtrl loggerHandler = new LogCtrl(EnvConstants.LogFile);
  
    this(uint id, User owner, string addrs, string msg, string payOpt){
    this.id = id;
      this.owner = owner;
      this.targetAddress = addrs;
    this.attachedMessage = msg;
      if (payOpt in EnvConstants.PaymentMethods){
        this.paymentOption = payOpt;
      }
  }  
  
  vo  id updateFinalPrice(){
      for (int i = 0; i < this.includedItems.length; i++){
        auto currentItem = this.includedItems[i];
        if (!currentItem.verifyAvailability()){
          throw Exception("There are not enough (${currentItem.itemTitle}) for this order!");
          break;
      }
        else {
          currentItem.dispatchSelf(1);
          this.finalPrice += currentItem.unitPrice;
          this.loggerHandler.issueLogMessage(EnvConstants.MessageTypes[0], "Removing 1 (${currentItem.itemTitle}) from stock...");
        }
    }  
  }  
  
  void d  ispatchOrder(){
    th  is.isOver = true;
    tr  y {
        this.updateFinalPrice();
    } ca  tch (Exception e){
      th  is.dbHandler.dispatchOrder(this);
    }  
  }  
}  
  

  
  
  
  
  
  
  
  
  
    
  
