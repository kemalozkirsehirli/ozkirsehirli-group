# Özkırşehirli Group Website Setup

This repository includes a static GitHub Pages landing page at:

```text
docs/index.html
```

## Enable GitHub Pages

After pushing the repository to GitHub:

1. Open the repository on GitHub.
2. Go to **Settings -> Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**.
4. Choose branch `main` and folder `/docs`.
5. Save.

GitHub will publish the site at a URL like:

```text
https://OWNER.github.io/REPOSITORY/
```

## Connect the Google Form button

Create a Google Form for collaborators, copy the public form URL, then replace these placeholders in `docs/index.html`:

```text
https://forms.gle/REPLACE_WITH_YOUR_GOOGLE_FORM_ID
YOUR_CONTACT_EMAIL
```

Search command:

```bash
grep -RIn "REPLACE_WITH_YOUR_GOOGLE_FORM_ID\|YOUR_CONTACT_EMAIL" docs/index.html
```

## Privacy boundary

Do not request patient information, private medical records, passwords, confidential institutional data, unpublished third-party data, or proprietary compound lists through the public form.

## Suggested website summary

Özkırşehirli Group is a computational science group building AI/CADD, molecular simulation, and reproducible research workflows for rare-cancer therapeutic discovery. The current public project focuses on chordoma research through TBXT/brachyury computational hit identification.

## Official GitHub Pages references

- https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
- https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site
- https://docs.github.com/articles/creating-project-pages-manually
