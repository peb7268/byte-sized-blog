// Place any global data in this file.
// You can import this data from anywhere in your site by using the `import` keyword.

export const SITE_TITLE = 'Paul Barrick';
export const SITE_TAGLINE = 'iterate daily. ship fast';
export const SITE_DESCRIPTION =
  'Paul Barrick — building agentic systems and marketing infrastructure in Denver. Writing on AI agents, PKM, and shipping in the open.';

// Personal-brand surface
export const AUTHOR_NAME = 'Paul Barrick';
export const AUTHOR_HANDLE = 'paul@barrick.dev';
export const AUTHOR_LOCATION = 'Denver, CO';
export const AUTHOR_TAGLINE =
  'Building agentic systems and marketing infrastructure that ships in days, not quarters.';
export const AUTHOR_BIO_SHORT =
  'I build software with AI agents — Optimus (a context engine for engineering teams), the harness layer that lets it swap models, and a steady stream of musings on what changes when development becomes agentic.';

// --- Series surface (blog index sidebar + heatmap) --------------------------
// Pin a few series to the sidebar, in display order. Edit this list to re-pin.
export const PINNED_SERIES = [
  'Agentic Foundations',
  'Agentic Engineering',
  'The New Ways of Working',
];

// Per-series accent color + one-line blurb + optional badge label.
// Any series not listed falls back to DEFAULT_SERIES_META.
export const SERIES_META: Record<string, { color: string; blurb: string; label?: string }> = {
  'Agentic Foundations': { color: '#0d9488', blurb: 'The on-ramp — read this first.', label: 'Start Here' },
  'Agentic Engineering': { color: '#4f46e5', blurb: 'The flagship series.', label: 'The Flagship' },
  'The New Ways of Working': { color: '#d4af37', blurb: 'How the job itself is changing.' },
  'Ship Confidence': { color: '#16a34a', blurb: 'Evals — ship on proof, not vibes.' },
  'Token Economics': { color: '#2563eb', blurb: 'What your agents cost, and how to trim it.' },
  'PCMS': { color: '#7c3aed', blurb: 'Personal context management, systematized.' },
  'Sustainable AI': { color: '#e0662e', blurb: 'The honest tradeoffs.' },
  'Standalone': { color: '#6b7280', blurb: 'One-off pieces.' },
};
export const DEFAULT_SERIES_META = { color: '#6b7280', blurb: '' };

// --- Star posts (homepage "Recent writing" featured strip) ------------------
// Hand-picked flagship pieces, shown as cards above the recent-writing list.
// Order here is display order; each must be a live (draft:false) post slug.
export const STAR_POSTS = [
  'the-new-caste-system',
  'what-agentic-development-actually-is',
  'the-review-is-the-work-now',
];
