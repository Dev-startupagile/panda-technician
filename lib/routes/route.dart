import 'package:get/get.dart';
import 'package:panda_technician/routes/middleware/authentication_middleware.dart';

import 'package:panda_technician/screens/auth/LoginScreen.dart';
import 'package:panda_technician/screens/auth/creatAccount2.dart';
import 'package:panda_technician/screens/auth/createAccount.dart';
import 'package:panda_technician/screens/auth/emailVerify.dart';
import 'package:panda_technician/screens/auth/signUpVerification.dart';
import 'package:panda_technician/screens/auth/sign_up_method_screen.dart';
import 'package:panda_technician/screens/auth/verificationScreen.dart';
import 'package:panda_technician/screens/createOffer.dart';
import 'package:panda_technician/screens/notification/notifications.dart';
import 'package:panda_technician/screens/offers/displayOffer.dart';
import 'package:panda_technician/screens/offers/editOffer.dart';
import 'package:panda_technician/screens/offers/onlyDisplayOffer.dart';
import 'package:panda_technician/screens/offers/updateDIsplayOffer.dart';
import 'package:panda_technician/screens/onboarding_squence.dart';
import 'package:panda_technician/screens/policy/fAQ.dart';
import 'package:panda_technician/screens/policy/help.dart';
import 'package:panda_technician/screens/policy/privacyPolicy.dart';
import 'package:panda_technician/screens/policy/termAndService.dart';
import 'package:panda_technician/screens/offers/listOffers.dart';
import 'package:panda_technician/screens/profile/editPassword.dart';
import 'package:panda_technician/screens/profile/editProfile.dart';
import 'package:panda_technician/screens/profile/payment.dart';
import 'package:panda_technician/screens/profile/profile.dart';
import 'package:panda_technician/screens/profile/technician_transactions.dart';
import 'package:panda_technician/screens/requestFlow/jobDetail.dart';
import 'package:panda_technician/screens/requests/MapScreen.dart';
import 'package:panda_technician/screens/requestFlow/acceptJob.dart';
import 'package:panda_technician/screens/requests/requestes.dart';
import 'package:panda_technician/screens/services/serviceSetting.dart';
import 'package:panda_technician/screens/settings/settings.dart';
import 'package:panda_technician/screens/auth/forgetPassword.dart' as fp;

const String initPage = '/initPage';

const String loginPage = '/Login';
const String homePage = '/Home';
const String jobs = '/Jobs';
const String jobDetail = '/JobDetail';
const String viewJob = '/ViewJob';
const String profilePage = '/Profile';
const String requests = '/Requests';
const String offers = '/Offers';
const String displayOffer = '/DisplayOffer';
const String onlyDisplayOffer = "/OnlyDisplayOffer";
const String createOffer = '/CreateOffer';
const String termsAndService = '/TermsAndService';
const String privacyPolicy = '/PrivacyPolicy';
const String signupVerification = "/SignupVerification";
const String serviceSetting = '/ServiceSetting';
const String editProfile = "/EditProfile";
const String editPassword = "/EditPassword";
const String verification = "/Verification";
const String settingsName = "/Settings";
const String createAccount2 = "/CreateAccount2";
const String notificationPage = "/Notification";
const String emailVerify = "/EmailVerify";
const String updateDisplayOffer = "/UpdateDisplayOffer";
const String faq = "/Faq";
const String editOffer = "/EditOffer";
const String webView = "/webView";
const String payment = "/Payment";
const String help = "/Help";
const String forgetPassword = "/ForgetPassword";
const String createAccount = "/CreateAccount";

const String settingsPage = "/settingsPage";
const String technicianTransactionPage = "/technicianTransactionPage";
const String signUpMethodScreen = "/signUpMethodScreen";

List<GetPage> getPages = [
  GetPage(
      name: initPage,
      page: () => const OnboardingSlider(),
      middlewares: [AuthMiddleware()]),
  GetPage(name: loginPage, page: () => const Login()),
  GetPage(name: homePage, page: () => const MapScreen()),
  GetPage(name: jobDetail, page: () => const AcceptJob()),
  GetPage(name: createOffer, page: () => CreateOffer()),
  GetPage(name: requests, page: () => const Requests()),
  GetPage(name: termsAndService, page: () => const TermAndService()),
  GetPage(name: offers, page: () => const Offers()),
  GetPage(name: profilePage, page: () => const Profile()),
  GetPage(name: privacyPolicy, page: () => const PrivacyPolicy()),
  GetPage(name: signupVerification, page: () => const SignUpVerification()),
  GetPage(name: serviceSetting, page: () => const ServiceSetting()),
  GetPage(name: editProfile, page: () => const EditProfile()),
  GetPage(name: editPassword, page: () => const EditPassword()),
  GetPage(name: help, page: () => const Help()),
  GetPage(name: verification, page: () => const VerficationScreen()),
  GetPage(name: createAccount2, page: () => CreateAccount2()),
  GetPage(name: viewJob, page: () => JobDetail()),
  GetPage(name: displayOffer, page: () => DisplayOffer()),
  GetPage(name: onlyDisplayOffer, page: () => OnlyDisplayOffer()),
  GetPage(name: payment, page: () => const Payment()),
  GetPage(name: settingsName, page: () => const Settings()),
  GetPage(name: notificationPage, page: () => const Notifications()),
  GetPage(name: faq, page: () => const Faq()),
  GetPage(name: emailVerify, page: () => const EmailVerify()),
  GetPage(name: forgetPassword, page: () => const fp.ForgetPassword()),
  GetPage(name: createAccount, page: () => const CreateAccount()),
  GetPage(name: signUpMethodScreen, page: () => const SignUpMethodScreen()),
  GetPage(name: editOffer, page: () => EditOffer()),
  GetPage(name: settingsPage, page: () => Settings()),
  GetPage(name: updateDisplayOffer, page: () => UpdateDisplayOffer()),
  GetPage(
      name: technicianTransactionPage,
      page: () => TechnicianTransactionWidget()),
];
