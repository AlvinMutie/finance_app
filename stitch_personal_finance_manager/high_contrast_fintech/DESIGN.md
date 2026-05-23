---
name: High-Contrast Fintech
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c9c4d8'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#938ea1'
  outline-variant: '#484555'
  surface-tint: '#cabeff'
  primary: '#cabeff'
  on-primary: '#31009a'
  primary-container: '#947dff'
  on-primary-container: '#2a0088'
  inverse-primary: '#603ce2'
  secondary: '#7bd0ff'
  on-secondary: '#00354a'
  secondary-container: '#00a6e0'
  on-secondary-container: '#00374d'
  tertiary: '#98da27'
  on-tertiary: '#213600'
  tertiary-container: '#6ba000'
  on-tertiary-container: '#1c2f00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e6deff'
  primary-fixed-dim: '#cabeff'
  on-primary-fixed: '#1c0062'
  on-primary-fixed-variant: '#4816cb'
  secondary-fixed: '#c4e7ff'
  secondary-fixed-dim: '#7bd0ff'
  on-secondary-fixed: '#001e2c'
  on-secondary-fixed-variant: '#004c69'
  tertiary-fixed: '#b2f746'
  tertiary-fixed-dim: '#98da27'
  on-tertiary-fixed: '#121f00'
  on-tertiary-fixed-variant: '#334f00'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.04em
  headline-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  container-margin: 20px
  gutter: 16px
---

## Brand & Style

This design system is engineered for the next generation of personal finance, blending the precision of institutional banking with the vibrant energy of consumer tech. The brand personality is **modern, bold, and authoritative**, utilizing a high-contrast dark aesthetic to reduce cognitive load while highlighting critical data points.

The visual style is a sophisticated mix of **Glassmorphism** and **High-Contrast Dark Mode**. It prioritizes legibility through deep black backgrounds, allowing vibrant neon accents to act as functional signifiers rather than mere decoration. The emotional response is one of confidence and clarity—premium but accessible, technical but intuitive.

## Colors

The palette is anchored by a **true black (#000000) background**, providing infinite depth and maximizing the "pop" of the accent colors. 

- **Primary (Vibrant Purple):** Used for primary actions and major data segments.
- **Secondary (Neon Blue):** Used for secondary trends and informational highlights.
- **Tertiary (Lime Green):** Reserved for growth, positive trends, and success states.
- **Quaternary (Electric Orange):** Used for warnings, attention-seeking data, or specific spending categories.
- **Neutral (Grayscale):** A range of cool grays provides structure. Surface levels use subtle transparency to maintain the glassmorphic effect.

## Typography

This design system exclusively uses **Manrope** to maintain a clean, geometric, and modern feel. Typography is highly hierarchical:

- **Large Numbers:** Financial totals and primary data visualizations use `display-lg` with extra-bold weights to command attention.
- **Contrast:** High-weight headers are paired with medium-weight body text to ensure a clear reading path.
- **Tracking:** Headings use slight negative letter-spacing for a tighter, "editorial" look, while labels use increased tracking for legibility at small scales.

## Layout & Spacing

The layout utilizes a **fluid grid system** that prioritizes vertical rhythm and ample whitespace to prevent data fatigue. 

- **Mobile:** A 4-column grid with 20px side margins.
- **Desktop:** A 12-column centered grid with a maximum content width of 1280px.
- **Rhythm:** An 8px base unit governs all dimensions. Components are grouped in "cards" that use `spacing-lg` between them to define distinct functional areas.
- **Data Density:** While the overall layout is airy, internal card data uses a tighter `spacing-sm` to keep related financial metrics connected.

## Elevation & Depth

Depth is achieved through **Glassmorphism and Tonal Layering** rather than heavy drop shadows.

- **Level 0:** True Black (#000000) background.
- **Level 1 (Cards):** Surface color (#121212) with a 1px solid border (#262626).
- **Level 2 (Overlays):** Semi-transparent surfaces with a `20px` backdrop blur and a subtle inner glow (white at 5% opacity) on the top edge to simulate light hitting a glass surface.
- **Interactions:** Hover states and active buttons use a soft, colored outer glow (bloom effect) matching the component's accent color to create a "neon" feel.

## Shapes

The shape language is characterized by **generous rounding**. This softens the high-contrast color palette, making the interface feel friendly and "bouncy" rather than aggressive. 

- **Containers:** Standard cards use `rounded-lg` (1rem). 
- **Interactive Elements:** Buttons and input fields follow the `rounded-lg` pattern for consistency.
- **Data Visualization:** Charts must use rounded caps. The segmented circular charts utilize a thick stroke width with fully rounded ends for each segment to maintain the tactile aesthetic.

## Components

### Buttons
Primary buttons are high-contrast: white text on a primary accent background. Secondary buttons use the "ghost" style with a 1px border and a subtle backdrop blur. All buttons feature `16px` of internal horizontal padding and a minimum height of `48px`.

### Data Visualization
- **Segmented Donut:** Thick `24px` segments with `4px` gaps between them. Each segment represents a category.
- **Progress Bars:** Sleek, `8px` height bars with rounded caps. The track is a dark gray (#1A1A1A), and the fill is a vibrant gradient of the accent color.

### Cards
Cards are the primary container. They should always have a subtle `1px` border to separate them from the pure black background. Use backdrop-blur only when a card sits on top of a colored background or another element.

### Input Fields
Inputs are dark-themed with a subtle `1px` border that transitions to the primary accent color when focused. Use Manrope `body-md` for user-entered text.

### Navigation
The navigation bar (bottom on mobile, side on desktop) uses a glassmorphic blur effect to allow content to subtly bleed through, creating a sense of height and premium finish.