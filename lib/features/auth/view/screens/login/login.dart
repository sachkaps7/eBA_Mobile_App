// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:eyvo_v3/CommonCode/global_utils.dart';
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/load_login_response.dart';
import 'package:eyvo_v3/api/response_models/login_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/app/sizes_helper.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/routes_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/utils.dart';
import 'package:eyvo_v3/core/widgets/alert.dart';
import 'package:eyvo_v3/core/widgets/button.dart';
import 'package:eyvo_v3/core/widgets/checkbox_list_tile.dart';
import 'package:eyvo_v3/core/widgets/custom_field.dart';
import 'package:eyvo_v3/core/widgets/dashed_line_text.dart';
import 'package:eyvo_v3/core/widgets/header_logo.dart';
import 'package:eyvo_v3/core/widgets/or_divider.dart';
import 'package:eyvo_v3/core/widgets/progress_indicator.dart';
import 'package:eyvo_v3/core/widgets/text_error.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/order_details_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/company_code/company_code.dart';
import 'package:eyvo_v3/features/auth/view/screens/dashboard/dashbord.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:eyvo_v3/presentation/forgot_password/forgot_password.dart';
import 'package:eyvo_v3/presentation/forgot_user_id/forgot_user_id.dart';
import 'package:eyvo_v3/presentation/home/home.dart';
import 'package:eyvo_v3/presentation/notification_dashboard.dart';
import 'package:eyvo_v3/services/azure_auth_service.dart';
import 'package:eyvo_v3/services/biometric_auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginViewPage extends StatefulWidget {
  final Map<String, String>? notificationData;

  const LoginViewPage({Key? key, this.notificationData}) : super(key: key);

  @override
  State<LoginViewPage> createState() => _LoginViewPageState();
}

