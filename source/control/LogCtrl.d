module control.LogCtrl;

import std.file;
import std.stdio;
import std.exception;

import utils.Resources;

class LogCtrl
{
  string logFilePath;
  LogMessageTypes logMessageTypes;
  this(string logFilePath)
  {
    this.logFilePath = logFilePath;
  }

  void issueLogMessage(LogMessageTypes messageType, string logMessage)
  {
    try
    {
      File logFileHandler = File(this.logFilePath, "a");
      if (messageType == this.logMessageTypes.ERROR)
      {
        string message = "☠  ERROR: ${logMessage}!\n";
        logFileHandler.writeln(message);
        writeln(message);
        throw new SuicideException();
      }
      else if (messageType == this.logMessageTypes.WARNING)
      {
        string message = "⚠¿WARNING: ${logMessage}...\n";
        logFileHandler.writeln(message);
        writeln(message);
      }
      else
      {
        string message = "🔍¿INFO: ${logMessage}.\n";
        logFileHandler.writeln(message);
        writeln(message);
      }
      logFileHandler.close();
    }
    catch (SuicideException e)
    {
      writeln("Cannot open nor find log file.");
      throw new SuicideException();
    }
    catch (Exception e)
    {
      issueLogMessage(LogMessageTypes.ERROR, "${e.msg}");
    }
  }
}
