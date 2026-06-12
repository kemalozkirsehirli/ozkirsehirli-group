# Publish This Repository to GitHub

This ZIP is prepared so the archive root remains `Hackathon-TBXT/` and the original substantive project filenames are not renamed.

## 1. Create a new empty GitHub repository

Create a new empty repository on GitHub. Do not initialize it with a README, license, or `.gitignore`, because this ZIP already contains those files.

You can make the GitHub repository public after you review the license, attribution, third-party data notice, and any external bundle references.

## 2. Unzip and enter the repository

```bash
unzip Hackathon-TBXT-FINAL-PUBLIC-GITHUB-LOWER-RISK.zip
cd Hackathon-TBXT
```

## 3. Push with the helper script

```bash
bash PUBLISH_TO_GITHUB.sh <REMOTE_URL> "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"
```

SSH example:

```bash
bash PUBLISH_TO_GITHUB.sh git@github.com:OWNER/Hackathon-TBXT.git "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"
```

HTTPS example:

```bash
bash PUBLISH_TO_GITHUB.sh https://github.com/OWNER/Hackathon-TBXT.git "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"
```

The helper script initializes `main`, stages exactly the files in `REPO_MANIFEST.txt`, commits them, sets `origin`, and pushes.

## 4. Manual commands

```bash
git init
git checkout -B main
git config user.name "Kemal Özkırşehirli"
git config user.email "YOUR_GIT_EMAIL"
git add -f --pathspec-from-file=REPO_MANIFEST.txt
git commit -m "Release TBXT hackathon research repository"
git remote add origin <REMOTE_URL>
git push -u origin main
```

## 5. Notes before inviting collaborators

- `LICENSE` is a custom source-available research license, not an OSI-approved open-source license.
- `CITATION.cff` is present at the repository root for citation metadata.
- `.github/CODEOWNERS` is comment-only until a GitHub handle is added.
- Large third-party bundles, external model weights, raw datasets, and external service outputs may require separate terms or mirroring. See `THIRD_PARTY_AND_DATA_NOTICE.md`.
- The setup scripts no longer hardcode a former private upstream repository. For fresh clone automation, set `TBXT_REPO_URL` or `TBXT_REPO_HTTPS`; otherwise clone the public repo first and run `TBXT/setup.sh` from inside the checkout.

## Enable the Özkırşehirli Group website

This package includes `docs/index.html` for GitHub Pages. After the first push, go to GitHub **Settings → Pages**, then select **Deploy from a branch**, branch `main`, folder `/docs`. Replace the Google Form placeholder in `docs/index.html` before distributing the site URL.


## README scope

`README.md` now contains the full public-release orientation: project summary, chordoma/TBXT research context, file-preservation audit, license summary, governance/attribution, GitHub Pages setup, Google Form setup, repository structure, reproducibility limits, citation, and publication commands.
