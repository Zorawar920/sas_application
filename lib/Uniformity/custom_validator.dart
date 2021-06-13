class ValidatePassword {
  String passwordValue;

  ValidatePassword(this.passwordValue);

  String? validation() {
    if (this.passwordValue.isEmpty) {
      return 'Please Enter Password ';
    } else if (passwordValue.length < 6) {
      return 'Password Should be atleast 6 characters long';
    }
  }
}

class ValidateEmail {
  String emailValue;
  ValidateEmail(this.emailValue);

  String? validate() {
    if (this.emailValue.isEmpty) {
      return 'Please Enter Email';
    } else if (!emailValue.contains("@")) {
      return 'Please enter valid email address';
    }
  }
}

class ValidateName {
  String nameValue;
  ValidateName(this.nameValue);

  String? validate() {
    if (this.nameValue.isEmpty) {
      return 'Please Enter Your Name';
    }
  }
}
