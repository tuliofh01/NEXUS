module utils.Resources;

import std.stdio;
import std.container;

enum SystemConstants
{
  LogFile = "assets/logs.txt",
  DBFile = "assets/archive.db",
  ServerSideKey = "S3crEtK3y",
  ImgsPath = "assets/imgs/"
}

enum LogMessageTypes
{
  INFO = 0,
  ERROR = 1,
  WARNING = 2
}

enum PaymentOptions
{
  PIX = 0,
  DEBIT = 1,
  CREDIT = 2
}
