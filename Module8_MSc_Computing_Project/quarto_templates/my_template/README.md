# Quarto Thesis Title Page

This project creates a professional title page for your Master's thesis at University of Essex.

## Files Included

1. **thesis-title.qmd** - Main Quarto document with YAML metadata
2. **before-body.tex** - Custom LaTeX template for the title page
3. **preamble.tex** - LaTeX preamble with additional packages
4. **README.md** - This file

## Setup Instructions

### 1. Download the University of Essex Logo

You need to obtain the official University of Essex logo:

**Option A: From University Resources**
- If you have access to the University's brand resources, download the official logo from your staff/student portal

**Option B: Download from Public Sources**
- Visit: https://commons.wikimedia.org/wiki/File:University_of_Essex_logo.svg
- Download the SVG file
- Convert to PNG using an online converter or image software
- Recommended size: 800-1200px width
- Save as `university-logo.png` in your project directory

**Option C: Alternative Format**
- You can also use PDF, EPS, or other formats supported by LaTeX
- If using a different format, update the `logo:` field in the YAML header

### 2. File Structure

Organize your files like this:
```
thesis-project/
├── thesis-title.qmd
├── before-body.tex
├── preamble.tex
├── university-logo.png
└── README.md
```

### 3. Render to PDF

Open a terminal in your project directory and run:

```bash
quarto render thesis-title.qmd --to pdf
```

Or in RStudio/VS Code with Quarto extension:
- Open `thesis-title.qmd`
- Click "Render" button

## Customization

### Adjust Title Page Layout

Edit `before-body.tex` to modify:
- Logo size: Change `width=0.4\textwidth` to desired size
- Spacing: Adjust `\\[Xcm]` values for vertical spacing
- Alignment: Modify `\centering`, `\flushleft`, `\flushright`
- Font sizes: Change `\huge`, `\Large`, `\large` as needed

### Update Metadata

Edit the YAML header in `thesis-title.qmd`:
```yaml
title: "Your Title"
subtitle: "Your Subtitle"
author: "Your Name"
date: "Month Year"
supervisor: "Supervisor Name"
cosupervisor: "Co-Supervisor Name"
```

### Change Date Format

The date is currently set to "March 2026". You can change it to:
- Specific date: `date: "15 March 2026"`
- Use current date: `date: today`
- Remove date: Delete the `date:` line

## Requirements

- Quarto (version 1.3 or higher)
- LaTeX distribution (TinyTeX, TeX Live, or MiKTeX)
- University of Essex logo file

### Install Quarto
Download from: https://quarto.org/docs/get-started/

### Install TinyTeX (Recommended)
```bash
quarto install tinytex
```

## Troubleshooting

### Logo not appearing
- Ensure `university-logo.png` is in the same directory as `thesis-title.qmd`
- Check the filename matches exactly (case-sensitive)
- Verify the image file is not corrupted

### LaTeX errors
- Ensure all .tex files are in the same directory
- Check that all LaTeX packages are installed
- Run `quarto check` to verify your installation

### Font issues
- The template uses `lmodern` fonts (Latin Modern)
- If unavailable, remove the line from `preamble.tex`

## Output

The rendering process will generate:
- **thesis-title.pdf** - Your final PDF with the custom title page
- **thesis-title.tex** - Intermediate LaTeX file (kept for debugging)
- Supporting files in `thesis-title_files/` directory

## Additional Notes

- The title page follows academic thesis formatting conventions
- Page numbering starts after the title page
- The template uses `\cleardoublepage` to ensure content starts on the right page
- Margins are set to 30mm on all sides (adjustable in YAML)

## Support

For Quarto documentation: https://quarto.org/docs/
For LaTeX help: https://www.latex-project.org/help/

## License

This template is provided for academic use. The University of Essex logo is trademarked and should only be used for official university purposes.
