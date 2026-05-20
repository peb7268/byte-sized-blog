---
title: 'Setting Up Local-Remote Hybrid Astro Build System'
description: 'Step-by-step guide for setting up an Astro blog that writes locally in Obsidian but builds directly to a remote Unraid NAS server.'
pubDate: 'Oct 22 2024'
draft: true
---

# Setting Up Local-Remote Hybrid Astro Build System

This guide walks through setting up an Astro blog with a hybrid local/remote architecture where:
- Blog posts are written **locally** in Obsidian
- Astro project runs **locally** on your Mac
- Build output writes **remotely** to Unraid NAS via SMB mount

## Architecture Overview

### The Hybrid Model

```
LOCAL (Mac)                          REMOTE (Unraid)
==================                   ==================
Obsidian Vault
  ↓ (symlink)
Astro Project
  ↓ (build process)
                     ----SMB----->   /mnt/user/blog
                                       ↓
                                     Nginx Container
                                       ↓
                                     Internet (HTTPS)
```

### What Persists Where

**ALWAYS Available (Local on Mac):**
- ✅ Obsidian blog posts at `/Users/pbarrick/Documents/Main/Resources/Learning/Blog/`
- ✅ Astro project at `/Users/pbarrick/Desktop/dev/blog/`
- ✅ Symlink from Astro to Obsidian (LOCAL→LOCAL)
- ✅ Can edit posts and code anytime

**ONLY When Connected to Unraid:**
- ⚠️ `/Volumes/blog` mount (disappears when VPN disconnects)
- ⚠️ Ability to run `npm run build` (needs output destination)
- ⚠️ Viewing built HTML files

## Prerequisites

### Required Software
- Node.js v20+ and npm
- Unraid server with SMB share enabled
- Unraid Teleport VPN (for remote access)
- Obsidian (for writing)

### Unraid Configuration
- **Server IP**: 192.168.1.62
- **User**: peb7268
- **SMB Share**: `/mnt/user/blog`
- **Docker Container**: nginx-astro (serving on port 3000)

### Network Access
- Connected to local network OR
- Connected via Unraid Teleport VPN

## Setup Steps

### Step 1: Create Project Directory

```bash
cd /Users/pbarrick/Desktop/dev
mkdir blog
cd blog
```

### Step 2: Initialize Astro Project

```bash
# Initialize with npm create
npm create astro@latest .

# When prompted:
# - How would you like to start? → Use blog template
# - Install dependencies? → Yes
# - Initialize git repository? → Yes (or No, your preference)
# - TypeScript? → Strictest (or your preference)
```

This creates the standard Astro blog structure:
```
blog/
├── src/
│   ├── content/
│   │   └── blog/          # We'll replace this with symlink
│   ├── layouts/
│   ├── pages/
│   └── components/
├── public/
├── astro.config.mjs       # We'll modify this
├── package.json
└── tsconfig.json
```

### Step 3: Configure Build Output

**Edit `astro.config.mjs`:**

```javascript
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://blog.byte-sized.io',

  // THIS IS THE KEY CHANGE:
  // Build directly to Unraid mount instead of local dist/
  outDir: '/Volumes/blog',

  integrations: [mdx(), sitemap()],
});
```

**What this does:**
- Normally Astro builds to `./dist/` (local)
- With `outDir: '/Volumes/blog'`, it builds directly to Unraid
- Eliminates need for separate deployment step
- Files available immediately after build

### Step 4: Set Up Symlink (Local → Local)

**Remove default blog directory:**
```bash
cd /Users/pbarrick/Desktop/dev/blog
rm -rf src/content/blog
```

**Create symlink to Obsidian:**
```bash
ln -s /Users/pbarrick/Documents/Main/Resources/Learning/Blog \
      /Users/pbarrick/Desktop/dev/blog/src/content/blog
```

**Verify symlink:**
```bash
ls -la src/content/blog

# Should show:
# lrwxr-xr-x ... src/content/blog -> /Users/pbarrick/Documents/Main/Resources/Learning/Blog
```

**Important Understanding:**
- Both paths are LOCAL on your Mac
- Symlink persists even when disconnected from Unraid
- Can view/edit posts anytime via Obsidian OR Astro project
- Changes in either location reflect immediately

### Step 5: Create Build Infrastructure

**Create logs directory:**
```bash
mkdir -p /Users/pbarrick/Desktop/dev/blog/logs
```

This directory will store:
- Cron job build logs
- Manual build output
- Error logs for debugging

### Step 6: Test Build Process

**Prerequisites:**
1. Connect to Unraid Teleport VPN
2. Mount SMB share:
   - Finder → Go → Connect to Server
   - `smb://peb7268@192.168.1.62/blog`
   - Should mount at `/Volumes/blog`

**Verify mount:**
```bash
ls /Volumes/blog
# Should show existing blog files
```

**Run first build:**
```bash
cd /Users/pbarrick/Desktop/dev/blog
npm run build
```

**Expected output:**
```
building client
generating optimized images
generating static routes
✓ Completed in 2.34s
```

**Verify deployment:**
```bash
# Check files written to mount
ls -lt /Volumes/blog/index.html

# Test in browser
open https://blog.byte-sized.io/
```

## Usage Workflows

### Writing Blog Posts (Offline OK)

