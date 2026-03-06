# AgriBot Assets

## Image Placeholders

This directory contains image assets for the AgriBot login page.

### Required Images:

#### 1. **farm_background.png**
- **Size**: 500x500 px (recommended)
- **Purpose**: Background image for the System Status Card (gets blurred and overlaid with green tint)
- **Suggested Content**: Farm/field landscape image
- **Format**: PNG
- **Location**: Place here as `assets/images/farm_background.png`

#### 2. **google_logo.png**
- **Size**: 24x24 px (recommended)
- **Purpose**: Google logo for the "Continue with Google" button
- **Suggested Content**: Official Google 'G' logo
- **Format**: PNG
- **Location**: Place here as `assets/images/google_logo.png`

## How to Add Images:

1. Save your PNG images to this directory
2. Keep the exact filenames:
   - `farm_background.png`
   - `google_logo.png`
3. Run `flutter pub get` to ensure assets are registered
4. The app will automatically use these images

## Notes:

- If images are not found, the app will show fallback designs
- The farm background will be automatically blurred and have a green overlay applied
- The Google logo will fallback to a blue 'G' if the image is missing
