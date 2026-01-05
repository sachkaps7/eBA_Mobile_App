// ignore_for_file: constant_identifier_names

import "package:shared_preferences/shared_preferences.dart";

const String PREFS_GENERIC_ACCESS_KEY = "PREFS_GENERIC_ACCESS_KEY";
const String PREFS_ACCESS_KEY = "PREFS_ACCESS_KEY";
const String PREFS_KEY_COMPANYCODE = "PREFS_KEY_COMPANYCODE";
const String PREFS_KEY_USERNAME = "PREFS_KEY_USERNAME";
const String PREFS_KEY_UID = "PREFS_KEY_UID";
const String PREFS_KEY_PASSWORD = "PREFS_KEY_PASSWORD";
const String PREFS_KEY_IS_REMEMBER_ME = "PREFS_KEY_IS_REMEMBER_ME";
const String PREFS_KEY_TOKEN = "PREFS_KEY_TOKEN";
const String PREFS_KEY_FCM_TOKEN = "PREFS_KEY_FCM_TOKEN";
const String PREFS_KEY_REFRESH_TOKEN = "PREFS_KEY_REFRESH_TOKEN";
const String PREFS_KEY_COMPANYCODE_SCREEN = "PREFS_KEY_COMPANYCODE_SCREEN";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_APP_PIN = "PREFS_KEY_APP_PIN";
const String PREFS_KEY_EMAIL = "PREFS_KEY_EMAIL";
const String PREFS_KEY_SELECTED_REGION = "PREFS_KEY_SELECTED_REGION";
const String PREFS_KEY_SELECTED_REGION_ID = "PREFS_KEY_SELECTED_REGION_ID";
const String PREFS_KEY_SELECTED_LOCATION = "PREFS_KEY_SELECTED_LOCATION";
const String PREFS_KEY_SELECTED_TRIMMED_LOCATION =
    "PREFS_KEY_SELECTED_TRIMMED_LOCATION";
const String PREFS_KEY_SELECTED_LOCATION_ID = "PREFS_KEY_SELECTED_LOCATION_ID";
const String PREFS_KEY_USER_SESSION = "PREFS_KEY_USER_SESSION";
const String PREFS_KEY_DECIMAL_PLACES = "PREFS_KEY_DECIMAL_PLACES";
const String PREFS_KEY_DECIMAL_PLACES_PRICE = "PREFS_KEY_DECIMAL_PLACES_PRICE";
const String PREFS_KEY_IS_ITEM_SCANNED = "PREFS_KEY_IS_ITEM_SCANNED";
const String PREFS_KEY_SCANNED_REGION_ID = "PREFS_KEY_SCANNED_REGION_ID";
const String PREFS_KEY_SCANNED_LOCATION_ID = "PREFS_KEY_SCANNED_LOCATION_ID";
const String PREFS_KEY_IS_DEVELOPER_MODE = "PREFS_KEY_IS_DEVELOPER_MODE";
const String PREFS_TANENT_ID = "PREFS_TANENT_ID";
const String PREFS_CLIENT_ID = "PREFS_CLIENT_ID";
const String REDIRECT_URI = "REDIRECT_URI";
const String DISPLAY_USER_NAME = "DISPLAY_USER_NAME";
const String IS_LOGIN_WITH_AZURE = "IS_LOGIN_WITH_AZURE";
const String MOBILE_VERSION = "MOBILE_VERSION";
const String BIOMETRIC_AUTH_ID = "BIOMETRIC_AUTH_ID";
const String IS_BIOMATRIC_ENABLED = "IS_BIOMATRIC_ENABLED";
const String BIOMETRIC_PROMPT_SHOWKEY = "BIOMETRIC_PROMPT_SHOWKEY";
const String REGION = "REGION ";
const String SELECT_REGIN_TITLE = "SELECT_REGIN_TITLE ";
const String BLIND_STOCK_EDIT = "BLIND_STOCK_EDIT";
const String INVENTORY_MANAGER = "INVENTORY_MANAGER";
const String PREFS_KEY_DEVICE_ID = "PREFS_KEY_DEVICE_ID";
const String DEVICE_PLATFORM_KEY = "DEVICE_PLATFORM_KEY";
const String PREFS_KEY_LOGIN = "PREFS_KEY_LOGIN";
// SystemFunction
const String SYS_REQUEST = "SYS_REQUEST";
const String SYS_ORDER = "SYS_ORDER";
const String SYS_RFQ = "SYS_RFQ";
const String SYS_EXPENSE = "SYS_EXPENSE";
const String SYS_RECIPE = "SYS_RECIPE";
const String SYS_INVENTORY = "SYS_INVENTORY";
const String SYS_PAYMENTS = "SYS_PAYMENTS";
const String SYS_PAYMENT_APPROVER = "SYS_PAYMENT_APPROVER";
const String SYS_REGION_FUNCTION = "SYS_REGION_FUNCTION";
const String SYS_REGION_FUNCTION_AVAILABLE = "SYS_REGION_FUNCTION_AVAILABLE";
const String SYS_REGION_NAME = "SYS_REGION_NAME";
const String SYS_REQUEST_APPROVAL = "SYS_REQUEST_APPROVAL";
const String SYS_RULE_FUNCTION = "SYS_RULE_FUNCTION";
const String SYS_RULE_APPROVAL = "SYS_RULE_APPROVAL";
const String SYS_COST_CENTRE_APPROVAL = "SYS_COST_CENTRE_APPROVAL";
const String SYS_GROUP_APPROVAL = "SYS_GROUP_APPROVAL";

