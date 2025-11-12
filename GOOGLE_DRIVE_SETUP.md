# Google Drive Integration Setup

This guide explains how to configure Google Drive integration for saving and loading notes.

## ⚠️ Important: Fixing "Access Blocked" Error

If you're seeing **"Error 403: access_denied"** or **"Access Blocked: buzzedtop.github.io has not completed the Google verification process"**, this means your OAuth consent screen is in Testing mode. Jump to the [Troubleshooting](#troubleshooting) section below for quick fixes.

**Quick Fix Options:**
1. **Add yourself as a test user** in Google Cloud Console (fastest for personal use)
2. **Publish your app to Production** (recommended for sharing with others)

See [Troubleshooting](#troubleshooting) section for detailed instructions.

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
   - Click "Add or Remove Scopes"
   - Search for and select: `https://www.googleapis.com/auth/drive.file`
   - This scope allows the app to access files it creates (not all Drive files)
   - Click "Update" to save the scopes
5. **IMPORTANT**: Publishing Status
   - **Option A: Testing Mode** (Quick setup, limited access)
     - If you stay in "Testing" mode, only you and explicitly added test users can sign in
     - Add test users by email address (your own email and any other users who need access)
     - This is sufficient for personal use or small teams
     - **Limitation**: Maximum of 100 test users, app shows "unverified" warning
   - **Option B: Production Mode** (Recommended for public access)
     - Click "Publish App" to make it available to all Google users
     - For apps using only non-sensitive scopes like `drive.file`, no verification is required
     - Users may see a warning that the app is "unverified" but can proceed by clicking "Advanced"
     - To remove the warning, you can submit for verification (optional, takes 3-5 days)
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

### 5. Verify Your Setup

Before deploying, verify your OAuth configuration is correct:

**Checklist:**
- [ ] Google Drive API is enabled in your Google Cloud project
- [ ] OAuth consent screen is configured with app name and contact emails
- [ ] Scope `https://www.googleapis.com/auth/drive.file` is added
- [ ] OAuth client ID is created for "Web application"
- [ ] Authorized JavaScript origins include your deployment URL(s)
- [ ] Authorized redirect URIs include your deployment URL(s)
- [ ] **CRITICAL**: Either:
  - [ ] Your email is added as a test user (if in Testing mode), OR
  - [ ] App is published to Production
- [ ] Client ID is updated in `web/index.html`

**How to Check Publishing Status:**
1. Go to "APIs & Services" > "OAuth consent screen"
2. Look at the top of the page for "Publishing status"
3. If it says "Testing" and you want others to access it, click "Publish App"
4. If it says "In Production", you're all set!

### 6. Rebuild and Deploy

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

### "Error 403: access_denied" or "Access Blocked"
This error occurs when your OAuth consent screen is in **Testing** mode and the user signing in is not added as a test user.

**Solution 1: Add Test Users** (if staying in Testing mode)
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to "APIs & Services" > "OAuth consent screen"
3. Scroll down to "Test users" section
4. Click "Add Users"
5. Enter the email address of each user who needs access
6. Click "Save"
7. Users can now sign in successfully

**Solution 2: Publish to Production** (recommended for public access)
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to "APIs & Services" > "OAuth consent screen"
3. Click "Publish App" button
4. Confirm by clicking "Confirm" in the dialog
5. Your app is now available to all Google users
6. Note: Users may see an "unverified app" warning but can proceed by clicking "Advanced" > "Go to [App Name] (unsafe)"

**To remove the "unverified" warning** (optional):
- Submit your app for verification through the OAuth consent screen
- This process typically takes 3-5 business days
- Verification is not required for apps using only `drive.file` scope for personal/internal use

### "Authorization Failed please sign in again"
This error appears after signing in when the app cannot obtain an authenticated HTTP client.

**Common Causes:**
1. **App just published**: Changes can take 5-10 minutes to propagate. Clear browser cache, sign out from Google completely, and try again.
2. **Incorrect redirect URIs**: The most common issue after publishing. Verify:
   - **Authorized JavaScript origins**: `https://buzzedtop.github.io` (no path)
   - **Authorized redirect URIs**: `https://buzzedtop.github.io/home-note` (with path)
   - Go to **APIs & Services** → **Credentials** → Your OAuth Client to check/update
3. **Testing Mode without Test User**: See "Error 403" solution above
4. **Google Drive API not enabled**: Go to **APIs & Services** → **Library** → Search "Google Drive API" → Should show "MANAGE"
5. **Wrong scopes**: Verify `https://www.googleapis.com/auth/drive.file` is added in OAuth consent screen
6. **Expired Credentials**: Sign out completely and sign in again

**Steps to Fix:**
1. **Verify authorized URIs** (most important - see cause #2 above)
2. **Clear browser cache completely** (Settings → Privacy → Clear browsing data → Cookies and Cache)
3. **Sign out from Google** in your browser (google.com → sign out)
4. **Wait 5-10 minutes** after making any changes in Google Cloud Console
5. **Sign in again** to the app
6. If still failing, check browser console (F12) for specific error messages

### "Sign-in failed" error
- Verify your Client ID is correctly configured in `web/index.html`
- Check that your domain is listed in authorized JavaScript origins:
  - For local development: `http://localhost:8080`
  - For GitHub Pages: `https://buzzedtop.github.io`
- Ensure Google Drive API is enabled in your project
- Check browser console (F12) for detailed error messages

### Notes not syncing
- Check your internet connection
- Verify you're signed in (your name should appear in the top-right)
- Look for error messages in the snackbar at the bottom of the screen
- Check browser console for detailed error messages
- Ensure you have granted the app permission to access your Google Drive

### Using without Google Drive
- The app works perfectly fine without signing in
- Notes are always saved locally using browser localStorage
- Google Drive is an optional enhancement for cloud backup

## Privacy

- Your notes are stored locally in your browser
- When signed in, notes are also stored in your personal Google Drive
- No notes are sent to any third-party servers
- The app runs entirely in your browser
