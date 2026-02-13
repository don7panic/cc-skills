---
name: ui-old-money
description: A sophisticated design system inspired by heritage luxury brands like Ralph Lauren, Loro Piana, and private banks. Designed for shadcn/ui + Tailwind CSS with matte finishes, classic typography, and restrained elegance.
license: Complete terms in LICENSE.txt
---

# Old Money UI Design System

A sophisticated design system inspired by heritage luxury brands like Ralph Lauren, Loro Piana, and private banks. Matte finishes, classic typography, and restrained elegance define this aesthetic.

---

## Design Philosophy

### Vibe
Think heritage private bank or classic luxury lifestyle brand. High-end, classic, matte finishes. No neon colors, no excessive gradients, no flashy effects. Understated confidence.

### Whitespace
Use generous, confident whitespace. Elements breathe. Do not clutter the layout. Silence is part of the design.

### Borders
Use thin, refined borders (1px). Avoid thick outlines. Border color should be warm, muted neutrals like `border-stone-200` or `border-stone-300`.

### Shadows
Minimalist approach. Use very soft, diffused shadows (`shadow-sm` or `shadow-md` in Tailwind) or flat designs with borders. Avoid harsh drop shadows or prominent elevation effects.

### Radius
Avoid pill-shaped rounded corners (`rounded-full`). Use slightly rounded corners (`rounded-md` or `rounded-[4px]`) which feels more traditional, structured, and timeless. Sharp corners (`rounded-none`) are also acceptable for a more architectural feel.

---

## Typography System

### Headings
**Mandatory**: Use a sophisticated Serif font. This is non-negotiable for the "Old Money" look.

**Recommended**:
- Playfair Display (classic editorial)
- Cinzel (Roman-inspired caps)
- Libre Baskerville (traditional book feel)
- Cormorant Garamond (elegant, refined)

### Body Text
Use a clean, geometric Sans-serif for readability.

**Recommended**:
- Inter (clean, modern geometric)
- Lato (warm, rounded)
- Geist Sans (sharp, technical)
- Source Sans Pro (professional neutrality)

### Weights
- **Headings**: Use lighter weights (`font-light`, `font-normal`) for large headings to look elegant and refined.
- **Body**: Use standard weights (`font-normal`, `font-medium`) for readability.

---

## Color Palette

### Background
Avoid pure white (`#ffffff`). Use warm off-whites, creams, or alabaster tones.

| Token | Value | Usage |
|-------|-------|-------|
| `background` | `#F9F8F4` | Primary background (alabaster cream) |
| `background` | `#F5F5F0` | Alternative warm cream |
| `background` | `#F4F3EE` | Subtle warm paper tone |
| `card` | `#FFFFFF` | Cards with warm shadow |
| `popover` | `#FDFCF8` | Dropdowns, floating elements |

### Foreground (Text)
Avoid pure black (`#000000`). Use deep, warm dark tones.

| Token | Value | Usage |
|-------|-------|-------|
| `foreground` | `#1A1A1A` | Primary text (deep charcoal) |
| `foreground` | `#1B2E28` | Alternative (deep forest) |
| `foreground` | `#2C2420` | Warm charcoal for softer contrast |
| `muted-foreground` | `#6B6560` | Secondary text (warm grey) |

### Primary
A deep, rich accent color. Choose one anchor color:

**Option A - Forest Green**:
| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#1B4332` | Primary buttons, links |
| `primary` | `#2D5A45` | Hover states |

**Option B - Navy Blue**:
| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#1E2A3A` | Primary buttons, links |
| `primary` | `#2C3E50` | Hover states |

**Option C - Burgundy**:
| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#5D2E37` | Primary buttons, links |
| `primary` | `#722F37` | Hover states |

### Accents
Muted gold or brass (not bright yellow gold).

| Token | Value | Usage |
|-------|-------|-------|
| `accent` | `#B8956A` | Active states, highlights |
| `accent` | `#A68B5B` | Secondary accent (bronze) |
| `accent` | `#C4A77D` | Lighter gold for subtle highlights |
| `ring` | `#B8956A` | Focus rings, selection |

### Muted / Borders
Warm greys and beiges (Stone colors).

| Token | Value | Usage |
|-------|-------|-------|
| `muted` | `#E8E6E1` | Muted backgrounds |
| `border` | `#D4D0C8` | Subtle borders |
| `border` | `#C4BFB6` | More defined borders |
| `input` | `#E6E2DA` | Input field borders |
| `destructive` | `#8B3A3A` | Error states (muted red) |

---

## shadcn/ui CSS Variables Configuration

