import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
	// Load Markdown and MDX files in the `src/content/blog/` directory.
	// Exclude private/ and drafts/ folders from build
	loader: glob({
		base: './src/content/blog',
		pattern: ['**/*.{md,mdx}', '!private/**', '!drafts/**']
	}),
	// Type-check frontmatter using a schema
	schema: z.object({
		title: z.string(),
		description: z.string(),
		// Transform string to Date object
		pubDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		// Accept string URLs for hero images (Unsplash, local paths, etc.)
		heroImage: z.string().optional(),
		draft: z.boolean().optional(),
		// Series grouping: posts sharing a `series` are linked via SeriesNav (First/Prev/Next),
		// ordered by `seriesOrder`. `tags` drive the "You might also like" (similar) selection.
		series: z.string().optional(),
		seriesOrder: z.number().optional(),
		tags: z.array(z.string()).optional(),
	}),
});

// INTERNAL DRAFTS COLLECTION — DO NOT REMOVE (see scribble.md / AGENTS.md "gated draft route").
// In-progress drafts live in the vault's `drafts/` subfolder and render at `/internal/<slug>`,
// which is gated by the Cloudflare Access app "Blog Internal Content" (email-OTP, Paul only).
// This is the authenticated preview route. Removing this collection or the src/pages/internal/*
// routes silently un-gates the draft workflow — exactly the regression the CF Pages migration caused.
const internal = defineCollection({
	loader: glob({
		base: './src/content/blog/drafts',
		pattern: '**/*.{md,mdx}',
	}),
	schema: z.object({
		title: z.string(),
		description: z.string(),
		pubDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		heroImage: z.string().optional(),
		draft: z.boolean().optional(),
		series: z.string().optional(),
		seriesOrder: z.number().optional(),
		tags: z.array(z.string()).optional(),
	}),
});

export const collections = { blog, internal };
