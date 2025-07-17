module model.user;

class User
{

  int userId;

  string username;
  string rawPwdEntry;

  string sourcePwdStr;
  string lastAuthToken;

  bool clearance = false;

  this(int userId)
  {
    this.userId = userId;
  }

  // Define login credential attributes, refferenced by unique userId number; 
  void fetchDataRegistries()
  {
    // TODO: 
    // Link DB controller

  }

  void deriveSourceString(string extInput, string saltEntry)
  {
    // TODO
    // Link local controller (register/auth purposes)
  }

  void login()
  {
    // TODO: 
    // Implement alongside server development

  }

}