// UserPermissions
const String USER_REQUEST = "USER_REQUEST";
const String USER_ORDER = "USER_ORDER";
const String USER_RFQ = "USER_RFQ";
const String USER_GR = "USER_GR";
const String USER_PAYMENTS = "USER_PAYMENTS";
const String USER_EXPENSE = "USER_EXPENSE";
const String USER_RECIPE = "USER_RECIPE";
const String USER_INVENTORY = "USER_INVENTORY";

// UserApprovals
const String USER_REQUEST_APPROVAL = "USER_REQUEST_APPROVAL";
const String USER_ORDER_APPROVAL = "USER_ORDER_APPROVAL";
const String USER_INVOICE_APPROVAL = "USER_INVOICE_APPROVAL";
const String USER_EXPENSE_APPROVAL = "USER_EXPENSE_APPROVAL";

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  static SharedPrefs get instance => _instance;
  SharedPrefs._internal();
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get genericAccessKey =>
      _sharedPrefs.getString(PREFS_GENERIC_ACCESS_KEY) ?? "123456";

  String get accessKey => _sharedPrefs.getString(PREFS_ACCESS_KEY) ?? "";

  set accessKey(String value) {
    _sharedPrefs.setString(PREFS_ACCESS_KEY, value);
  }

  String get companyCode => _sharedPrefs.getString(PREFS_KEY_COMPANYCODE) ?? "";

  set companyCode(String value) {
    _sharedPrefs.setString(PREFS_KEY_COMPANYCODE, value);
  }

  String get username => _sharedPrefs.getString(PREFS_KEY_USERNAME) ?? "";

  set username(String value) {
    _sharedPrefs.setString(PREFS_KEY_USERNAME, value);
  }

  String get uID => _sharedPrefs.getString(PREFS_KEY_UID) ?? "";

  set uID(String value) {
    _sharedPrefs.setString(PREFS_KEY_UID, value);
  }

  String get password => _sharedPrefs.getString(PREFS_KEY_PASSWORD) ?? "";

  set password(String value) {
    _sharedPrefs.setString(PREFS_KEY_PASSWORD, value);
  }

  String get jwtToken => _sharedPrefs.getString(PREFS_KEY_TOKEN) ?? "";

  set jwtToken(String value) {
    _sharedPrefs.setString(PREFS_KEY_TOKEN, value);
  }

  String get fcmToken => _sharedPrefs.getString(PREFS_KEY_FCM_TOKEN) ?? "";

  set fcmToken(String value) {
    _sharedPrefs.setString(PREFS_KEY_FCM_TOKEN, value);
  }

  String get refreshToken =>
      _sharedPrefs.getString(PREFS_KEY_REFRESH_TOKEN) ?? "";

  set refreshToken(String value) {
    _sharedPrefs.setString(PREFS_KEY_REFRESH_TOKEN, value);
  }

  String get appPIN => _sharedPrefs.getString(PREFS_KEY_APP_PIN) ?? "";

  set appPIN(String value) {
    _sharedPrefs.setString(PREFS_KEY_APP_PIN, value);
  }

  bool get isCompanyCodeScreenViewed =>
      _sharedPrefs.getBool(PREFS_KEY_COMPANYCODE_SCREEN) ?? false;

  set isCompanyCodeScreenViewed(bool value) {
    _sharedPrefs.setBool(PREFS_KEY_COMPANYCODE_SCREEN, value);
  }

  bool get isRememberMeSelected =>
      _sharedPrefs.getBool(PREFS_KEY_IS_REMEMBER_ME) ?? false;

  set isRememberMeSelected(bool value) {
    _sharedPrefs.setBool(PREFS_KEY_IS_REMEMBER_ME, value);
  }

  String get userEmail => _sharedPrefs.getString(PREFS_KEY_EMAIL) ?? "";

  set userEmail(String value) {
    _sharedPrefs.setString(PREFS_KEY_EMAIL, value);
  }

  String get selectedRegion =>
      _sharedPrefs.getString(PREFS_KEY_SELECTED_REGION) ?? "";

  set selectedRegion(String value) {
    _sharedPrefs.setString(PREFS_KEY_SELECTED_REGION, value);
  }

  int get selectedRegionID =>
      _sharedPrefs.getInt(PREFS_KEY_SELECTED_REGION_ID) ?? 0;

  set selectedRegionID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SELECTED_REGION_ID, value);
  }

  String get selectedLocation =>
      _sharedPrefs.getString(PREFS_KEY_SELECTED_LOCATION) ?? "";

  set selectedLocation(String value) {
    _sharedPrefs.setString(PREFS_KEY_SELECTED_LOCATION, value);
  }

  String get selectedTrimmedLocation =>
      _sharedPrefs.getString(PREFS_KEY_SELECTED_TRIMMED_LOCATION) ?? "";

  set selectedTrimmedLocation(String value) {
    _sharedPrefs.setString(PREFS_KEY_SELECTED_TRIMMED_LOCATION, value);
  }

  int get selectedLocationID =>
      _sharedPrefs.getInt(PREFS_KEY_SELECTED_LOCATION_ID) ?? 0;

  set selectedLocationID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SELECTED_LOCATION_ID, value);
  }

  int get decimalPlaces => _sharedPrefs.getInt(PREFS_KEY_DECIMAL_PLACES) ?? 0;

  set decimalPlaces(int value) {
    _sharedPrefs.setInt(PREFS_KEY_DECIMAL_PLACES, value);
  }

  int get decimalplacesprice =>
      _sharedPrefs.getInt(PREFS_KEY_DECIMAL_PLACES_PRICE) ?? 0;

  set decimalplacesprice(int value) {
    _sharedPrefs.setInt(PREFS_KEY_DECIMAL_PLACES_PRICE, value);
  }

  String get userSession =>
      _sharedPrefs.getString(PREFS_KEY_USER_SESSION) ?? "";

  set userSession(String value) {
    _sharedPrefs.setString(PREFS_KEY_USER_SESSION, value);
  }

  bool get isItemScanned =>
      _sharedPrefs.getBool(PREFS_KEY_IS_ITEM_SCANNED) ?? false;

  set isItemScanned(bool value) {
    _sharedPrefs.setBool(PREFS_KEY_IS_ITEM_SCANNED, value);
  }

  int get scannedRegionID =>
      _sharedPrefs.getInt(PREFS_KEY_SCANNED_REGION_ID) ?? 0;

  set scannedRegionID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SCANNED_REGION_ID, value);
  }

  int get scannedLocationID =>
      _sharedPrefs.getInt(PREFS_KEY_SCANNED_LOCATION_ID) ?? 0;

  set scannedLocationID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SCANNED_LOCATION_ID, value);
  }

  String get tanentId => _sharedPrefs.getString(PREFS_TANENT_ID) ?? "";

  set tanentId(String value) {
    _sharedPrefs.setString(PREFS_TANENT_ID, value);
  }

  String get clientId => _sharedPrefs.getString(PREFS_CLIENT_ID) ?? "";

  set clientId(String value) {
    _sharedPrefs.setString(PREFS_CLIENT_ID, value);
  }

  String get redirectURI => _sharedPrefs.getString(REDIRECT_URI) ?? "";

  set redirectURI(String value) {
    _sharedPrefs.setString(REDIRECT_URI, value);
  }

  String get displayUserName => _sharedPrefs.getString(DISPLAY_USER_NAME) ?? "";

  set displayUserName(String value) {
    _sharedPrefs.setString(DISPLAY_USER_NAME, value);
  }

  bool get isLoginazureAd => _sharedPrefs.getBool(IS_LOGIN_WITH_AZURE) ?? false;

  set isLoginazureAd(bool value) {
    _sharedPrefs.setBool(IS_LOGIN_WITH_AZURE, value);
  }

  String get mobileVersion => _sharedPrefs.getString(MOBILE_VERSION) ?? "";

  set mobileVersion(String value) {
    _sharedPrefs.setString(MOBILE_VERSION, value);
  }

  String get biometricAuthId => _sharedPrefs.getString(BIOMETRIC_AUTH_ID) ?? "";

  set biometricAuthId(String value) {
    _sharedPrefs.setString(BIOMETRIC_AUTH_ID, value);
  }

  bool get isBiometricEnabled =>
      _sharedPrefs.getBool(IS_BIOMATRIC_ENABLED) ?? false;

  set isBiometricEnabled(bool value) {
    _sharedPrefs.setBool(IS_BIOMATRIC_ENABLED, value);
  }

  bool get hasSeenBiometricPrompt =>
      _sharedPrefs.getBool(BIOMETRIC_PROMPT_SHOWKEY) ?? false;

  set hasSeenBiometricPrompt(bool value) =>
      _sharedPrefs.setBool(BIOMETRIC_PROMPT_SHOWKEY, value);

  bool get region => _sharedPrefs.getBool(REGION) ?? false;

  set region(bool value) => _sharedPrefs.setBool(REGION, value);

  String get selectRegionTitle =>
      _sharedPrefs.getString(SELECT_REGIN_TITLE) ?? "";

  set selectRegionTitle(String value) =>
      _sharedPrefs.setString(SELECT_REGIN_TITLE, value);
  String get deviceId => _sharedPrefs.getString(PREFS_KEY_DEVICE_ID) ?? "";

  bool get blindStockEdit => _sharedPrefs.getBool(BLIND_STOCK_EDIT) ?? false;

  set blindStockEdit(bool value) =>
      _sharedPrefs.setBool(BLIND_STOCK_EDIT, value);

  bool get inventoryManager => _sharedPrefs.getBool(INVENTORY_MANAGER) ?? false;
  set inventoryManager(bool value) =>
      _sharedPrefs.setBool(INVENTORY_MANAGER, value);

  set deviceId(String value) {
    _sharedPrefs.setString(PREFS_KEY_DEVICE_ID, value);
  }

  String get devicePlatform =>
      _sharedPrefs.getString(DEVICE_PLATFORM_KEY) ?? "";

  set devicePlatform(String value) =>
      _sharedPrefs.setString(DEVICE_PLATFORM_KEY, value);
  bool get sysRequest => _sharedPrefs.getBool(SYS_REQUEST) ?? false;
  set sysRequest(bool value) => _sharedPrefs.setBool(SYS_REQUEST, value);

  bool get sysOrder => _sharedPrefs.getBool(SYS_ORDER) ?? false;
  set sysOrder(bool value) => _sharedPrefs.setBool(SYS_ORDER, value);

  bool get sysRFQ => _sharedPrefs.getBool(SYS_RFQ) ?? false;
  set sysRFQ(bool value) => _sharedPrefs.setBool(SYS_RFQ, value);

  bool get sysExpense => _sharedPrefs.getBool(SYS_EXPENSE) ?? false;
  set sysExpense(bool value) => _sharedPrefs.setBool(SYS_EXPENSE, value);

  bool get sysRecipe => _sharedPrefs.getBool(SYS_RECIPE) ?? false;
  set sysRecipe(bool value) => _sharedPrefs.setBool(SYS_RECIPE, value);

  bool get sysInventory => _sharedPrefs.getBool(SYS_INVENTORY) ?? false;
  set sysInventory(bool value) => _sharedPrefs.setBool(SYS_INVENTORY, value);

  bool get sysPayments => _sharedPrefs.getBool(SYS_PAYMENTS) ?? false;
  set sysPayments(bool value) => _sharedPrefs.setBool(SYS_PAYMENTS, value);

  int get sysPaymentApprover => _sharedPrefs.getInt(SYS_PAYMENT_APPROVER) ?? 0;
  set sysPaymentApprover(int value) =>
      _sharedPrefs.setInt(SYS_PAYMENT_APPROVER, value);

  bool get sysRegionFunction =>
      _sharedPrefs.getBool(SYS_REGION_FUNCTION) ?? false;
  set sysRegionFunction(bool value) =>
      _sharedPrefs.setBool(SYS_REGION_FUNCTION, value);

  bool get sysRegionFunctionAvailable =>
      _sharedPrefs.getBool(SYS_REGION_FUNCTION_AVAILABLE) ?? false;
  set sysRegionFunctionAvailable(bool value) =>
      _sharedPrefs.setBool(SYS_REGION_FUNCTION_AVAILABLE, value);

  String get sysRegionName => _sharedPrefs.getString(SYS_REGION_NAME) ?? "";
  set sysRegionName(String value) =>
      _sharedPrefs.setString(SYS_REGION_NAME, value);

  bool get sysRequestApproval =>
      _sharedPrefs.getBool(SYS_REQUEST_APPROVAL) ?? false;
  set sysRequestApproval(bool value) =>
      _sharedPrefs.setBool(SYS_REQUEST_APPROVAL, value);

  bool get sysRuleFunction => _sharedPrefs.getBool(SYS_RULE_FUNCTION) ?? false;
  set sysRuleFunction(bool value) =>
      _sharedPrefs.setBool(SYS_RULE_FUNCTION, value);

  bool get sysRuleApproval => _sharedPrefs.getBool(SYS_RULE_APPROVAL) ?? false;
  set sysRuleApproval(bool value) =>
      _sharedPrefs.setBool(SYS_RULE_APPROVAL, value);

  bool get sysCostCentreApproval =>
      _sharedPrefs.getBool(SYS_COST_CENTRE_APPROVAL) ?? false;
  set sysCostCentreApproval(bool value) =>
      _sharedPrefs.setBool(SYS_COST_CENTRE_APPROVAL, value);

  bool get sysGroupApproval =>
      _sharedPrefs.getBool(SYS_GROUP_APPROVAL) ?? false;
  set sysGroupApproval(bool value) =>
      _sharedPrefs.setBool(SYS_GROUP_APPROVAL, value);
  String get userRequest => _sharedPrefs.getString(USER_REQUEST) ?? "";
  set userRequest(String value) => _sharedPrefs.setString(USER_REQUEST, value);

  String get userOrder => _sharedPrefs.getString(USER_ORDER) ?? "";
  set userOrder(String value) => _sharedPrefs.setString(USER_ORDER, value);

  String get userRFQ => _sharedPrefs.getString(USER_RFQ) ?? "";
  set userRFQ(String value) => _sharedPrefs.setString(USER_RFQ, value);

  String get userGR => _sharedPrefs.getString(USER_GR) ?? "";
  set userGR(String value) => _sharedPrefs.setString(USER_GR, value);

  String get userPayments => _sharedPrefs.getString(USER_PAYMENTS) ?? "";
  set userPayments(String value) =>
      _sharedPrefs.setString(USER_PAYMENTS, value);

  String get userExpense => _sharedPrefs.getString(USER_EXPENSE) ?? "";
  set userExpense(String value) => _sharedPrefs.setString(USER_EXPENSE, value);

  String get userRecipe => _sharedPrefs.getString(USER_RECIPE) ?? "";
  set userRecipe(String value) => _sharedPrefs.setString(USER_RECIPE, value);

  String get userInventory => _sharedPrefs.getString(USER_INVENTORY) ?? "";
  set userInventory(String value) =>
      _sharedPrefs.setString(USER_INVENTORY, value);
  bool get userRequestApproval =>
      _sharedPrefs.getBool(USER_REQUEST_APPROVAL) ?? false;
  set userRequestApproval(bool value) =>
      _sharedPrefs.setBool(USER_REQUEST_APPROVAL, value);

  bool get userOrderApproval =>
      _sharedPrefs.getBool(USER_ORDER_APPROVAL) ?? false;
  set userOrderApproval(bool value) =>
      _sharedPrefs.setBool(USER_ORDER_APPROVAL, value);

  bool get userInvoiceApproval =>
      _sharedPrefs.getBool(USER_INVOICE_APPROVAL) ?? false;
  set userInvoiceApproval(bool value) =>
      _sharedPrefs.setBool(USER_INVOICE_APPROVAL, value);

  bool get userExpenseApproval =>
      _sharedPrefs.getBool(USER_EXPENSE_APPROVAL) ?? false;
  set userExpenseApproval(bool value) =>
      _sharedPrefs.setBool(USER_EXPENSE_APPROVAL, value);
 bool get isLoggedIn  => _sharedPrefs.getBool(PREFS_KEY_LOGIN) ?? false;
  set isLoggedIn (bool value) =>
      _sharedPrefs.setBool(PREFS_KEY_LOGIN, value);
}
