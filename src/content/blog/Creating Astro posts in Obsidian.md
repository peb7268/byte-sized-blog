---
title: 'Creating Astro posts in Obsidian!'
description: 'Create markdown statically generated blog posts in Obsidian and have them automatically published to the web.'
pubDate: 'Jul 15 2022'
heroImage: "https://images.unsplash.com/photo-1524668951403-d44b28200ce0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNjAwOTd8MHwxfHNlYXJjaHw2fHxjb2ZmZWUlMjBhbmQlMjB3cml0aW5nfGVufDB8MHx8fDE3NDM1MDE2NTd8MA&ixlib=rb-4.0.3&q=80&w=1080"
---


![[Resources/General/Assets/Images/56b02883444e6f43af6eea42c23c313a_MD5.jpeg]]

> Note, this is my first blog post with Astro, and is a bit of a PoC.

## Understanding the Local-Remote Hybrid Architecture

This blog setup uses a **hybrid local/remote architecture**:

### What's Local (Always Available):
- ✅ **Blog Posts**: Written in Obsidian at `/Users/<home_folder>/Documents/Main/Resources/Learning/Blog/`
- ✅ **Astro Project**: Located at `/Users/<home_folder>/Desktop/dev/blog/`
- ✅ **Symlink**: From Astro `src/content/blog` → Obsidian Blog folder (LOCAL→LOCAL)
- ✅ **Writing & Editing**: Can be done anytime, even offline

### What's Remote (Requires Unraid Connection):
- ⚠️ **Build Output**: `/Volumes/blog` (SMB mount to Unraid at `192.168.1.62`)
- ⚠️ **Building**: Requires connection to Unraid (via Teleport VPN or local network)
- ⚠️ **Deployment**: Build writes directly to Unraid share

**Key Understanding**: The symlink is **LOCAL→LOCAL**, so it persists even when disconnected from Unraid. You can edit posts anytime in Obsidian, but can only build when connected to Unraid via VPN.

---

## Setup Instructions

1. Setup a DNS entry to point to your server.
2. Setup an nginx proxy entry
3. Run an nginx container to proxy the externally exposed port running on your server ( synology, unraid, whatever ) to the internal port 80.
```
docker run -d   --name nginx-astro   -p 3000:80   -v /mnt/user/blog:/usr/share/nginx/html:ro   nginx:alpine
```

4. Symlink the Obsidian blog folder to Astro's content directory
```bash
# Remove the default Astro blog directory
rm -rf /Users/<home_folder>/Desktop/dev/blog/src/content/blog

# Create symlink from Astro to Obsidian (LOCAL→LOCAL)
ln -s /Users/<home_folder>/Documents/Main/Resources/Learning/Blog \
      /Users/<home_folder>/Desktop/dev/blog/src/content/blog
```

**Important**: This symlink is LOCAL→LOCAL (both paths on your Mac), so it persists even when disconnected from Unraid. You can write and edit posts anytime in Obsidian.

5. Now create your post!
   When a post gets made in my Obsidian vault under my Blog folder I now automatically get free blog posts live on the web 😱.

   Well ... almost automatically.

   You still need to run `npm run build` each time you publish a new post.
   To circumvent this and fully automate it, you can run the publish job a few times a day via cron.
   Open the cron editor on Mac like so: `crontab -e` .

   Then enter the following:
```bash
0 6,14,22 * * * cd /Users/<home_folder>/Desktop/dev/blog && /opt/homebrew/bin/npm run build >> ./logs/cron-build.log 2>&1
```

**Note**: Cron builds require Unraid connection. If your Mac is sleeping or VPN is disconnected during scheduled build times (6am, 2pm, 10pm), the build will fail silently.

Voila, that should now work.

You can test it by running the command manually and checking the logs.

```bash
cd /Users/<home_folder>/Desktop/dev/blog && npm run build >> /Users/<home_folder>/Desktop/dev/blog/logs/cron-build.log 2>&1
```
This assumes npm is installed globally just like it is on my machine.

It's important to test this crontab out manually like I did because the cron daemon doesn't have the same environment variables as your shell does and can easily malfunction if it's missing a path or env var or any number of things.

### Conclusion
This is a really cool setup.

There are a few things to notice with this.

1. In the screenshot I posted at the top, you will see that the Astro header looks a lot like Obsidian front matter. This is pretty neat as they play nicely together.

2. Secondly, I took a screenshot and just dropped it right into my post here to show you this. It just magically all works. I will have to tidy this up later and move my images somewhere else most likely, because having obsidian sync host all my images like I am with that technique is probably not the best use of money.

3. One byproduct of this approach is I can write my blog posts also in my favorite IDE of choice and it will let me use copilot or some other AI tool to autocomplete my sentances 🔥.

---

## Todos & Tips:
- [ ] TODO: We'll, one thing I learned is my obsidian workflow for images has to change. When I published this first post, the Obsidian url was obviously broken. I did this at 3:30am so don't judge my first pass haha. I will have to hook something into the workflow for Astro publishing that looks for Obsidian image embed's and replaces them with the correct image path from my server. For now, i'll enjoy my links and screenshots and keep you in anticipation 😆.

- When using the Image Inserter plugin for Obsidian, you can configure it to insert the image in the frontmatter automatically so that when you write your blog posts it will grab an image from unpslash and give you beautiful hero images like the one at the top of this post.

- [ ] TODO: Make a filter for the drafts folder.
