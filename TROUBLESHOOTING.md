# Troubleshooting Guide

Quick reference for common issues with Home Note.

## Google OAuth / Sign-In Issues

### 🔴 "Error 403: access_denied" or "Access Blocked"

**Problem**: You see "buzzedtop.github.io has not completed the Google verification process" when trying to sign in.

**Root Cause**: Your Google OAuth consent screen is in "Testing" mode, which only allows access to explicitly added test users.

**Quick Fix** (choose one):

#### Option 1: Add Test Users (fastest for personal use)
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to: **APIs & Services** → **OAuth consent screen**
3. Scroll to **Test users** section
4. Click **Add Users**
5. Enter your email address
6. Click **Save**
7. Try signing in again

#### Option 2: Publish App (recommended for sharing)
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to: **APIs & Services** → **OAuth consent screen**
3. Click **Publish App** button at the top
4. Click **Confirm**
5. Done! Anyone can now sign in
   - Note: Users may see "unverified app" warning - they can proceed by clicking "Advanced"

---

### 🔴 "Authorization Failed please sign in again"

**Problem**: After successfully signing in, you see this error when trying to use Google Drive features.

**Causes & Solutions**:

1. **App is published but still failing**
   - **Wait 5-10 minutes** after publishing - changes can take time to propagate
   - **Clear browser cache completely**:
     - Chrome: Settings → Privacy → Clear browsing data → Cached images and Cookies
     - Firefox: Settings → Privacy → Clear Data → Cookies and Cache
   - **Sign out from Google completely** in your browser, then sign in again to the app
   - **Check authorized redirect URIs** (common issue):
     - Go to: **APIs & Services** → **Credentials** → Your OAuth Client
     - Under "Authorized redirect URIs", you should have:
       - `https://buzzedtop.github.io/home-note` (with the path)
     - Under "Authorized JavaScript origins", you should have:
       - `https://buzzedtop.github.io` (without the path)
     - If these are incorrect, update them and wait 5 minutes

2. **Not added as test user** (if app is in Testing mode)
   - Follow Option 1 or 2 above to publish or add test users

3. **Expired credentials**
   - Sign out (click your name → sign out)
   - Clear browser cache for the site
   - Sign in again

4. **Wrong scopes configured**
   - Verify `https://www.googleapis.com/auth/drive.file` is added in OAuth consent screen
   - Go to: **APIs & Services** → **OAuth consent screen** → Edit App
   - Click through to the "Scopes" section
   - Ensure the Drive File scope is listed
   - If you added it recently, it can take a few minutes to activate

5. **Google Drive API not enabled**
   - Go to: **APIs & Services** → **Library**
   - Search for "Google Drive API"
   - It should show "MANAGE" (not "ENABLE")
   - If it shows "ENABLE", click it to enable the API

---

### 🔴 "People API has not been used" or "People API is disabled"

**Problem**: After signing in, you see an error about "People API has not been used in project" or "SERVICE_DISABLED".

**Root Cause**: Google Sign-In requires the People API to retrieve user profile information (name, email), but it's not enabled in your Google Cloud project.

**Solution**:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to: **APIs & Services** → **Library**
3. Search for "People API"
4. Click on "People API" in the results
5. Click the **"ENABLE"** button
6. Wait 2-3 minutes for the API to activate
7. Clear browser cache and try signing in again

**Note**: You need **both** Google Drive API and People API enabled for this app to work:
- **Google Drive API**: For saving/loading notes to Google Drive
- **People API**: For Google Sign-In to retrieve your name and email

---

### 🔴 "Sign-in failed"

**Problem**: The sign-in popup doesn't work or fails immediately.

**Solutions**:

1. **Check Client ID in code**
   - Verify `web/index.html` has your correct Client ID
   - Should look like: `xxxxx.apps.googleusercontent.com`

2. **Check authorized origins**
   - Go to: **APIs & Services** → **Credentials** → Your OAuth Client
   - Ensure these are listed:
     - `http://localhost:8080` (for local dev)
     - `https://buzzedtop.github.io` (for production)
     - Your custom domain (if any)

3. **Check Google Drive API is enabled**
   - Go to: **APIs & Services** → **Library**
   - Search for "Google Drive API"
   - Should show "MANAGE" (not "ENABLE")

