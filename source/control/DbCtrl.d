module control.DbCtrl;

import sqlite;

import std.file;
import std.stdio;
import std.digest.md;
import std.exception;

import model.User;
import model.Item;
import model.Order;

import control.LogCtrl;
import control.CryptCtrl;

import utils.Resources;

class DbCtrl
{
  string dbPath;
  Sqlite dbHandler;
  bool connectionStatus;

  LogCtrl loggingController;
  CryptCtrl encryptionController;

  this(string dbPath)
  {
    this.connectionStatus = false;

    this.loggingController = new LogCtrl(SystemConstants.LogFile);
    this.encryptionHandler = new CryptCtrl();

    if (isFile(dbPath))
    {
      this.dbPath = dbPath;
    }
    else
    {
      throw new Databas
    }
  }

  void startConnection()
  {
    if (!this.connectionStatus)
    {
      try
      {
        this.dbHandler = new Sqlite(dbPath, SQLITE_OPEN_READWRITE);
        this.connectionStatus = true;
        loggerHandler.issueLogMessage("INFO", "Successfully connected to db.");
      }
      catch (Exception e)
      {
        loggerHandler.issueLogMessage("ERROR", "Database connection failed. (${e.msg})");
      }
    }
    else
    {
      loggerHandler.issueLogMessage("WARNING", "Connection already active.");
    }
  }

  void terminateConnection()
  {
    if (this.connectionStatus)
    {
      this.dbHandler.close();
      this.connectionStatus = false;
      this.loggerHandler.issueLogMessage("INFO", "Disconnected from db.");
    }
    else
    {
      this.loggerHandler.issueLogMessage("ERROR", "Cannot terminate connection, as we are not currently connected.");
    }
  }

  void registerNewUser(string username, string password, string email)
  {
    try
    {
      this.startConnection();
      // Encrypt pwd 
      string securePwd = this.encryptionHandler.deriveKey(password);
      string sqlCommand = "INSERT INTO users (username, password, email) VALUES ('${username}', '${securePwd}', '${email}')";
      this.dbHandler.exec(sqlCommand);
      this.loggerHandler.issueLogMessage("INFO", "New user added.");
    }
    catch (Exception e)
    {
      this.loggerHandler.issueLogMessage("ERROR", "Failed to add user. (${e.msg})");
    }
    finally
    {
      this.terminateConnection();
    }
  }

  void registerNewProduct(string itemTitle, string itemDescription, float unitPrice, uint amountAvailable, string imgFile = "")
  {
    try
    {
      this.startConnection();
      // Encode img to base64 string (frontend will render it)
      string encodedImage;
      if (imgFile.length > 0)
      {
        encodedImage = this.encryptionHandler.encodeImage(imgFile);
      }
      else
      {
        encodedImage = "";
      }
      string sqlCommand = "INSERT INTO products (title, description, price, quantity, photo, display) VALUES ('${itemTitle}', '${itemDescription}', ${unitPrice}, ${amountAvailable}, '${encodedImage}')";
      this.dbHandler.exec(sqlCommand);
      this.loggerHandler.issueLogMessage("INFO", "New product added.");
    }
    catch (Exception e)
    {
      this.loggerHandler.issueLogMessage("ERROR", "Failed to add item. (${e.msg})");
    }
    finally
    {
      this.terminateConnection();
    }
  }

  void registerNewOrder(Order targetOrder)
  {
    try
    {
      this.startConnection();

      Order order = targetOrder;

      string sqlCommand = order.}
      catch (Exception e)
      {

      }
      finally
      {
        this.terminateConnection();
      }

    }

    void dispatchOrder(Order targetOrder)
    {
      try
      {
        this.startConnection();
        string sqlCommand = "UPDATE orders SET status = 1 WHERE id = ${targetOrder.id}";
        dbHandler.exec(sqlCommand);
      }
      catch (Exception e)
      {
        this.loggerHandler.issueLogMessage(EnvConstants.MessageTypes[2], "Could not connect to database ${e.msg}.");
      }
      finally
      {
        this.terminateConnection();
      }
    }

  }
