// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(value) => "${value} л.с.";

  static String m1(count) =>
      "(${Intl.plural(count, zero: 'Нет отзывов', one: '1 отзыв', few: '${count} отзыва', many: '${count} отзывов', other: '${count} отзывов')})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "allCars": MessageLookupByLibrary.simpleMessage("Все автомобили"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Уже есть аккаунт? "),
        "billingInformation":
            MessageLookupByLibrary.simpleMessage("Платежная информация"),
        "carInfo":
            MessageLookupByLibrary.simpleMessage("Информация об автомобиле"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Поменять пароль"),
        "color": MessageLookupByLibrary.simpleMessage("Цвет"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Подтвердите пароль"),
        "day": MessageLookupByLibrary.simpleMessage("день"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Удалить аккаунт"),
        "dontHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Нет аккаунта? "),
        "drivetrain": MessageLookupByLibrary.simpleMessage("Привод"),
        "emailAdress": MessageLookupByLibrary.simpleMessage("Почта"),
        "engine": MessageLookupByLibrary.simpleMessage("Двигатель"),
        "enterYourEmail":
            MessageLookupByLibrary.simpleMessage("Введите вашу почту"),
        "enterYourName":
            MessageLookupByLibrary.simpleMessage("Введите ваше ФИО"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Забыли пароль?"),
        "fuel": MessageLookupByLibrary.simpleMessage("Топливо"),
        "fullName": MessageLookupByLibrary.simpleMessage("ФИО"),
        "horsepower": m0,
        "logOut": MessageLookupByLibrary.simpleMessage("Выйти"),
        "login": MessageLookupByLibrary.simpleMessage("Войти"),
        "loginFailed":
            MessageLookupByLibrary.simpleMessage("Не удалось авторизироваться"),
        "loginFailedPleaseTryAgain": MessageLookupByLibrary.simpleMessage(
            "Не удалось авторизироваться. Пожалуйста, попробуйте снова."),
        "moscowRussia": MessageLookupByLibrary.simpleMessage("Москва, Россия"),
        "notifications": MessageLookupByLibrary.simpleMessage("Уведомления"),
        "orLoginWith": MessageLookupByLibrary.simpleMessage("Или войти через"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "popularCars":
            MessageLookupByLibrary.simpleMessage("Популярные автомобили"),
        "power": MessageLookupByLibrary.simpleMessage("Мощность"),
        "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
        "registerBtn":
            MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "registerTitle": MessageLookupByLibrary.simpleMessage("Регистрация"),
        "registrationFailed": MessageLookupByLibrary.simpleMessage(
            "Не удалось зарегистрироваться"),
        "registrationFailedPleaseTryAgain":
            MessageLookupByLibrary.simpleMessage(
                "Не удалось зарегистрироваться. Пожалуйста, попробуйте снова."),
        "rentCar": MessageLookupByLibrary.simpleMessage("Заказать"),
        "reviews": m1,
        "reviews_100_plus":
            MessageLookupByLibrary.simpleMessage("(100+ отзывов)"),
        "seeAll": MessageLookupByLibrary.simpleMessage("Все"),
        "updateInfo": MessageLookupByLibrary.simpleMessage("Обновить"),
        "updateUserInfo":
            MessageLookupByLibrary.simpleMessage("Обновить информацию"),
        "userUpdatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Информация обновлена"),
        "welcomeLogin": MessageLookupByLibrary.simpleMessage(
            "Добро пожаловать!\nАвторизируйтесь,\nИли зарегистрируйтесь"),
        "yourLocation": MessageLookupByLibrary.simpleMessage("Местоположение")
      };
}
