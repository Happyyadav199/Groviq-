# Blinkit-style Flutter (WooCommerce) Starter Pack

This package contains the `lib/` source files, `.env.example` and instructions to quickly set up the Flutter app that connects to a WordPress + WooCommerce backend.

## What is included
- `lib/` — all Dart source files (screens, models, API wrapper, providers, main)
- `.env.example` — example environment file
- `pubspec_changes.txt` — dependencies to add to your project's `pubspec.yaml`

## Quick Setup (from scratch)

1. Install Flutter and tools. Verify with:
   ```
   flutter doctor
   ```

2. Create a new Flutter project:
   ```
   flutter create blinkit_mvp
   cd blinkit_mvp
   ```

3. Open the project in your editor (VS Code / Android Studio).

4. Replace the `lib/` folder in the Flutter project with the `lib/` folder from this package (copy contents).

5. Add the dependencies to `pubspec.yaml`:
   - Open `pubspec_changes.txt` for the exact dependencies block.
   - Update your `pubspec.yaml` `dependencies:` section accordingly, then run:
     ```
     flutter pub get
     ```

6. Create `.env` in the project root (same level as pubspec.yaml) by copying `.env.example` and filling your values:
   ```
   BASE_URL=https://your-domain.com
   WC_KEY=ck_xxxxxxxxxxxxxxxxxxxxxxxxx
   WC_SECRET=cs_xxxxxxxxxxxxxxxxxxxxxx
   ```

7. Android permission: open `android/app/src/main/AndroidManifest.xml` and add:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
   inside the `<manifest>` tag (above `<application>`).

8. Permalinks & REST API: On your WordPress site:
   - Settings → Permalinks → choose "Post name" → Save.
   - WooCommerce → Settings → Advanced → REST API → Add key (Read/Write) → note Consumer Key & Secret.

9. Run the app:
   ```
   flutter run
   ```

10. Troubleshooting:
   - 401 Unauthorized from API → check keys, HTTPS, and that security plugins aren't blocking REST requests.
   - Empty categories/products → ensure products published and assigned to categories.

If you want, I can also generate a ready APK or help integrate Razorpay / FCM next.
