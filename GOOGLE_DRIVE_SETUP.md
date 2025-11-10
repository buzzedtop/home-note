# Google Drive Integration Setup

This guide explains how to configure Google Drive integration for saving and loading notes.

## Features

When you sign in with Google, your notes will be:
- Automatically saved to Google Drive when you add, delete, or reorder notes
- Stored in a file called `home_note_data.json` in your Google Drive
- Loaded from Google Drive when you sign in
- Still saved locally for offline access

## Setting Up Google OAuth Credentials

To enable Google Sign-In and Drive integration, you need to set up OAuth credentials:

### 1. Create a Google Cloud Project

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Drive API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Drive API"
   - Click "Enable"

### 2. Configure OAuth Consent Screen

1. Go to "APIs & Services" > "OAuth consent screen"
2. Choose "External" (unless you have a Google Workspace organization)
3. Fill in the required information:
   - App name: "Home Note"
   - User support email: your email
   - Developer contact: your email
4. Add scopes:
   - `https://www.googleapis.com/auth/drive.file` (for accessing files created by the app)
5. Add test users if in testing mode (your own email address)
6. Save and continue

### 3. Create OAuth 2.0 Credentials

1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Choose "Web application"
4. Add authorized JavaScript origins:
   - `http://localhost:8080` (for local development)
   - `https://buzzedtop.github.io` (for GitHub Pages)
   - Add your custom domain if you have one
5. Add authorized redirect URIs:
   - `http://localhost:8080` (for local development)
   - `https://buzzedtop.github.io/home-note` (for GitHub Pages)
   - Add your custom domain if you have one
6. Click "Create"
7. Copy the Client ID (looks like: `xxxxx.apps.googleusercontent.com`)

### 4. Update the Application

Edit `web/index.html` and replace the placeholder client ID:

```html
<meta name="google-signin-client_id" content="YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com">
```

Replace `YOUR_ACTUAL_CLIENT_ID` with your actual Client ID from step 3.

### 5. Rebuild and Deploy

For local development:
```bash
flutter run -d chrome
```

For production build:
```bash
flutter build web
```

## Using Google Drive Integration

### Sign In
1. Click the "Login" button in the top-right corner
2. Click "Continue with Google"
3. Authorize the app to access your Google Drive files
4. Your existing notes (if any) will be loaded from Google Drive

### Automatic Sync
- Notes are automatically saved to Google Drive whenever you:
  - Add a new note
  - Delete a note
  - Reorder notes

### Manual Sync
When signed in, you'll see cloud buttons in the toolbar:
- **Cloud Download** (↓): Load notes from Google Drive
- **Cloud Upload** (↑): Save notes to Google Drive

### Sign Out
- Click on your name/email in the top-right corner to sign out
- Your notes will remain saved locally even after signing out

## Security Notes

- The app only requests access to files it creates (`drive.file` scope)
- It cannot access other files in your Google Drive
- Your notes are stored in a single JSON file: `home_note_data.json`
- The Client ID is public and safe to commit to source control
- Never commit the Client Secret (not needed for this application)

## Troubleshooting

### "Sign-in failed" error
- Verify your Client ID is correctly configured in `web/index.html`
- Check that your domain is listed in authorized JavaScript origins
- Ensure Google Drive API is enabled in your project

### Notes not syncing
- Check your internet connection
- Verify you're signed in (your name should appear in the top-right)
- Look for error messages in the snackbar at the bottom of the screen
- Check browser console for detailed error messages

### Using without Google Drive
- The app works perfectly fine without signing in
- Notes are always saved locally using browser localStorage
- Google Drive is an optional enhancement for cloud backup

## Privacy

- Your notes are stored locally in your browser
- When signed in, notes are also stored in your personal Google Drive
- No notes are sent to any third-party servers
- The app runs entirely in your browser
