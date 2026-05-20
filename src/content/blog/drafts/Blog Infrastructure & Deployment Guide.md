---
title: 'Blog Infrastructure & Deployment Guide'
description: 'Complete documentation for the blog.byte-sized.io infrastructure, build process, and deployment workflow using Astro, Obsidian, and Unraid.'
pubDate: 'Oct 22 2024'
draft: true
---

# Blog Infrastructure & Deployment Guide

This document provides comprehensive documentation for the `blog.byte-sized.io` infrastructure, including network topology, build processes, and deployment workflows.

## Overview

The blog is a statically-generated Astro site that is:
- Written in **Obsidian** (local markdown files)
- Built with **Astro** (static site generator)
- Hosted on **Unraid NAS** (nginx container)
- Accessed via **HTTPS** at https://blog.byte-sized.io/

## Network Infrastructure

### Unraid Server
- **Local IP**: `192.168.1.62`
- **User**: `peb7268`
- **SMB Share**: `/mnt/user/blog`
- **Access Method**: Unraid Teleport VPN (required for local network access)

### Public Access
- **URL**: https://blog.byte-sized.io/
- **DNS**: External DNS entry pointing to Unraid server
- **External Port**: Proxied to internal port 3000

### Network Topology
```
Internet (HTTPS)
    ↓
DNS: blog.byte-sized.io
    ↓
Nginx Proxy (External Port → 3000)
    ↓
Docker Container: nginx-astro (Port 3000:80)
    ↓
Volume: /mnt/user/blog (read-only)
```

## Docker Container Configuration

### Nginx Container
The blog is served by an nginx:alpine container running on Unraid.

**Docker Run Command:**
```bash
docker run -d \
  --name nginx-astro \
  -p 3000:80 \
  -v /mnt/user/blog:/usr/share/nginx/html:ro \
  nginx:alpine
```

**Configuration Details:**
- **Container Name**: `nginx-astro`
- **Image**: `nginx:alpine`
- **Port Mapping**: `3000:80` (external:internal)
- **Volume Mount**: `/mnt/user/blog:/usr/share/nginx/html:ro` (read-only)
- **Purpose**: Serves static HTML files built by Astro

## Local Development Environment

### Directory Structure

```
/Users/pbarrick/
├── Desktop/dev/blog/                    # Astro project
│   ├── src/
│   │   └── content/
│   │       └── blog/                    # Symlink to Obsidian
│   ├── dist/                            # Build output (unused)
│   ├── astro.config.mjs                 # Astro configuration
│   ├── package.json
│   └── logs/                            # Cron build logs
│
└── Documents/Main/Resources/Learning/Blog/  # Obsidian blog posts
    ├── Creating Astro posts in Obsidian.md
    ├── drafts/                          # Unpublished posts
    │   ├── Sample Draft 1.md
    │   └── Blog Infrastructure & Deployment Guide.md (this file)
    └── [published posts].md
```

### Volume Mount
When connected to local network via Unraid Teleport:

```bash
# SMB mount automatically created at:
/Volumes/blog

# Mount details:
//peb7268@192.168.1.62/blog on /Volumes/blog (smbfs, nodev, nosuid)
```

**Contents of `/Volumes/blog`** (Unraid `/mnt/user/blog`):
```
/Volumes/blog/
├── index.html                  # Homepage
├── blog/                       # Blog posts (built HTML)
│   ├── index.html
│   ├── creating-astro-posts-in-obsidian/
│   ├── first-post/
│   ├── second-post/
│   └── drafts/                 # Not served publicly
├── about/                      # About page
├── fonts/                      # Web fonts
├── collections/                # Astro collections
├── favicon.svg
├── rss.xml
├── sitemap-0.xml
└── sitemap-index.xml
```

## Astro Configuration

### Project Setup

**Astro Project Location**: `/Users/pbarrick/Desktop/dev/blog`

**Key Configuration** (`astro.config.mjs`):
```javascript
import { defineConfig } from 'astro/config';

export default defineConfig({
  // Build directly to mounted Unraid share
  outDir: '/Volumes/blog',

  // Other configurations...
});
```

### Symlink Setup

The Astro project's blog content directory is symlinked to the Obsidian vault:

