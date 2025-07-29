import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_input_field.dart';
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final api = ApiService();
    final token = await api.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    setState(() {
      isLoading = false;
    });
    if (token != null) {
      // Stocker le token JWT
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      Navigator.pushReplacementNamed(context, AppRoutes.bloodDonationMenuScreen);
    } else {
      setState(() {
        errorMessage = "Identifiants invalides. Veuillez réessayer.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              width: 375.h,
              constraints: BoxConstraints(minHeight: 766.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackNavigation(context),
                  _buildLoginForm(context),
                  if (errorMessage != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 8),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (isLoading)
                    Center(child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    )),
                  _buildOrDivider(),
                  _buildSocialLoginSection(context),
                  _buildCreateAccountLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackNavigation(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 57.h, left: 20.h),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: 14.h,
          height: 13.h,
          child: Stack(
            children: [
              Positioned(
                top: 7.h,
                left: 0,
                child: CustomImageView(
                  imagePath: ImageConstant.imgVector,
                  width: 14.h,
                  height: 2.h,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: CustomImageView(
                  imagePath: ImageConstant.imgArrowleft,
                  width: 7.h,
                  height: 13.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 21.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 62.h),
          Text(
            'Email',
            style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
          ),
          SizedBox(height: 13.h),
          CustomInputField(
            controller: emailController,
            hintText: 'example@gmail.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 13.h),
          Text(
            'Password',
            style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
          ),
          SizedBox(height: 13.h),
          CustomInputField(
            controller: passwordController,
            hintText: 'Password',
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          SizedBox(height: 31.h),
          Container(
            margin: EdgeInsets.only(left: 51.h),
            child: GestureDetector(
              onTap: () {
                // Handle forgot password
                print('Forgot password tapped');
              },
              child: Text(
                'Mot de passe oublié?',
                style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          CustomButton(
            text: 'Se connecter',
            onPressed: isLoading ? null : () => _login(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Container(
      margin: EdgeInsets.only(top: 72.h),
      child: Center(
        child: Text(
          'Ou',
          style: TextStyleHelper.instance.headline25.copyWith(height: 1.28),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 54.h, left: 9.h, right: 9.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Handle Google login
                print('Google login tapped');
              },
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: appTheme.colorFF8808,
                  borderRadius: BorderRadius.circular(5.h),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.blackCustom,
                      offset: Offset(8, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 2.h),
                      width: 54.h,
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: appTheme.whiteCustom,
                        borderRadius: BorderRadius.circular(5.h),
                      ),
                      child: Center(
                        child: CustomImageView(
                          imagePath: ImageConstant.imgIcons8google2401,
                          width: 31.h,
                          height: 26.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.h),
                    Expanded(
                      child: Text(
                        'Connectez vous avec google',
                        style: TextStyleHelper.instance.title16
                            .copyWith(height: 1.25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10.h),
          GestureDetector(
            onTap: () {
              // Handle Facebook login
              print('Facebook login tapped');
            },
            child: Container(
              width: 52.h,
              height: 43.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.h),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF90BCFE),
                    appTheme.color99ECEC,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.whiteCustom,
                    offset: Offset(-10, -10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 37.h,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: appTheme.colorCC0061,
                    borderRadius: BorderRadius.circular(18.h),
                  ),
                  child: Center(
                    child: CustomImageView(
                      imagePath: ImageConstant.imgF,
                      width: 12.h,
                      height: 15.h,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountLink(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 35.h),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.accountRegistrationScreen);
          },
          child: Text(
            'Créer un compte ?',
            style: TextStyleHelper.instance.title20
                .copyWith(color: appTheme.colorC90202, height: 1.25),
          ),
        ),
      ),
    );
  }
}