```css
:root {
  /* Background & Text */
  --background: 44 20% 97%;           /* #F9F8F4 Alabaster */
  --foreground: 0 0% 10%;             /* #1A1A1A Deep Charcoal */

  /* Cards & Popovers */
  --card: 44 25% 98%;                 /* #FDFCF8 Slightly lighter */
  --card-foreground: 0 0% 10%;
  --popover: 44 25% 99%;
  --popover-foreground: 0 0% 10%;

  /* Primary - Choose one: Forest, Navy, or Burgundy */
  --primary: 156 40% 18%;             /* #1B4332 Forest Green */
  /* --primary: 210 30% 17%; */       /* #1E2A3A Navy Blue */
  /* --primary: 350 35% 27%; */       /* #5D2E37 Burgundy */
  --primary-foreground: 44 20% 97%;

  /* Secondary - Muted neutral */
  --secondary: 40 10% 90%;            /* #E8E6E1 Stone */
  --secondary-foreground: 0 0% 12%;

  /* Muted states */
  --muted: 40 12% 92%;
  --muted-foreground: 35 6% 44%;

  /* Accent - Gold/Brass */
  --accent: 38 35% 57%;
  --accent-foreground: 0 0% 10%;

  /* Destructive - Muted burgundy-red */
  --destructive: 0 35% 38%;
  --destructive-foreground: 44 20% 97%;

  /* Borders & Inputs */
  --border: 40 12% 81%;
  --input: 40 11% 88%;
  --ring: 38 35% 57%;

  /* Radius - Refined, traditional */
  --radius: 0.25rem;                  /* 4px - slightly rounded */
}

.dark {
  --background: 0 0% 11%;             /* #1C1C1C Soft black */
  --foreground: 44 20% 95%;           /* Cream text */
  --card: 0 0% 13%;
  --card-foreground: 44 20% 95%;
  --popover: 0 0% 13%;
  --popover-foreground: 44 20% 95%;
  --primary: 156 30% 28%;             /* Deeper green for dark mode */
  --primary-foreground: 44 20% 95%;
  --secondary: 0 0% 20%;
  --secondary-foreground: 44 20% 95%;
  --accent: 38 30% 47%;               /* Muted gold */
  --accent-foreground: 0 0% 11%;
}
```

---

## Tailwind CSS Configuration

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        // Old Money specific tokens
        olm: {
          cream: '#F9F8F4',
          alabaster: '#F5F5F0',
          charcoal: '#1A1A1A',
          forest: '#1B4332',
          navy: '#1E2A3A',
          burgundy: '#5D2E37',
          gold: '#B8956A',
          brass: '#A68B5B',
          stone: {
            100: '#F4F3EE',
            200: '#E8E6E1',
            300: '#D4D0C8',
            400: '#C4BFB6',
          }
        }
      },
      fontFamily: {
        serif: ['Playfair Display', 'Cinzel', 'Libre Baskerville', 'Georgia', 'serif'],
        sans: ['Inter', 'Lato', 'Geist Sans', 'system-ui', 'sans-serif'],
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      boxShadow: {
        'soft': '0 1px 3px 0 rgb(0 0 0 / 0.05), 0 1px 2px -1px rgb(0 0 0 / 0.05)',
        'card': '0 4px 6px -1px rgb(0 0 0 / 0.05), 0 2px 4px -2px rgb(0 0 0 / 0.05)',
      }
    },
  },
}
```

---

## Component Guidelines

### Buttons
```tsx
// Primary button
<button className="bg-primary text-primary-foreground px-6 py-2.5 rounded-md font-sans font-medium text-sm tracking-wide shadow-sm hover:opacity-90 transition-opacity">
  Action
</button>

// Secondary/Outline
<button className="bg-transparent border border-stone-300 text-foreground px-6 py-2.5 rounded-md font-sans font-medium text-sm tracking-wide hover:bg-stone-50 transition-colors">
  Secondary
</button>

// Ghost
<button className="bg-transparent text-foreground px-4 py-2 rounded-md font-sans font-medium text-sm hover:bg-stone-100 transition-colors">
  Ghost
</button>
```

### Cards
```tsx
<div className="bg-card border border-stone-200 rounded-md shadow-soft p-6">
  <h3 className="font-serif font-light text-2xl text-foreground mb-2">Title</h3>
  <p className="font-sans text-muted-foreground">Content body text.</p>
</div>
```

### Form Inputs
```tsx
<input
  className="w-full bg-transparent border border-input rounded-md px-4 py-2.5 font-sans text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-accent focus:border-accent transition-all"
  placeholder="Enter text..."
/>
```

### Typography Examples
```tsx
// Page title
<h1 className="font-serif font-light text-4xl md:text-5xl text-foreground tracking-tight">
  Heritage Collection
</h1>

// Section heading
<h2 className="font-serif font-normal text-2xl md:text-3xl text-foreground">
  Established 1892
</h2>

// Body text
<p className="font-sans font-normal text-base text-foreground leading-relaxed">
  The art of understated elegance lies in restraint and intention.
</p>
```

---

## What to Avoid

| Don't | Do Instead |
|-------|------------|
| Pure white backgrounds (`#ffffff`) | Warm cream (`#F9F8F4`, `#F5F5F0`) |
| Pure black text (`#000000`) | Warm charcoal (`#1A1A1A`) |
| Neon or bright colors | Muted, desaturated tones |
| Thick borders (2px+) | Thin, refined 1px borders |
| Harsh drop shadows | Soft `shadow-sm` or flat design |
| Rounded-full (pill shapes) | `rounded-md` (4px) or `rounded-none` |
| Bold headings (`font-bold`) | Light/Regular weights (`font-light`, `font-normal`) |
| Sans-serif headings | Elegant serif typefaces |
| Excessive gradients | Matte, flat surfaces |
| Cluttered layouts | Generous whitespace |

---

## Best Used For

- Heritage financial services and private banking
- Luxury lifestyle brands (apparel, leather goods, watches)
- Editorial/long-form content platforms
- Professional services for HNW individuals
- Classic hospitality (country clubs, estates, historic hotels)
- Wine and spirits brands with heritage
- Artisan/craftsmanship showcases
- Wedding and event planning (elegant/classic)
- Art galleries and antique dealers
- Academic/institutional websites

---

## Installation Quick Reference

```bash
# 1. Install shadcn/ui with stone base color
npx shadcn@latest init --yes --template next --base-color stone

# 2. Install serif fonts
npm install @fontsource/playfair-display @fontsource/cinzel

# 3. Import fonts in layout.tsx
import '@fontsource/playfair-display/400.css';
import '@fontsource/playfair-display/500.css';

# 4. Apply CSS variables to globals.css
# (Copy CSS variables from above)
```
