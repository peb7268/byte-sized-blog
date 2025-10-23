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
	}),
});

export const collections = { blog };