```bash
# Remove default Astro blog directory
rm -rf /Users/pbarrick/Desktop/dev/blog/src/content/blog

# Create symlink to Obsidian vault
ln -s /Users/pbarrick/Documents/Main/Resources/Learning/Blog \
      /Users/pbarrick/Desktop/dev/blog/src/content/blog
```

**Result**: Blog posts written in Obsidian are immediately available to Astro for building.

## Build & Release Process

### Prerequisites

1. **Connect to Unraid via Teleport VPN**
   - Unraid Teleport must be active
   - Local network access required
   - Verify connection: `ping 192.168.1.62`

2. **Mount SMB Share**
   - macOS should auto-mount at `/Volumes/blog`
   - Manual mount if needed:
     ```bash
     # Connect via Finder → Go → Connect to Server
     smb://peb7268@192.168.1.62/blog
     ```

3. **Verify Mount**
   ```bash
   ls -la /Volumes/blog
   # Should show index.html, blog/, about/, etc.
   ```

### Manual Build Process

**Navigate to project:**
```bash
cd /Users/pbarrick/Desktop/dev/blog
```

**Build the site:**
```bash
npm run build
```

**What happens:**
1. Astro reads markdown files from symlinked Obsidian directory
2. Processes markdown → HTML with frontmatter
3. Applies templates and styling
4. Outputs static files directly to `/Volumes/blog`
5. Nginx container automatically serves updated content

**Verify deployment:**
```bash
# Check build timestamp on remote
ls -lt /Volumes/blog/index.html

# Test in browser
open https://blog.byte-sized.io/
```

### Automated Build Process

**Cron Job Configuration:**

The build process runs automatically 3 times per day.

**Schedule**: 6:00 AM, 2:00 PM, 10:00 PM daily

**Edit crontab:**
```bash
crontab -e
```

**Cron entry:**
```cron
0 6,14,22 * * * cd /Users/pbarrick/Desktop/dev/blog && /opt/homebrew/bin/npm run build >> /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log 2>&1
```

**Breakdown:**
- `0 6,14,22 * * *` - Run at 6am, 2pm, 10pm every day
- `cd /Users/pbarrick/Desktop/dev/blog` - Navigate to project
- `/opt/homebrew/bin/npm` - Full path to npm (cron has limited PATH)
- `run build` - Execute build script
- `>> ./logs/cron-build.log 2>&1` - Append output to log file

**Important Notes:**
- Full paths required (cron has minimal environment variables)
- Test manually before relying on cron
- Requires Unraid Teleport to be connected
- If VPN disconnects, builds will fail silently

**View build logs:**
```bash
tail -f /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log
```

**Manual test of cron command:**
```bash
cd /Users/pbarrick/Desktop/dev/blog && npm run build >> /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log 2>&1
```

## Obsidian Integration

### Front Matter Format

Astro and Obsidian both use YAML front matter, making them highly compatible.

**Example post:**
```markdown
---
title: 'My Blog Post Title'
description: 'A brief description of the post for SEO and previews'
pubDate: 'Oct 22 2024'
heroImage: 'https://images.unsplash.com/photo-xyz...'
draft: false
---

# Post Content

Your markdown content here...
```

**Front Matter Fields:**
- `title` - Post title (required)
- `description` - SEO description (required)
- `pubDate` - Publication date (required)
- `heroImage` - Header image URL (optional)
- `draft` - If true, post won't be published (optional)

### Image Handling

**Current Issue:**
Obsidian image embeds (`![[image.png]]`) are not compatible with Astro.

**Workaround Options:**

1. **Use Unsplash URLs in heroImage** (recommended for hero images)
   ```yaml
   heroImage: "https://images.unsplash.com/photo-..."
   ```

2. **Use standard markdown images** (for inline images)
   ```markdown
   ![Alt text](/path/to/image.png)
   ```

3. **Future Enhancement:**
   - Create build script to convert Obsidian embeds
   - Copy images from Obsidian vault to Astro public directory
   - Replace `![[image]]` with `![image](/images/image.png)`

### Obsidian Plugin: Image Inserter

**Configuration:**
- Automatically insert Unsplash images into frontmatter
- Creates beautiful hero images for blog posts
- Auto-populates `heroImage` field in YAML

**Usage:**
1. Create new blog post in Obsidian
2. Use Image Inserter plugin to search Unsplash
3. Select image → automatically adds to frontmatter
4. Continue writing post

