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

1. **Not added as test user** (if app is in Testing mode)
   - Follow Option 1 or 2 above

2. **Expired credentials**
   - Sign out (click your name → sign out)
   - Clear browser cache for the site
   - Sign in again

3. **Wrong scopes configured**
   - Verify `https://www.googleapis.com/auth/drive.file` is added in OAuth consent screen
   - Check the scope in your code matches

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
