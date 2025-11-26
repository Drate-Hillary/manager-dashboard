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
  static const String pleaseEnterValidCapacity = 'Please enter a valid capacity';

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

  // forgot password screen text
  static const String forgotPasswordTitle = "Forgot Password?";
  static const String forgotPasswordSubTitle = "Enter the Employee ID or email associated with your account to reset your password.";
  static const String employeeIdOrEmail = "Employee ID or Email Address";
  static const String employeeIdOrEmailHint = "Enter your employee ID or email address";
  static const String continueButton = "Continue";
  static const String backToLogin = "Back to Login";


  // AddMenu Screen
  static const String addNewMenu = 'Add New Menu';
  static const String editMenu = 'Edit: ';
  static const String addNewItem = 'Add New Item';
  static const String menuDetails = 'Menu Details';
  static const String menuImage = 'Menu Image';
  static const String tapToAddMenuImage = 'Tap to add menu image';
  static const String menuName = 'Menu Name';
  static const String description = 'Description';
  static const String menuIsActive = 'Menu is Active';
  static const String menuActiveDescription = 'If active, the menu will be visible to customers.';
  static const String menuItems = 'Menu Items';
  static const String noItemsAddedYet = 'No items added yet';
  static const String tapToAddFirstItem = 'Tap the + button to add your first item';
  static const String saveItem = 'Save Item';
  static const String savingMenu = 'Saving menu...';
  static const String menuSavedSuccessfully = 'Menu saved successfully!';
  static const String error = 'Error: ';

  // MenuItemEditorModal
  static const String editItem = 'Edit Item';
  static const String addNewItemModal = 'Add New Item';
  static const String itemImage = 'Item Image';
  static const String addPhoto = 'Add Photo';
  static const String itemName = 'Item Name';
  static const String itemDescription = 'Item Description';
  static const String price = 'Price';
  static const String prepTime = 'Prep Time';
  static const String minutes = 'min';
  static const String department = 'Department';
  static const String isAvailable = 'Is Available';
  static const String requiredField = 'Required';

  // Image Picker
  static const String chooseImageSource = 'Choose Image Source';
  static const String gallery = 'Gallery';
  static const String camera = 'Camera';

  // Delete Confirmation
  static const String deleteItem = 'Delete Item';
  static const String deleteConfirmation = 'Are you sure you want to delete this menu item?';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';


  // Restaurant Registration
  // App Bar
  static const String registerRestaurantTitle = 'Register New Restaurant';

  // Core Details Section
  static const String coreDetailsHeader = 'Core Details';
  static const String restaurantName = 'Restaurant Name';
  static const String cuisineType = 'Cuisine Type';
  static const String cuisineTypeHint = 'e.g. Italian';

  // Address Section
  static const String addressHeader = 'Address';
  static const String streetAddress = 'Street Address';
  static const String city = 'City';
  static const String country = 'Country';
  static const String latitude = 'Latitude';
  static const String longitude = 'Longitude';
  static const String useCurrentLocation = 'Use Current Location';
  static const String fetchingLocation = 'Fetching Location...';

  // Contact Information Section
  static const String contactInfoHeader = 'Contact Information';
  static const String phoneNumber = 'Phone Number';
  static const String emailAddress = 'Email Address';

  // Operations Section
  static const String operationsHeader = 'Operations';
  static const String status = 'Status';
  static const String avgDeliveryTime = 'Avg. Delivery Time (mins)';
  static const String operationHours = 'Operation Hours';
  static const String operationHoursHint = '{"Mon": "9-5", "Tue": "9-5"}';
  static const String deliveryOptions = 'Delivery Options';
  static const String deliveryOptionsHint = '{"fee": 5.0, "min_order": 20.0}';

  // Additional Information Section
  static const String additionalInfoHeader = 'Additional Information';
  static const String paymentMethods = 'Payment Methods';
  static const String paymentMethodsHint = '["card", "cash", "mobile_money"]';
  static const String socialMediaLinks = 'Social Media Links';
  static const String socialMediaLinksHint = '{"twitter": "...", "facebook": "..."}';

  // Buttons
  static const String registerRestaurantButton = 'Register Restaurant';

  // Validation Messages
  static const String nameRequired = 'Name is required';
  static const String streetRequired = 'Street is required';
  static const String cityRequired = 'City is required';
  static const String countryRequired = 'Country is required';
  static const String mustBeNumber = 'Must be a number';
  static const String phoneRequired = 'Phone is required';
  static const String emailRequired = 'Email is required';
  static const String validEmail = 'Enter a valid email';
  static const String statusRequired = 'Status is required';
  static const String hoursRequired = 'Hours are required';
  static const String invalidJsonFormat = 'Invalid JSON format';

  // Toast Messages
  static const String fixFormErrors = 'Please fix the errors in the form.';
  static const String registeringRestaurant = 'Registering restaurant...';
  static const String restaurantRegistered = 'Restaurant registered successfully!';
  static const String locationPermissionsDenied = 'Location permissions are denied.';
  static const String locationPermissionsPermanentlyDenied = 'Location permissions are permanently denied, we cannot request permissions.';
  static const String locationFetched = 'Location fetched successfully!';
  static const String locationFailed = 'Failed to get location: ';

}

