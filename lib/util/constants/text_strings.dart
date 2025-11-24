import 'package:dineswift_management/features/system_configuration/models/restaurant_table.dart';

class DineSwiftTextStrings {
  // splash screen texts
  static const String appName = "DineSwift";

  //sidebar texts
  static const String dashboard = "Dashboard";
  static const String inventoryAndSupplies = "Inventory & Supplies";
  static const String operationsAndDispatch = "Operations & Dispatch";
  static const String loyaltyProgram = "Loyalty Program";
  static const String customerCommunication = "Customer Communication";
  static const String analyticsAndReports = "Analytics & Reports";
  static const String systemConfiguration = "System Configuration";

  // onboarding texts
  static const String onboardingTitle1 = "Scan & Select Your Food";
  static const String onboardingTitle2 = "Secure & Easy Payment";
  static const String onboardingTitle3 = "Fast & Reliable Delivery";

  static const String onboardingSubTitle1 =
      "Browse through our extensive menu, scan the QR code at your table, and effortlessly select your favorite dishes with just a few taps.";
  static const String onboardingSubTitle2 =
      "Choose from a variety of secure and convenient payment options, ensuring a seamless checkout experience tailored to your preferences.";
  static const String onboardingSubTitle3 =
      "Sit back and relax as we bring your delicious order straight to your doorstep, ensuring a hassle-free dining experience from start to finish.";

  // --Home
  static const String homeAppbarTitle = appName;
  static const String homeAppbarSubTitle =
      "Delivering Delight to Your Doorstep";

  // Authentication Form Text
  static const String email = "E-Mail";
  static const String emailHint = "Email address";
  static const String password = "Password";
  static const String passwordHint = 'Password';
  static const String repeatPasswordHint = "Repeat your password";
  static const String userName = "Username";
  static const String userNameHint = "Enter your username";
  static const String phoneNo = "Phone Number";
  static const String rememberMe = "Remember Me";
  static const String forgotPassword = "Forgot Password?";
  static const String signIn = "Sign In";
  static const String signUp = "Sign Up";
  static const String alreadyRegistered = "Iam already memeber";
  static const String dontHaveAnAccount = "I don't have an account";
  static const String register = "Register";
  static const String registering = "Registering...";
  static const String createAccount = "Create an Account";
  static const String orSignInWith = "or sign in with";
  static const String orSignUpWith = "or sign up with";
  static const String agreeTo = "I agree to, ";
  static const String privacyPolicy = "Privacy Policy";
  static const String termsOfUse = "Terms of Use";
  static const String verificationCode = "Verification Code";
  static const String resendEmail = "Resend Email";
  static const String resendEmailIn = "Resend Email In";
  static const String submit = "Submit";
  static const String and = "&";
  static const String isLogging = "Logging...";

  // Authentication Reading Texts
  static const String loginTitle = "Sign In";
  static const String loginSubTitle =
      "Discover Limitless Choices and Unmatched Convenience";
  static const String signupTitle = "Let's Create Your Account";
  static const String forgetPasswordTitle = "Forget Password";
  static const String forgetPasswordSubTitle =
      "Don't worry sometimes people can forget too, enter your email and we will send you a password reset link.";
  static const String changeYourPasswordTitle = "Password Reset Email Sent";
  static const String changeYourPasswordSubTitle =
      "Your Account Security is Our Priority! We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.";
  static const String confirmEmail = "Verify your email address!";
  static const String confirmEmailSubTitle =
      "Congratulations! Your Account Awaits: Verify Your Email to Start Shopping and Experience a World of Unrivaled Deals and Personalized Offers.";
  static const String emailNotReceivedMessage =
      "Didn't get the email? Check your junk/spam or resend it.";
  static const String yourAccountCreatedTitle =
      "Your account successfully created!";
  static const String yourAccountCreatedSubTitle =
      "Welcome to the world of Limitless Choices: Your Account is Created, Unleash the Joy of Seamless Online Shopping!";

  // QR Code Generation Texts
  static const String generateQRCodeTitle = 'Generate Table QR Code';
  static const String createNewTable = 'Create New Table';
  static const String tableCreationDescription = 'Fill in the table details to generate a unique QR code';
  static const String tableNumberLabel = 'Table Number ';
  static const String tableNumberHint = 'e.g., Table 5, Booth 2, Patio 1';
  static const String capacityLabel = 'Capacity ';
  static const String capacityHint = 'e.g., 4';
  static const String tableStatusLabel = 'Table Status';
  static const String generateQRCodeButton = 'Generate QR Code';
  static const String generating = 'Generating...';
  static const String qrGeneratedFor = 'QR code has been generated for ';
  static const String people = ' people';
  static const String capacity = 'Capacity: ';
  // Success Messages
  static const String tableCreatedSuccess = 'Table created and QR code generated successfully!';
  static const String tableCreatedSuccessTitle = 'Table Created Successfully!';
  static const String qrCodeDownloaded = 'QR Code downloaded!';
  static const String qrCodeDataCopied = 'QR Code data copied to clipboard!';

  // Error Messages
  static const String errorGeneratingTable = 'Error generating table: ';
  static const String errorSavingQRCode = 'Error saving QR code: ';

  // Validation Messages
  static const String pleaseEnterTableNumber = 'Please enter a table number';
  static const String pleaseEnterCapacity = 'Please enter table capacity';
  static const String pleaseEnterValidCapacity =
      'Please enter a valid capacity';

  // QR Code Display
  static const String scanToAccess = 'Scan to Access ';
  static const String capacityPeople = ' people';
  static const String copyData = 'Copy Data';
  static const String saveQRCode = 'Save QR Code';
  static const String createAnotherTable = 'Create Another Table';
  static const String downloadQRCode = 'Download QR Code';

  // table status options
  static String formatTableStatus(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.reserved:
        return 'Reserved';
      case TableStatus.cleaning:
        return 'Cleaning';
      case TableStatus.maintenance:
        return 'Maintenance';
    }
  }

  // profile screen
  static const String profile = 'Profile';
  static const String logout = 'Logout';
  static const String changePassword = 'Change Password';
}
