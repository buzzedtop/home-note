# GitHub Pages Deployment Guide

This document explains how to enable and deploy the Home Note application to GitHub Pages.

## Prerequisites

The repository includes automated workflows that handle testing, building, and deploying the Flutter web application to GitHub Pages.

## Enabling GitHub Pages

To enable GitHub Pages deployment, follow these steps:

### 1. Enable GitHub Pages in Repository Settings

1. Go to your repository on GitHub: `https://github.com/buzzedtop/home-note`
2. Click on **Settings** (top right)
3. In the left sidebar, click on **Pages**
4. Under **Source**, select:
   - Source: **GitHub Actions**
5. Click **Save**

### 2. Verify Workflow Permissions

Ensure the workflows have the necessary permissions:

1. In **Settings**, go to **Actions** → **General**
2. Under **Workflow permissions**, select:
   - **Read and write permissions**
3. Check the box: **Allow GitHub Actions to create and approve pull requests**
4. Click **Save**

## Automated Deployment

The deployment is fully automated through GitHub Actions:

### When Deployment Happens

- **Automatic**: When code is pushed to the `main` branch
- **After**: All tests pass successfully
- **Result**: The web app is deployed to `https://buzzedtop.github.io/home-note/`

### Workflow Steps

1. **Test Job**: 
   - Runs Flutter tests
   - Checks code formatting
   - Performs static analysis

2. **Build Job**: 
   - Builds Flutter web application
   - Optimized for production
   - Configured with correct base href

3. **Deploy Job**: 
   - Only runs on main branch
   - Deploys to GitHub Pages
   - Updates live site

## Workflows Included

### 1. Flutter CI/CD (`flutter-ci-cd.yml`)
- **Triggers**: Push to main or copilot/** branches, pull requests to main
- **Jobs**: Test → Build → Deploy (only on main)
- **Purpose**: Full CI/CD pipeline with GitHub Pages deployment

### 2. PR Testing (`pr-testing.yml`)
- **Triggers**: Pull request events (opened, synchronized, reopened)
- **Jobs**: Test, analyze, build, Docker build
- **Purpose**: Comprehensive testing for pull requests

## Manual Deployment

To manually trigger a deployment:

1. Go to **Actions** tab in the repository
2. Select **Flutter CI/CD** workflow
3. Click **Run workflow**
4. Select the `main` branch
5. Click **Run workflow**

## Accessing the Deployed Site

Once deployed, the application is available at:
- **URL**: `https://buzzedtop.github.io/home-note/`
- **Updates**: Automatic on every push to main (after tests pass)
- **Persistence**: Notes are stored in browser's localStorage

## Monitoring Deployments

### View Deployment Status

1. Go to **Actions** tab
2. Click on the latest workflow run
3. Check each job's status (Test, Build, Deploy)

### View Deployment History

1. Go to **Settings** → **Pages**
2. Click **View deployments** to see deployment history
3. Each deployment shows:
   - Commit that triggered it
   - Deployment time
   - Status (success/failure)

## Troubleshooting

### Deployment Fails

If deployment fails:

1. **Check workflow logs**: 
   - Go to Actions tab
   - Click on failed run
   - Review error messages

2. **Common issues**:
   - Tests failing: Fix test failures first
   - Build errors: Check Flutter version compatibility
   - Permissions: Verify workflow permissions in Settings

3. **Re-run deployment**:
   - Click **Re-run jobs** in the workflow run

### Site Not Updating

If changes aren't appearing:

1. **Wait**: Deployment can take 1-2 minutes
2. **Hard refresh**: Press Ctrl+F5 (or Cmd+Shift+R on Mac)
3. **Clear cache**: Clear browser cache and reload
4. **Check deployment**: Verify deployment succeeded in Actions tab

### Notes Not Persisting

GitHub Pages deployment uses localStorage:

- Notes are stored per domain
- Different browsers = different storage
- Clearing browser data = notes cleared
- Incognito mode = temporary storage

## Local Testing of Production Build

To test the production build locally before deploying:

```bash
# Build for web with correct base href
flutter build web --release --base-href /home-note/

# Serve locally (requires a web server)
cd build/web
python3 -m http.server 8000

# Access at: http://localhost:8000
```

## Custom Domain (Optional)

To use a custom domain:

1. Add a `CNAME` file in `web/` directory:
   ```
   yourdomain.com
   ```

2. Update base-href in workflow:
   ```yaml
   flutter build web --release --base-href /
   ```

3. Configure DNS:
   - Add CNAME record pointing to `buzzedtop.github.io`
   - Wait for DNS propagation

4. In GitHub Pages settings:
   - Enter custom domain
   - Enable HTTPS

## CI/CD Badge

The README includes status badges showing:
- [![Flutter CI/CD](https://github.com/buzzedtop/home-note/actions/workflows/flutter-ci-cd.yml/badge.svg)](https://github.com/buzzedtop/home-note/actions/workflows/flutter-ci-cd.yml) - Main deployment status
- [![PR Testing](https://github.com/buzzedtop/home-note/actions/workflows/pr-testing.yml/badge.svg)](https://github.com/buzzedtop/home-note/actions/workflows/pr-testing.yml) - PR testing status

## Security

The deployment uses:
- **Read-only content permissions** for the workflow
- **Write permissions** only for Pages deployment
- **ID token** for OIDC authentication
- **Isolated deployment environment**

All secrets and tokens are managed by GitHub Actions automatically.

## Next Steps

After enabling GitHub Pages:

1. Push to main branch to trigger deployment
2. Wait 2-3 minutes for first deployment
3. Access your live app at the GitHub Pages URL
4. Share the link with users

The application will automatically redeploy whenever you push changes to the main branch (after passing tests).
