// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(value) => "${value} hp";

  static String m1(count) =>
      "(${Intl.plural(count, zero: 'No reviews', one: '1 review', other: '${count} reviews')})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "allCars": MessageLookupByLibrary.simpleMessage("All cars"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account? "),
        "billingInformation":
            MessageLookupByLibrary.simpleMessage("Billing information"),
        "carInfo": MessageLookupByLibrary.simpleMessage("CAR INFO"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "color": MessageLookupByLibrary.simpleMessage("Color"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "day": MessageLookupByLibrary.simpleMessage("day"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete account"),
        "dontHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account? "),
        "drivetrain": MessageLookupByLibrary.simpleMessage("Drivetrain"),
        "emailAdress": MessageLookupByLibrary.simpleMessage("Email address"),
        "engine": MessageLookupByLibrary.simpleMessage("Engine"),
        "enterYourEmail":
            MessageLookupByLibrary.simpleMessage("Enter your email"),
        "enterYourName":
            MessageLookupByLibrary.simpleMessage("Enter your name"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "fuel": MessageLookupByLibrary.simpleMessage("Fuel"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full name"),
        "horsepower": m0,
        "logOut": MessageLookupByLibrary.simpleMessage("Log Out"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Login Failed"),
        "loginFailedPleaseTryAgain": MessageLookupByLibrary.simpleMessage(
            "Login failed. Please try again."),
        "moscowRussia": MessageLookupByLibrary.simpleMessage("Moscow, Russia"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "orLoginWith": MessageLookupByLibrary.simpleMessage("or login with"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "popularCars": MessageLookupByLibrary.simpleMessage("Popular cars"),
        "power": MessageLookupByLibrary.simpleMessage("Power"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "registerBtn": MessageLookupByLibrary.simpleMessage("Register"),
        "registerTitle": MessageLookupByLibrary.simpleMessage("Register"),
        "registrationFailed":
            MessageLookupByLibrary.simpleMessage("Registration Failed"),
        "registrationFailedPleaseTryAgain":
            MessageLookupByLibrary.simpleMessage(
                "Registration failed. Please try again."),
        "rentCar": MessageLookupByLibrary.simpleMessage("Rent Car"),
        "reviews": m1,
        "reviews_100_plus":
            MessageLookupByLibrary.simpleMessage("(100+ reviews)"),
        "seeAll": MessageLookupByLibrary.simpleMessage("see all"),
        "updateInfo": MessageLookupByLibrary.simpleMessage("Update info"),
        "updateUserInfo":
            MessageLookupByLibrary.simpleMessage("Update user info"),
        "userUpdatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("User updated successfully"),
        "welcomeLogin": MessageLookupByLibrary.simpleMessage(
            "Welcome!\nLogin to your account,\nOr create new one"),
        "yourLocation": MessageLookupByLibrary.simpleMessage("Your location")
      };
}
