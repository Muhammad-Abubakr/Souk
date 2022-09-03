String parseAuthError(String code) {
  switch (code) {
    case "invalid-email":
      return "Invalid Email";
    case "user-not-found":
      return "There is no user corresponding to this Email Address.";
    case "web-context-canceled":
      return "Operation cancelled by the user";
    case "web-context-already-presented":
      return "Restart the application and try again";
    case "wrong-password":
      return "Password Incorrect or login method does not match with provided Email.";
    case "email-already-in-use":
      return "This email is already linked with another account.";
    case "weak-password":
      return "Password must be more than 6 Characters.";
    case "unknown":
      return "Please provide your email.";
    default:
      return code;
  }
}
