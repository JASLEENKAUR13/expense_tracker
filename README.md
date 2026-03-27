# Expenso 💰

A personal expense tracking app built with Flutter and Supabase.

## Features

- 🔐 **Authentication** — Email/password and Google Sign-In
- 👤 **Profile Setup** — Set monthly income and savings goal percentage
- 💸 **Expense Tracking** — Add transactions with title, amount, note, date, and credit/debit status
- 📊 **Quick Overview** — See total income, expenses, and remaining budget at a glance
- ☁️ **Cloud Sync** — All data stored in Supabase, synced across devices

## Tech Stack

- **Flutter** — UI framework
- **Riverpod** — State management
- **Supabase** — Backend, authentication and database
- **Google Fonts** — Typography (Poppins)

## Project Structure

```
lib/
├── common/
│   ├── functions/       # Shared utilities (currency formatter, etc.)
│   └── theme/           # App colors and theme
├── features/
│   ├── Auth/            # Login, signup, onboarding
│   ├── Expense/         # Add expense, home page, providers
│   └── profile/         # Profile setup and services
```

## Getting Started

1. Clone the repo
2. Run `flutter pub get`
3. Add your Supabase credentials in your env/config
4. Run `flutter run`

## Database Tables

- `profiles` — stores user income and savings goal
- `expenses` — stores all transactions per user

## Work in Progress 🚧

- Receipt image upload
- Profile editing screen
- App theme customization
- Expense editing and deletion
