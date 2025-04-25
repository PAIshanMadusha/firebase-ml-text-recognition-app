# 🤖 Firebase ML Text Recognition App

A Flutter application that uses **Firebase Machine Learning Kit** for **text recognition** from images. Users can capture or upload images through the app to extract text using Firebase ML Kit. Additionally, a **premium feature** allows users to view their previously captured text, enabled via **Stripe-powered subscription payments**.

---

## ✨ Features:

### 📸 Text Recognition:
- Select an image from the gallery or take a new photo.
- Detect and extract text using Google Machine Learning Kit's Text Recognition.
- Copy captured text to the clipboard easily.

### 📝 Captured History (Premium):
- Premium users can view previously captured text alongside images.
- Each user's data is stored privately using Firebase.

### 💳 Stripe Integration:
- Monthly recurring subscriptions using the **Stripe API**.
- Users can upgrade to premium and unlock additional features.

### 👤 Anonymous Authentication:
- Firebase Auth is used to generate a unique anonymous user ID.
- User data (including captures) are stored per user in Firestore.

### 🔐 Secure Storage:
- Images stored in **Firebase Storage**.
- Captured text stored in **Cloud Firestore** linked to user IDs.

### 🎨 UI Enhancements:
- Splash screen animation using **Lottie**.
- Clean UI design with **Google Fonts** and **SVG assets**.

### 📡 Stripe API Endpoints Used:

