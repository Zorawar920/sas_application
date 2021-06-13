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

class ValidateConfirmPassword {
  String newpassvalue;
  String oldpassvalue;
  ValidateConfirmPassword(this.newpassvalue, this.oldpassvalue);

  String? validation() {
    if (this.oldpassvalue.isEmpty) {
      return 'Please Enter Password Field First';
    } else if (this.oldpassvalue != this.newpassvalue) {
      return 'Password does not match';
    } else {
      return null;
    }
  }
}

class ValidateEmail {
  String emailValue;
  ValidateEmail(this.emailValue);
  RegExp regx = RegExp(r'\w+@\w+\.\w+');
  String? validate() {
    if (this.emailValue.isEmpty) {
      return 'Please Enter an Email';
    } else if (!regx.hasMatch(emailValue)) {
      return 'Please Enter a Vaild Email';
    }
  }
}

class ValidateName {
  String nameValue;
  ValidateName(this.nameValue);

  String? validate() {
    if (this.nameValue.isEmpty) {
      return 'Please Enter Your Name';
    } else if (this.nameValue.length >= 25) {
      return 'Please Enter a Vaild Name';
    }
  }
}
