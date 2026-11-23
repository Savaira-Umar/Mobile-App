# SAVAIRA — Private Two-User Daily Planner (Android, Flutter)

## Project Overview
A private two-user daily planner mobile app tailored for two specific target users (Savaira and User 2) living in different countries. Target devices: Tecno Spark 20C (Android, HiOS) and Samsung Galaxy S21 Ultra. Portrait mode.

## Hard Rules
- 100% FREE services. No paid services, no Firebase Blaze plan, no Cloud Functions, no Firebase Cloud Storage, no paid APIs.
- Windows OS with PowerShell commands.
- Tech Stack: Flutter (stable), Dart, Riverpod (state), go_router (navigation). Later phases: Firebase Auth + Cloud Firestore (offline persistence ON), flutter_local_notifications + timezone.
- Architecture: Repository pattern (TaskRepository, GoalRepository, NamazRepository, CommentRepository, ProfileRepository, SettingsRepository). Local in-memory JSON file persistence first, swappable for Firestore without touching UI.
- Offline fonts & bundled assets. No internet-loaded fonts or network images.
- Minimal text, clean layout, soft rounded cards, no heavy animations.

## Design System
- **Background**: Soft pastel gradient (`#F4F8FF` to `#FFFFFF`). Cards: Pure white (`#FFFFFF`).
- **Primary Blue**: `#3B6FE0` to `#2F62D8` (nav active pill, accents, primary buttons, '+' buttons).
- **Done / Progress Green**: `#34B26B` (light green chip background `#DDF5E6`).
- **Pending / Due / Cross**: Soft red/pink (`#FBD5DB` background, `#E5484D` icon/text). Unselected/empty circles: light grey-blue outline (`#CBD5E1`).
- **Text**: Dark navy for headings (`#1F2A44`), grey-blue for descriptions (`#64748B`).
- **Shapes**: Rounded cards (radius 20 to 24), fully rounded pill buttons, soft shadows (low opacity, large blur).
- **Fonts**:
  - Rounded friendly sans: Nunito / Poppins for UI.
  - Script font: Great Vibes / Dancing Script ONLY for the "Savaira" logo text.
  - Arabic: Noto Naskh Arabic for the Arabic dua.
- **Decorations**:
  - Blue flower sprig with green leaves at bottom-left of sidebar.
  - Leaf sprigs on card corners.
  - Soft wave/hill shapes.
  - Mosque illustration in Namaz header.
  - Sun-with-cloud illustration in Today greeting (moon at night).
- **Task & Goal Icons**: Pastel rounded-square or circle tile behind each icon.

## Navigation Shell
- Left narrow vertical sidebar:
  - Top: "Savaira" logo (script text + small blue flower above + small blue heart below with a thin line).
  - 4 items:
    1. Today (home icon)
    2. Goals (target icon)
    3. Namaz (mosque icon)
    4. User 2 (two-people pink icon; label ALWAYS "User 2" with lock icon when locked)
  - Bottom: Blue flower sprig with green leaves.
- Active item: Filled blue rounded pill with white icon & label. Inactive: colored icon with dark label.

## Screens
- **S0. Login**: White/pastel background, logo, email & password fields, blue "Login" button.
- **S1. Today**: Date & weekday, bell icon (Notification settings), round avatar (Profile & Settings), Greeting with sun/moon illustration, Progress ring & bar ("Today's Progress"), "Today's Tasks" with "View All >", Task cards (pastel icon, title, description, time, Done/Pending toggle circle), "+ Add Task" pill button, "Night Review" button.
- **S2. Task Details**: Back, title, three-dots menu, big icon tile, details, reminder status, related goal, status chip, Mark as Done/Pending, Edit, Delete with Undo snackbar, Comments bottom sheet.
- **S3. Add / Edit Task**: Title (with Auto-icon selection), description, 3x4 pastel icon grid + picker, date & time pickers, reminder toggle (offset choice), related goal dropdown, Save / Delete buttons.
- **S4. Goals List**: "My Goals" header, target emoji, subtitle, "+" button, Goal cards with progress bar, completion chip, leaf decoration.
- **S4b. Goal Details**: Header card, target date (editable), progress bar, task list for goal with completion toggle, Add Task, Edit Goal, Delete Goal.
- **S4c. Add / Edit Goal**: Title, description, icon picker, target date picker, Save button.
- **S5. Daily Plan**: Date selector pill with left/right arrows & date picker, sorted tasks for the day, "+ Add Task".
- **S6. Weekly Plan**: Weekday chips (Mon-Sun), day header, task list, "+ Add Task", previous/next week.
- **S7. Night Review**: Crescent moon illustration, "How was your day?", Completed & Pending summary cards, multi-line note box, "Save My Day" bookmark button.
- **S8. Namaz**: Mosque illustration header, date selector, 5 prayers (Fajr, Zuhar, Asar, Maghrib, Isha) with sky illustration icon, prayer time (editable per user), tick/cross toggle buttons, Arabic dua card ("اللهم تقبل منا").
- **S9. User 2 (Private Space)**:
  - Locked state: Blue shield, padlock, name entry, "Continue" button, privacy illustration, lock timeout & wrong attempt lockout, salted hash + PIN verification.
  - Unlocked state: "Hello, <real name> 💕", Today/Goals/Namaz tabs, view-only mode for Savaira, speech bubble for comments.
- **S10. Task Comments**: Bottom sheet, list of comments, author edit/delete, add comment, comment badges on tasks.
- **S11. Profile & Settings**: Avatar (crop/resize JPEG < 150KB), display name edit, Notification Settings, Check for Updates, Export/Import Backup, Sync status, Logout.
- **S12. Notification Settings**: Master toggle, sound, vibration, silent, custom ringtone, morning summary time, night reminder time, default reminder offset, phone-specific battery/autostart optimization guide (Tecno HiOS & Samsung).

## Auto Icons
Offline keyword mapping (over 60 keywords across English, Urdu, and Roman Urdu) mapping task title to appropriate pastel icons.
