# Expenso 💰
A smart personal expense tracker built with Flutter and Supabase — India-first, privacy-focused.

## Features

### 🔐 Authentication
- Email/password with full verification flow
- Google Sign-In
- Auto session management

### 👤 Profile
- Name, phone, monthly income, savings goal
- Custom salary day (budget resets on your payday!)
- Edit profile anytime

### 💸 Expense Tracking
- Add income & expenses with title, amount, note, date, category
- Edit and delete transactions
- Swipe to edit

### 📊 Dashboard
- Smart budget card showing current period (e.g. APRIL 2026)
- Real-time income vs spent vs balance
- Budget auto-resets every month based on your salary day
- Category-wise spending pie chart

### 📈 Analytics
- Weekly spending bar chart
- Monthly spending line chart
- Monthly income vs expense comparison

### 🗂️ Transactions
- Filter by income/expense/category
- Day-wise grouped history

### ☁️ Cloud Sync
- All data stored in Supabase
- Real-time updates across devices
- Row Level Security (RLS) enabled

## Tech Stack
- **Flutter 3.19+** — UI framework
- **Riverpod 2.x** — State management
- **Supabase** — Auth, PostgreSQL database, RLS
- **fl_chart** — Charts and graphs
- **Google Fonts** — Typography (Poppins)
- **flutter_screenutil** — Responsive UI

## Project Structure
```
lib/
├── common/
│   ├── functions/    # Currency formatter, budget period, filtering
│   ├── theme/        # App colors and theme
│   └── widgets/      # Shared widgets
├── features/
│   ├── Auth/         # Login, signup, onboarding, verification
│   ├── Category/     # Category list, pie chart, providers
│   ├── Expense/      # Add/edit expense, dashboard, analytics
│   └── profile/      # Profile setup, editing, services
```
## Getting Started
1. Clone the repo
2. Run `flutter pub get`
3. Create `.env` file with your Supabase credentials:
SUPABASE_URL=your_url
SUPABASE_ANON_KEY=your_key
4. Run `flutter run`

## Database Schema
- `profiles` — user info, income, savings goal, salary day
- `expenses` — all transactions per user
- `categories` — public expense categories

- ## Download & Try 📲

An installable APK is available for Android devices.

> **Note:** Since this app is not yet on the Play Store, you'll need to enable
> "Install from unknown sources" in your Android settings.

### Install Steps
1. Download the APK from the link below
2. Open the file on your Android device
3. Tap **Install**
4. Open **Expenso** and sign up!

[![Download APK](https://img.shields.io/badge/Download-APK-green?style=for-the-badge&logo=android)](https://github.com/JASLEENKAUR13/expenso/releases/latest/download/app-arm64-v8a-release.apk)

> Tested on Android 10+ — works best on Android 12 and above.

## Phase 2 Coming Soon 🚧
- Budget alerts when >80% spent
- Offline mode (Hive)
- Receipt scanning with OCR
- AI spending insights
- WhatsApp expense reports