The following [Stripe API](https://docs.stripe.com/api) endpoints were used to implement subscription-based payments:

| Purpose                                            | Endpoint                                                            |
|----------------------------------------------------|---------------------------------------------------------------------|
| ✅ Create a new customer on Stripe                 | `https://api.stripe.com/v1/customers`                              |
| ✅ Prepare to collect payment details              | `https://api.stripe.com/v1/setup_intents`                          |
| ✅ Attach a payment method to a specific customer  | `https://api.stripe.com/v1/customers/[customerId]/payment_methods` |
| ✅ Create a subscription for a customer            | `https://api.stripe.com/v1/subscriptions`                          |

---

## 🛠️ Technologies Used:
The following core technologies are used in this project:

- **Flutter** : UI toolkit for building natively compiled applications for mobile.
- **Dart** : Programming language used with Flutter.
- **Firebase ML Kit** : For on-device text recognition (Optical Character Recognition (OCR)).
- **Firebase Authentication** : Anonymous authentication to track user data securely.
- **Cloud Firestore** : NoSQL cloud database to store captured text and metadata.
- **Firebase Storage** : To store captured images securely.
- **Stripe API** : Handles payment processing and subscriptions.

---

## 🛠 Dependencies:
The following technologies are used in this project:

| Package                        | Description                                      |
|--------------------------------|--------------------------------------------------|
| firebase_core                  | Firebase core initialization                     |
| firebase_auth                  | Anonymous authentication                         |
| firebase_storage               | Store captured images                            |
| cloud_firestore                | Store captured text and metadata                 |
| image_picker                   | Pick images from gallery or camera               |
| google_mlkit_text_recognition  | ML text recognition from images                  |
| google_fonts                   | Custom fonts integration                         |
| flutter_stripe                 | Stripe API integration for subscription handling |
| flutter_dotenv                 | Load environment variables (e.g., API keys)      |
| http                           | HTTP client for Stripe API requests              |
| provider                       | State management (e.g., premium status)          |
| flutter_svg                    | SVG image rendering                              |
| lottie                         | Splash screen animation                          |

---

## 🚀 How to Run the Project:
1. Clone the repository:

```sh
https://github.com/PAIshanMadusha/firebase-ml-text-recognition-app.git
```
2. Navigate to the project directory:

```sh
cd firebase-ml-text-recognition-app
```
3. Install dependencies:

```sh
flutter pub get
```
## 📥 Set up Firebase:
   
### 📝 To use Firebase services in this project, follow these steps:

- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
- After creating your Firebase project, you need to configure the following services, Go to the **Build** section in Firebase and:
- Enable [**Authentication**](https://github.com/PAIshanMadusha/basic-firebase-authentication.git) → **Sign-in method** → **Anonymous**.
- Enable **Cloud Firestore** (start in **test mode** for development).
- Enable **Firebase Storage** (also start in **test mode**).
- Enable **Machine Learning** → **Text Recognition**.
- Then, connect your Flutter project to Firebase.
- For this project, I used the FlutterFire CLI to do that. You should follow the same process to avoid errors.
  
### ⚠️ Not familiar with the FlutterFire CLI?

- I’ve written a detailed [Medium](https://medium.com/@ishanmadusha) article explaining the step-by-step process to connect Firebase to Flutter using the CLI with screenshots to guide 
  you through it. **📖 Read my article on Medium here:** [Link](https://medium.com/@ishanmadusha/using-firebase-cli-to-easily-connect-firebase-with-your-flutter-app-927e0021bc44)
- So, follow the above steps and add Firebase to your Flutter project using the FlutterFire CLI.

## 💳 Configure Stripe:

To enable premium features in the app, Stripe is used to handle subscription payments. Follow these steps to configure Stripe:

### 🔧 Create a Stripe Account:
- Go to [Stripe](https://stripe.com/) and create an account if you don't have one, and select test mode.

### 🔐 Get Your Stripe API Keys:
- Navigate to your Stripe Dashboard → **Developers → API Keys**
- Copy your **Publishable key** and **Secret key**

### ⚙️ Set Up Environment Variables:
- Create a `.env` file in the root directory of your Flutter project.
- Add your Stripe keys:
```env
SECRET_KEY = "[Your-Secret-Key]"
PUBLISHABLE_KEY ="[Your-Publishable-Key]"
```
- Replace `[Your-...-Keys]` with your actual API keys from Stripe.

### ⚠️ Important:

- The `priceId` used in this project (`price_1REmVySHefmHhg9lhKnukC5O`) is specific to the original developer’s Stripe account.  
- It appears in the following file and lines:
  - `\lib\services\stripe\stripe_service.dart` → **Line 58** and **Line 136**
- If you're cloning or reusing this project, **you must create your own Stripe product and price**, and **replace this ID** with your own.

### 🛠️ How to Create Your Own Stripe Price ID:

- Go to your Stripe Dashboard.
- On the left sidebar, click **Product Catalog**.
- Click **+ Add product**.
- Fill in the **required product details** (name, description, etc.).
- Under **Pricing**, choose **Recurring** and set your amount and interval (e.g., monthly).
- Click **Add product** to save.
- After the product is created, click on it to view the **Price ID**.
- Copy the Price ID and replace the hardcoded one at **Line 58** and **Line 136** in `stripe_service.dart`.

### ✅ Now you can run the app. Make sure there are no errors:
   ```bash
   flutter run
   ```

## 📸 System Screenshots:

---

<p align="center">
  <img src="https://github.com/user-attachments/assets/5af38ec8-764a-410e-bbac-92e59dd6477e" alt="Screenshot 1" width="175">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/d535eed7-cffb-403a-8ee6-cfc66e302f9e" alt="Screenshot 2" width="175">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/051a3eb8-13ed-470f-99b2-489303330a57" alt="Screenshot 3" width="175">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<br>
<p align="center">
  <img src="https://github.com/user-attachments/assets/5123989a-0ee1-4a34-a22d-da96db9fdd9e" alt="Screenshot 1" width="175">&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/6eecb4a8-588b-4d4e-b794-22bbc9237905" alt="Screenshot 2" width="175">&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/b0b1a0b5-fd79-438f-97a1-b8c424f4583e" alt="Screenshot 3" width="175">&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/a076e324-7d0f-4e0e-bf07-1f4410a4c8d3" alt="Screenshot 4" width="175">&nbsp;&nbsp;&nbsp;
</p>

---

## 👤 About This Project:

A Flutter app that uses Firebase ML Kit to extract text from images, with a premium feature (via Stripe subscription) to view captured history, built to enhance my Flutter and Firebase skills.

### 👨‍💻 Created by: 
**Ishan Madhusha**  
GitHub: [PAIshanMadusha](https://github.com/PAIshanMadusha)

Feel free to explore my work and get in touch if you'd like to collaborate! 🚀

---

## 📝 License:  
This project is open-source and available under the MIT License.