```bash
# Open Obsidian
# Navigate to Resources/Learning/Blog/
# Create new .md file or edit existing
# Add frontmatter (see template below)
# Write content
# Save (auto-saves)
```

**Frontmatter Template:**
```yaml
---
title: 'My Post Title'
description: 'Brief description for SEO'
pubDate: 'Oct 22 2024'
heroImage: 'https://images.unsplash.com/photo-xyz...'
draft: false
---
```

### Building & Deploying (Requires Unraid Connection)

**Manual Build:**
```bash
# 1. Connect to Unraid Teleport VPN
# 2. Verify mount
ls /Volumes/blog

# 3. Build
cd /Users/pbarrick/Desktop/dev/blog
npm run build

# 4. Verify
open https://blog.byte-sized.io/
```

**Automated Build (Cron):**
```bash
# Edit crontab
crontab -e

# Add this line (builds 3x daily):
0 6,14,22 * * * cd /Users/pbarrick/Desktop/dev/blog && /opt/homebrew/bin/npm run build >> /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log 2>&1
```

**View build logs:**
```bash
tail -f /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log
```

## Understanding Local vs Remote

### What Happens When Building

**Local Processing (on your Mac):**
1. Read Astro source files from `/Users/pbarrick/Desktop/dev/blog/src/`
2. Read blog markdown from `/Users/pbarrick/Documents/Main/Resources/Learning/Blog/` (via symlink)
3. Process markdown → HTML (CPU-intensive work)
4. Apply templates, styles, optimizations
5. Generate static files in memory

**Remote Writing (over network):**
6. Write files to `/Volumes/blog` (SMB mount)
7. Files transfer over network to Unraid
8. Land in `/mnt/user/blog` on Unraid
9. Nginx immediately serves updated content

### What Works Offline

**✅ Can Do:**
- Write blog posts in Obsidian
- Edit existing posts
- Organize posts, create drafts
- Modify Astro templates/layouts
- Edit CSS, components, pages
- Commit changes to git
- View blog posts in Obsidian

**❌ Cannot Do:**
- Run `npm run build` (output destination missing)
- View built HTML files
- Deploy to production
- Test final output in browser

### Connection States

| State | Obsidian | Astro Code | Symlink | Build | Deploy |
|-------|----------|------------|---------|-------|--------|
| **Offline** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Local Network** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **VPN Connected** | ✅ | ✅ | ✅ | ✅ | ✅ |

## Troubleshooting

### Symlink Broken

**Check symlink:**
```bash
ls -la /Users/pbarrick/Desktop/dev/blog/src/content/blog
```

**Recreate if needed:**
```bash
rm /Users/pbarrick/Desktop/dev/blog/src/content/blog
ln -s /Users/pbarrick/Documents/Main/Resources/Learning/Blog \
      /Users/pbarrick/Desktop/dev/blog/src/content/blog
```

### Build Fails: Cannot Write to /Volumes/blog

**Cause**: Not connected to Unraid

**Solution:**
1. Connect to Unraid Teleport VPN
2. Mount SMB share (Finder → Connect to Server → `smb://peb7268@192.168.1.62/blog`)
3. Verify: `ls /Volumes/blog`
4. Retry build

### Posts Not Showing in Astro

**Check symlink:**
```bash
ls /Users/pbarrick/Desktop/dev/blog/src/content/blog/
# Should list your Obsidian posts
```

**Check frontmatter:**
- Posts need valid YAML frontmatter
- Required fields: `title`, `description`, `pubDate`
- Set `draft: false` for published posts

### Cron Builds Failing

**Check VPN:**
- Mac must be awake and connected to Unraid
- Cron runs at 6am, 2pm, 10pm
- If Mac sleeping or VPN disconnected, build fails

**Check logs:**
```bash
cat /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log
```

## Advanced Topics

### Build Locally, Deploy Separately (Alternative)

If SMB writes are too slow or unreliable:

**Option 1: Build Local, rsync Remote**
```javascript
// astro.config.mjs
export default defineConfig({
  outDir: './dist',  // Build locally
});
```

```bash
# Then deploy
npm run build
rsync -avz dist/ peb7268@192.168.1.62:/mnt/user/blog/
```

**Option 2: Build Local, Script Deploy**
```json
// package.json
{
  "scripts": {
    "build": "astro build",
    "deploy": "npm run build && rsync -avz dist/ peb7268@192.168.1.62:/mnt/user/blog/"
  }
}
```

### Drafts Filtering

**Method 1: Frontmatter**
```yaml
---
draft: true
---
```

Then filter in Astro collection config.

**Method 2: Separate Folder**
Keep drafts in `/Resources/Learning/Blog/drafts/` and configure Astro to exclude.

## Summary

This hybrid setup provides:

**Advantages:**
- ✅ Write anywhere, anytime in Obsidian
- ✅ No manual file copying/deployment
- ✅ Instant publishing (build → live)
- ✅ Local symlink always works
- ✅ Simple architecture

**Trade-offs:**
- ⚠️ Must be connected to Unraid to build
- ⚠️ SMB writes slower than local disk
- ⚠️ Cron requires constant VPN connection

**Perfect for:**
- Personal blogs with occasional updates
- Writing offline, publishing later
- Simple deploy process
- Home lab / self-hosted setups

---

**Setup Complete!** You can now write blog posts in Obsidian anytime and build to your Unraid server when connected.