### Drafts Management

**Drafts Directory**: `/Users/pbarrick/Documents/Main/Resources/Learning/Blog/drafts/`

**Options for excluding drafts:**

1. **Use `draft: true` frontmatter** (recommended)
   ```yaml
   ---
   title: 'Work in Progress'
   draft: true
   ---
   ```

2. **Keep in separate folder**
   - Posts in `drafts/` folder
   - Astro config can filter by path
   - Symlink excludes drafts folder

3. **TODO**: Implement draft filtering in Astro config

## Workflow Summary

### Daily Writing Workflow

1. **Open Obsidian**
2. **Navigate to Blog folder**
   - `/Resources/Learning/Blog/`
3. **Create new post** or edit existing
   - Add proper frontmatter
   - Use Image Inserter for hero images
   - Write in markdown
4. **Save** (Obsidian auto-saves)
5. **Wait for cron** or build manually
6. **Verify on web**: https://blog.byte-sized.io/

### Publishing a New Post

**Option 1: Automated (recommended)**
1. Write post in Obsidian
2. Set `draft: false` in frontmatter
3. Save and close
4. Wait for next scheduled build (6am/2pm/10pm)
5. Post automatically appears online

**Option 2: Manual (immediate)**
1. Write post in Obsidian
2. Save
3. Connect to Unraid Teleport VPN
4. Open terminal:
   ```bash
   cd /Users/pbarrick/Desktop/dev/blog
   npm run build
   ```
5. Post immediately available online

### Updating Existing Posts

1. Edit post in Obsidian
2. Save changes
3. Wait for automated build OR trigger manual build
4. Changes reflected on website

## Troubleshooting

### Build Fails

**Check VPN connection:**
```bash
ping 192.168.1.62
```

**Check volume mount:**
```bash
ls /Volumes/blog
```

**Check npm is accessible:**
```bash
which npm
/opt/homebrew/bin/npm
```

**Check build logs:**
```bash
cat /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log
```

### Images Not Showing

**Issue**: Obsidian image embeds don't work in Astro

**Solution**:
- Use standard markdown image syntax
- Use Unsplash URLs for hero images
- Avoid `![[image]]` Obsidian syntax

### Drafts Appearing on Site

**Issue**: Draft posts are being published

**Solution**:
- Add `draft: true` to frontmatter
- Move to drafts folder if excluded by config
- Check Astro collection filters

### Cron Not Running

**Check cron is scheduled:**
```bash
crontab -l
```

**Test cron command manually:**
```bash
cd /Users/pbarrick/Desktop/dev/blog && /opt/homebrew/bin/npm run build >> /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log 2>&1
```

**Common issues:**
- VPN not connected
- Wrong npm path (check `which npm`)
- Permissions on log directory
- Mac sleeping during scheduled time

## Future Enhancements

### TODO Items

- [ ] Implement automatic Obsidian image conversion
  - Detect `![[image]]` syntax
  - Copy images to Astro public directory
  - Replace with standard markdown syntax

- [ ] Add drafts folder filtering
  - Configure Astro to exclude `drafts/` directory
  - Or use `draft: true` frontmatter exclusively

- [ ] Improve cron reliability
  - Add health check/monitoring
  - Send notification on build failure
  - Auto-reconnect VPN if dropped

- [ ] Add CI/CD pipeline
  - GitHub Actions for builds
  - Deploy on push to main
  - Remove dependency on local cron

- [ ] Image optimization
  - Move from Obsidian Sync to CDN
  - Optimize image sizes
  - Implement lazy loading

## Reference Links

- **Blog URL**: https://blog.byte-sized.io/
- **Astro Docs**: https://docs.astro.build/
- **Unraid Docs**: https://docs.unraid.net/
- **Nginx Docs**: https://nginx.org/en/docs/

## Quick Reference Commands

```bash
# Connect to VPN (via Unraid Teleport app)

# Build blog
cd /Users/pbarrick/Desktop/dev/blog && npm run build

# View build logs
tail -f /Users/pbarrick/Desktop/dev/blog/logs/cron-build.log

# Check mount
ls -la /Volumes/blog

# Edit cron
crontab -e

# Test deployment
curl -I https://blog.byte-sized.io/
```

---

**Last Updated**: October 22, 2024
**Maintained By**: Patrick Barrick