---

## General Issues

### 🔵 Notes not syncing to Google Drive

**Checks**:
- [ ] Are you signed in? (Your name should show in top-right)
- [ ] Is there an internet connection?
- [ ] Are there any error messages in the snackbar (bottom of screen)?

**Solutions**:
1. Try manual sync:
   - Click cloud upload button (↑) in toolbar
   - Click cloud download button (↓) to load from Drive

2. Check browser console (F12) for detailed errors

3. Sign out and sign in again

---

### 🔵 Notes disappeared

**Don't panic!** Notes are stored in multiple places:

1. **Local browser storage**: Always saved here
   - Try refreshing the page
   - Check if you're in the right browser/profile

2. **Google Drive**: If you were signed in
   - Sign in again
   - Click cloud download button (↓)

**Note**: Clearing browser data or using incognito mode will clear local notes.

---

### 🔵 App not loading on GitHub Pages

**Checks**:
1. Wait 2-3 minutes after deployment
2. Hard refresh: `Ctrl+F5` (Windows) or `Cmd+Shift+R` (Mac)
3. Clear browser cache
4. Check [GitHub Actions](https://github.com/buzzedtop/home-note/actions) for deployment status

---

### 🟡 Still Having Issues After Publishing?

If you've published the app and are still getting authentication errors, follow this systematic debugging checklist:

**Step 1: Verify Publishing Status**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to: **APIs & Services** → **OAuth consent screen**
3. Check "Publishing status" at the top - should say "In production"
4. If it says "Testing", click "Publish App"

**Step 2: Verify APIs are Enabled** (CRITICAL)
1. Go to: **APIs & Services** → **Library**
2. Search for "Google Drive API"
3. Click on it - should show "API enabled" with a "MANAGE" button
4. If you see "ENABLE" instead, click it to enable
5. **IMPORTANT**: Also search for "People API"
6. Click on "People API" - should show "API enabled"
7. If "People API" shows "ENABLE", click it to enable (required for sign-in)
8. Wait 2-3 minutes after enabling any API

**Step 3: Verify OAuth Credentials** (MOST COMMON ISSUE)
1. Go to: **APIs & Services** → **Credentials**
2. Click on your OAuth 2.0 Client ID
3. Check **Authorized JavaScript origins**:
   - Must include: `https://buzzedtop.github.io`
   - For local testing: `http://localhost:8080`
4. Check **Authorized redirect URIs**:
   - Must include: `https://buzzedtop.github.io/home-note`
   - For local testing: `http://localhost:8080`
5. If any are missing or wrong, update and click "SAVE"
6. **Wait 5-10 minutes** after saving for changes to propagate

**Step 4: Verify Scopes**
1. Go to: **APIs & Services** → **OAuth consent screen**
2. Click "Edit App"
3. Navigate to "Scopes" section
4. Ensure `https://www.googleapis.com/auth/drive.file` is listed
5. If missing, add it and save

**Step 5: Clear Everything and Retry**
1. Clear browser cache completely
2. Sign out from Google in your browser (go to google.com and sign out)
3. Close all browser tabs
4. Open a new browser tab
5. Go to your app URL
6. Try signing in again

**Step 6: Check Browser Console**
1. Open browser console (F12 or Right-click → Inspect)
2. Go to "Console" tab
3. Try signing in
4. Look for error messages (usually in red)
5. Common errors and meanings:
   - `redirect_uri_mismatch`: Your redirect URIs in Step 3 are wrong
   - `invalid_client`: Your Client ID doesn't match
   - `access_denied`: Publishing or scopes issue (check Steps 1 & 4)

---

## Getting More Help

If your issue isn't listed here:

1. **Check browser console** (Press F12, look at Console tab)
2. **Check Network tab** in browser dev tools for failed requests
3. **Open an issue** on [GitHub](https://github.com/buzzedtop/home-note/issues)
   - Include error messages
   - Include browser console logs
   - Include steps to reproduce

## Additional Resources

- [Google Drive Setup Guide](GOOGLE_DRIVE_SETUP.md) - Complete OAuth setup instructions
- [Deployment Guide](DEPLOYMENT.md) - GitHub Pages deployment
- [Getting Started](GETTING_STARTED.md) - Basic usage instructions