class _LoginViewPageState extends State<LoginViewPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool isUserNameError = false;
  bool isPasswordError = false;
  bool isFormValidated = false;
  bool isLoading = false;
  bool isLoadingForScan = false;
  bool isLoadingForAzureAD = false;
  bool isLoginWithScan = false;
  bool isLoginazureAd = false;
  String userNameText = AppStrings.userID;
  String passwordText = AppStrings.password;
  String errorText = AppStrings.requiresValue;
  final ApiService apiService = ApiService();
  int tapCount = 0;
  bool isLoginOptionsLoaded = false;
  bool isBiometricPopupVisible = false;
  bool showFullLoginForm = false;
  final hasSeenPrompt = SharedPrefs().hasSeenBiometricPrompt;
  bool _hasBiometricTriggered = false;
  bool biometricAvailable = false;
  bool biometricEnabled = false;
  bool authFailed = false;
  bool isAuthenticating = false;
  bool showErrorScreen = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchLoginDetails();
    _initBiometric();
    usernameController.addListener(_onUserNameTextChange);
    passwordController.addListener(_onPasswordTextChange);

    usernameController.text = SharedPrefs().username;
    passwordController.text = SharedPrefs().password;
    checkedValue = SharedPrefs().isRememberMeSelected;
    if (usernameController.text.isEmpty && passwordController.text.isEmpty) {
      checkedValue = false;
    }

    SharedPrefs().userEmail = '';
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState?.validate();
  }

  Future<void> _initBiometric() async {
    biometricAvailable = await BiometricAuth().checkBiometrics();
    biometricEnabled = BiometricAuth().isBiometricEnabled();
    // setState(() {});
  }

  // void fetchLoginDetails() async {
  //   Map<String, dynamic> data = {
  //      'uid': SharedPrefs().uID,'apptype': AppConstants.apptype,
  //   };
  //   final jsonResponse =
  //       await apiService.postRequest(context, ApiService.loadLogin, data);
  //   if (jsonResponse != null) {
  //     final response = LoadLoginResponse.fromJson(jsonResponse);
  //     if (response.code == '200') {
  //       setState(() {
  //         SharedPrefs().tanentId = response.data.tenantId;
  //         SharedPrefs().clientId = response.data.clientId;
  //         SharedPrefs().redirectURI = response.data.redirectUri;
  //         isLoginWithScan = response.data.isLoginWithScan;
  //         isLoginazureAd = response.data.isLoginazureAd;
  //         SharedPrefs().isLoginazureAd = response.data.isLoginazureAd;
  //         isLoginOptionsLoaded = true;
  //       });
  //     } else {
  //       setState(() {
  //         isLoginWithScan = false;
  //         isLoginazureAd = false;
  //         isLoginOptionsLoaded = true;
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       isLoginOptionsLoaded = true;
  //     });
  //   }
  // }
  void fetchLoginDetails() async {
    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
      'apptype': AppConstants.apptype,
    };

    setState(() {
      isLoginOptionsLoaded = false;
    });

    final jsonResponse =
        await apiService.postRequest(context, ApiService.loadLogin, data);

    if (jsonResponse != null) {
      final response = LoadLoginResponse.fromJson(jsonResponse);

      if (response.code == '200') {
        setState(() {
          SharedPrefs().tanentId = response.data.tenantId;
          SharedPrefs().clientId = response.data.clientId;
          SharedPrefs().redirectURI = response.data.redirectUri;
          isLoginWithScan = response.data.isLoginWithScan;
          isLoginazureAd = response.data.isLoginazureAd;
          SharedPrefs().isLoginazureAd = response.data.isLoginazureAd;
          isLoginOptionsLoaded = true;
        });
      } else if (response.code == '401') {
        // Clean HTML tags and make email clickable via Linkify
        String cleanedMessage = response.message
            .join(', ')
            .replaceAll(RegExp(r"<[^>]*>"), '')
            .replaceAll("mailto:", "");

        setState(() {
          showErrorScreen = true;
          errorText = cleanedMessage.trim();
          isLoginOptionsLoaded = true;
        });
      } else {
        setState(() {
          isLoginWithScan = false;
          isLoginazureAd = false;
          isLoginOptionsLoaded = true;
        });
      }
    } else {
      setState(() {
        isLoginOptionsLoaded = true;
      });
    }
  }

  Future<void> _onOpenLink(LinkableElement link) async {
    final url = link.url;

    // Handle email links
    if (url.startsWith('mailto:')) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Fallback
        await launchUrl(Uri.parse('mailto:${url.replaceFirst('mailto:', '')}'));
      }
    } else {
      // Handle normal http/https links
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isUserNameError = usernameController.text.isEmpty;
        isPasswordError = passwordController.text.isEmpty;
        errorText = AppStrings.requiresValue;
      });
    }
  }

  // void loginUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final username = usernameController.text.trim();
  //   final password = passwordController.text.trim();
  //   String fcmToken = SharedPrefs().fcmToken;
  //   // log(fcmToken);
  //   if (checkedValue) {
  //     SharedPrefs().username = username;
  //     SharedPrefs().password = password;
  //   } else {
  //     SharedPrefs().username = '';
  //     SharedPrefs().password = '';
  //   }

  //   Map<String, dynamic> data = {
  //     'userid': username,
  //     'password': password,
  //     'fcmtoken': fcmToken,
  //     'platform': devicePlatform,
  //     'device_id': deviceId,
  //   };

  //   final jsonResponse =
  //       await apiService.postRequest(context, ApiService.login, data);

  //   if (jsonResponse != null) {
  //     final response = LoginResponse.fromJson(jsonResponse);
  //     if (response.code == '200') {
  //       // Save user data
  //       SharedPrefs().displayUserName = response.data.username;
  //       SharedPrefs().uID = response.data.uid;
  //       SharedPrefs().jwtToken = response.data.jwttoken;
  //       SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
  //       SharedPrefs().userSession = response.data.userSession;

  //       // Save credentials for biometric login
  //       SharedPrefs().username = username;
  //       SharedPrefs().password = password;

  //       await BiometricAuth().setBiometricAuthId(response.data.username);

  //       // Check if biometrics are available but not enabled
  //       if (biometricAvailable && !biometricEnabled && !hasSeenPrompt) {
  //         SharedPrefs().hasSeenBiometricPrompt = true;

  //         showBiometricEnableDialog(context);
  //       } else {
  //         navigateToScreen(context, HomeView());
  //       }
  //     } else {
  //       isPasswordError = true;
  //       errorText = response.message.join(', ');
  //     }
  //   }

  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // fetch the current FCM token from Firebase
    String? currentToken = await FirebaseMessaging.instance.getToken();

    //  Get the saved token from SharedPrefs
    String? savedToken = SharedPrefs().fcmToken;

    // If token is missing or changed, update SharedPrefs
    if (currentToken != null && currentToken.isNotEmpty) {
      if (savedToken != currentToken) {
        LoggerData.dataLog("Token changed or expired. Updating backend");
        SharedPrefs().fcmToken = currentToken;
      }
    } else {
      LoggerData.dataLog(" FCM token is null, trying to refresh");
      currentToken = await FirebaseMessaging.instance.getToken();
      if (currentToken != null) {
        SharedPrefs().fcmToken = currentToken;
      }
    }

    final fcmToken = SharedPrefs().fcmToken;
    final devicePlatform = SharedPrefs().devicePlatform;
    final deviceId = SharedPrefs().deviceId;

    if (checkedValue) {
      SharedPrefs().username = username;
      SharedPrefs().password = password;
    } else {
      SharedPrefs().username = '';
      SharedPrefs().password = '';
    }

    // Send login request
    Map<String, dynamic> data = {
      'userid': username,
      'password': password,
      'fcmtoken': fcmToken,
      'platform': devicePlatform,
      'device_id': deviceId,
      'apptype': AppConstants.apptype,
    };

    final jsonResponse =
        await apiService.postRequest(context, ApiService.login, data);

    if (jsonResponse != null) {
      final response = LoginResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        // Save user data
        SharedPrefs().displayUserName = response.data.username;
        SharedPrefs().uID = response.data.uid;
        SharedPrefs().jwtToken = response.data.jwttoken;
        SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
        SharedPrefs().userSession = response.data.userSession;
        // Set login status
        SharedPrefs().isLoggedIn = true;
        // Save credentials for biometric login
        SharedPrefs().username = username;
        SharedPrefs().password = password;

        // Check if we have pending notification to handle after login
        if (widget.notificationData != null) {
          _handlePendingNotificationAfterLogin();
        } else {
          // Check if biometrics are available but not enabled
          if (biometricAvailable && !biometricEnabled && !hasSeenPrompt) {
            SharedPrefs().hasSeenBiometricPrompt = true;
            showBiometricEnableDialog(context);
          } else {
            navigateToScreen(context, HomeView());
          }
        }
      } else {
        isPasswordError = true;
        errorText = response.message.join(', ');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _handlePendingNotificationAfterLogin() {
    final data = widget.notificationData!;
    final action = data['action'];
    final idStr = data['orderId'] ?? data['requestId'];
    final id = int.tryParse(idStr ?? '');

    if (id != null) {
      if (action == 'order') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailsView(orderId: id),
          ),
          (route) => false,
        );
      } else if (action == 'request') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDashboard(notificationData: data),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDashboard(notificationData: data),
          ),
          (route) => false,
        );
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => NotificationDashboard(notificationData: data),
        ),
        (route) => false,
      );
    }
  }

  Future attemptBiometricLogin() async {
    setState(() {
      isLoading = true;
    });

    final biometricAuth = BiometricAuth();

    // Check if biometrics are enabled (user opted-in before)
    if (!await biometricAuth.checkBiometrics()) {
      setState(() {
        isLoading = false;
      });
      globalUtils.showNegativeSnackBar(
          context: context, message: "Biometric authentication not set up.");
      return;
    }

    // Attempt authentication with either Fingerprint or Face ID
    bool isAuthenticated = await biometricAuth.authenticate();

    if (isAuthenticated) {
      final username = SharedPrefs().username;
      final password = SharedPrefs().password;

      if (username.isNotEmpty && password.isNotEmpty) {
        loginWithStoredCredentials(username, password);
      } else {
        globalUtils.showNegativeSnackBar(
            context: context, message: "Stored credentials not found.");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      globalUtils.showNegativeSnackBar(
          context: context, message: "Biometric authentication failed.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void loginWithStoredCredentials(String username, String password) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'userid': username,
      'password': password,
    };

    final jsonResponse =
        await apiService.postRequest(context, ApiService.login, data);

    if (jsonResponse != null) {
      final response = LoginResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        SharedPrefs().displayUserName = response.data.username;
        SharedPrefs().uID = response.data.uid;
        SharedPrefs().jwtToken = response.data.jwttoken;
        SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
        SharedPrefs().userSession = response.data.userSession;
        SharedPrefs().isLoggedIn = true;

        // Handle pending notification after biometric login
        if (widget.notificationData != null) {
          _handlePendingNotificationAfterLogin();
        } else {
          navigateToScreen(context, HomeView());
        }
      } else {
        globalUtils.showNegativeSnackBar(
            context: context, message: response.message.join(', '));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void clearCompanyCode() {
    SharedPrefs().companyCode = '';
    SharedPrefs().username = '';
    SharedPrefs().password = '';
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.companyCodeRoute, (Route<dynamic> route) => false);
  }

  void showClearCompanyCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomImageActionAlert(
            iconString: '',
            imageString: ImageAssets.clearCompanyCodeImage,
            titleString: AppStrings.clearCompanyCodeTitle,
            subTitleString: AppStrings.clearCompanyCodeSubTitle,
            destructiveActionString: AppStrings.yes,
            normalActionString: AppStrings.no,
            onDestructiveActionTap: () {
              clearCompanyCode();
            },
            onNormalActionTap: () {
              Navigator.pop(context);
            });
      },
    );
  }

  void showBiometricEnableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomImageActionAlert(
          iconString: '',
          imageString: ImageAssets.biometricEnableDialogImage,
          titleString: 'Quick Login with Biometrics',
          subTitleString:
              'Do you want to enable biometric authentication for quicker logins in the future?',
          destructiveActionString: AppStrings.yes,
          normalActionString: AppStrings.no,
          onDestructiveActionTap: () async {
            Navigator.pop(dialogContext);
            await BiometricAuth().enableBiometric();
            navigateToScreen(context, HomeView());
          },
          onNormalActionTap: () {
            Navigator.pop(dialogContext);
            navigateToScreen(context, HomeView());
          },
        );
      },
    );
  }

  void _onUserNameTextChange() {
    if (userNameText != AppStrings.userID) {
      setState(() {
        isUserNameError = usernameController.text.trim().isEmpty;
      });
    }
    userNameText = usernameController.text.trim();
  }

  void _onPasswordTextChange() {
    if (passwordText != AppStrings.password) {
      setState(() {
        isPasswordError = passwordController.text.trim().isEmpty;
      });
    }
    passwordText = passwordController.text.trim();
    errorText = AppStrings.requiresValue;
  }

  Future<void> scanBarcode() async {
    try {
      ScanResult barcodeScanResult = await BarcodeScanner.scan();
      String resultString = barcodeScanResult.rawContent;
      if (resultString.isNotEmpty && resultString != "-1") {
        Map<String, dynamic> jsonDict = jsonDecode(resultString);
        loginWithScan(jsonDict['uid']);
      }
    } catch (e) {
      setState(() {
        errorText = "Failed to scan";
      });
    }
  }

  void loginWithScan(int userId) async {
    SharedPrefs().username = '';
    SharedPrefs().password = '';
    setState(() {
      isLoadingForScan = true;
    });

    Map<String, dynamic> data = {
      'uid': '$userId',
      'mode': 'scan',
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.externalLogin, data);

    if (jsonResponse != null) {
      final response = LoginResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          SharedPrefs().displayUserName = response.data.username;
          SharedPrefs().uID = response.data.uid;
          SharedPrefs().jwtToken = response.data.jwttoken;
          SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
          SharedPrefs().userSession = response.data.userSession;
          navigateToScreen(context, HomeView());
        } else {
          isPasswordError = true;
          errorText = response.message.join(', ');
        }
      });
    }
    setState(() {
      isLoadingForScan = false;
    });
  }

  void loginWithAzureAD() async {
    setState(() {
      isLoadingForAzureAD = true;
      debugPrint("isLoadingForAzureAD: $isLoadingForAzureAD");
    });

    final token = await AzureAuthService.login();

    if (token != null) {
      debugPrint("Login Success. Token: $token");
      if (mounted) {
        await fetchAzureUserDetails(token);
      }
    } else {
      if (mounted) {
        globalUtils.showNegativeSnackBar(
            context: context, message: "Azure login failed");
      }
    }

    setState(() {
      isLoadingForAzureAD = false;
      debugPrint("isLoadingForAzureAD: $isLoadingForAzureAD");
    });
  }

  Future<void> fetchAzureUserDetails(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    //  debugPrint("########################################################");
    //debugPrint(decodedToken.toString());
    // debugPrint("########################################################");

    String? email = decodedToken["unique_name"]; // "email"
    // String? email = "abc@eyvo.com";
    if (email != null) {
      loginWithAsureSSO(email); // here’s where you pass the email
    } else {
      debugPrint("No email found in token.");
      if (mounted) {
        globalUtils.showNegativeSnackBar(
            context: context, message: "No email found in Azure token");
      }
    }
  }

  void loginWithAsureSSO(String email) async {
    debugPrint("Starting SSO login with email: $email");
    SharedPrefs().username = '';
    SharedPrefs().password = '';
    setState(() {
      isLoadingForScan = true;
    });

    Map<String, dynamic> data = {
      'email': email,
      'mode': 'sso',
    };

    final jsonResponse =
        await apiService.postRequest(context, ApiService.externalLogin, data);

    debugPrint("Raw response: $jsonResponse");

    if (jsonResponse != null) {
      final response = LoginResponse.fromJson(jsonResponse);

      if (response.code == '200') {
        debugPrint(" SSO Login successful for UID: ${response.data.uid}");
        SharedPrefs().displayUserName = response.data.username;
        SharedPrefs().uID = response.data.uid;
        SharedPrefs().jwtToken = response.data.jwttoken;
        SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
        SharedPrefs().userSession = response.data.userSession;
        // debugPrint(
        //     " ###############################: ${response.data.username}");
        navigateToScreen(context, HomeView());
      } else {
        //Show proper message from backend
        setState(() {
          isPasswordError = true;
          errorText = response.message.join(', ');
        });
        debugPrint(" Login failed: $errorText");

        if (mounted) {
          globalUtils.showNegativeSnackBar(
              context: context, message: "SSO Login failed: $errorText");
        }
      }
    } else {
      debugPrint(" No response from server.");
      if (mounted) {
        globalUtils.showNegativeSnackBar(
            context: context, message: "No response from login server");
      }
    }

    setState(() {
      isLoadingForScan = false;
    });
  }

  Widget buildCompanyCodeRow(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.companyCodeDetail,
            style: getRegularStyle(
              color: ColorManager.black,
              fontSize: FontSize.s22_5,
            ),
          ),
          GestureDetector(
            onTap: () {
              showClearCompanyCodeDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DashedLineText(
                titleString: SharedPrefs().companyCode,
                titleStyle: getDottedUnderlineSemiBoldStyle(
                  color: ColorManager.orange,
                  lineColor: ColorManager.lightGrey1,
                  fontSize: FontSize.s22_5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoginOptionsLoaded && !_hasBiometricTriggered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hasBiometricTriggered = true;
        if (BiometricAuth().isBiometricEnabled()) {
          attemptBiometricLogin();
        } else {
          setState(() {
            showFullLoginForm = true;
          });
        }
      });
    }

    // Still show a loader if login options aren't ready
    if (!isLoginOptionsLoaded) {
      return Scaffold(
        backgroundColor: ColorManager.white,
        body: const Center(child: CustomProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: ColorManager.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => {SystemNavigator.pop()},
        child: GestureDetector(
          onTap: onScreenTapped,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                const HeaderLogo(),
                const SizedBox(height: 20),
                _buildLoginForm(),
                const SizedBox(height: 10),
                if (biometricAvailable && biometricEnabled && !showErrorScreen)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: isAuthenticating
                        ? const Center(child: CustomProgressIndicator())
                        : Center(
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isAuthenticating = true;
                                  authFailed = false;
                                });

                                try {
                                  final success =
                                      await BiometricAuth().authenticate();
                                  if (context.mounted && success == true) {
                                    navigateToScreen(context, HomeView());
                                  } else {
                                    setState(() {
                                      isAuthenticating = false;
                                      authFailed = true;
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    authFailed = true;
                                    isAuthenticating = false;
                                  });
                                }
                              },
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: ColorManager.darkBlue, width: 1),
                                ),
                                child: Icon(Icons.fingerprint,
                                    size: 40, color: ColorManager.darkBlue),
                              ),
                            ),
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Method to handle the screen tap and count the number of taps
  void onScreenTapped() {
    setState(() {
      tapCount++;
      if (tapCount >= 5) {
        isLoginazureAd = false;
      }
    });
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: SizedBox(
        child: showErrorScreen
            // === 401 ERROR SCREEN ===
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  buildCompanyCodeRow(context),
                  const SizedBox(height: 40),
                  Image.asset(
                    ImageAssets.errorMessageIcon,
                    width: displayWidth(context) * 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Linkify(
                      onOpen: _onOpenLink,
                      text: errorText,
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                        color: ColorManager.lightGrey,
                        fontSize: FontSize.s17,
                      ),
                      linkStyle: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: displayWidth(context) * 0.95,
                    child: CustomButton(
                      buttonText: "Back",
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.companyCodeRoute,
                            (Route<dynamic> route) => false);
                        setState(() {
                          showErrorScreen = false;
                          isError = false;
                          errorText = "";
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              )

            // === NORMAL LOGIN FORM ===
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Logic to conditionally show/hide the login form based on isLoginazureAd and tap count
                  (isLoginazureAd && tapCount < 5)
                      ? Column(
                          children: [
                            const SizedBox(height: 140),
                            buildCompanyCodeRow(context),
                            const SizedBox(height: 40),
                            CustomButton(
                              buttonText: "Login with URBN SSO",
                              leading: SizedBox(
                                width: 30,
                                height: 30,
                                child: Image.asset(ImageAssets.ssoIcon),
                              ),
                              onTap: loginWithAzureAD,
                              isDefault: true,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            buildCompanyCodeRow(context),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: displayWidth(context),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  CustomTextButton(
                                    buttonText: AppStrings.forgotUserID,
                                    onTap: () {
                                      navigateToScreen(
                                          context, const ForgotUserIDView());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CustomTextField(
                              iconString: ImageAssets.userIdIcon,
                              hintText: AppStrings.userID,
                              controller: usernameController,
                              isValid: !isUserNameError,
                              onTextChanged: validateFields,
                            ),
                            isUserNameError
                                ? const ErrorTextViewBox()
                                : const SizedBox(),
                            isUserNameError
                                ? const SizedBox(height: 20)
                                : const SizedBox(),

                            // Forgot Password button and Password field
                            SizedBox(
                              width: displayWidth(context),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  CustomTextButton(
                                    buttonText: AppStrings.forgotPassword,
                                    onTap: () {
                                      navigateToScreen(
                                          context, const ForgotPasswordView());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CustomTextField(
                              iconString: ImageAssets.passwordIcon,
                              hintText: AppStrings.password,
                              controller: passwordController,
                              isObscureText: true,
                              isValid: !isPasswordError,
                              onTextChanged: validateFields,
                            ),
                            isPasswordError
                                ? ErrorTextViewBox(titleString: errorText)
                                : const SizedBox(),
                            isPasswordError
                                ? const SizedBox(height: 20)
                                : const SizedBox(),

                            // Remember me checkbox
                            CustomCheckboxListTile(
                              title: Text(
                                AppStrings.rememberMe,
                                style: getRegularStyle(
                                    color: ColorManager.lightGrey1,
                                    fontSize: FontSize.s18),
                              ),
                              value: checkedValue,
                              onChanged: (value) {
                                setState(() {
                                  checkedValue = value!;
                                  SharedPrefs().isRememberMeSelected =
                                      checkedValue;
                                });
                              },
                            ),
                            const SizedBox(height: 50),

                            // Sign In Button
                            isLoading
                                ? const CustomProgressIndicator()
                                : CustomButton(
                                    buttonText: AppStrings.signIn,
                                    onTap: () {
                                      isFormValidated = true;
                                      validateFields();
                                      if (!isUserNameError &&
                                          !isPasswordError) {
                                        loginUser();
                                      }
                                    },
                                  ),
                            const SizedBox(height: 30),
                            // Logic to check if loginWithScan is true
                            isLoginWithScan
                                ? const SizedBox(height: 10)
                                : const SizedBox(),
                            //const OrDivider(),
                            isLoginWithScan
                                ? Column(
                                    children: [
                                      const OrDivider(),
                                      const SizedBox(height: 20),
                                      isLoadingForScan
                                          ? const CustomProgressIndicator()
                                          : CustomButton(
                                              buttonText:
                                                  AppStrings.loginWithBarcode,
                                              onTap: () {
                                                scanBarcode();
                                              },
                                              isDefault: true),
                                      const SizedBox(height: 30),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),

                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
