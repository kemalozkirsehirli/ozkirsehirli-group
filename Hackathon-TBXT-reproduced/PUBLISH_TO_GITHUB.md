# Publish This Licensed Reproduced Repository to Your GitHub

## 1. Create a new empty GitHub repository

Create a new empty repo on GitHub. Do not initialize it with a README, license,
or `.gitignore` because this ZIP already contains those files.

Recommended visibility while attribution / ownership sensitivities are being
managed: **Private** or **Internal**. Use **Public** only when you are comfortable
with the source-available research license being visible to everyone.

## 2. Unzip and enter the repository

```bash
unzip Hackathon-TBXT-licensed.zip
cd Hackathon-TBXT-reproduced
```

## 3. Review public-facing metadata before pushing

Edit these files first:

```bash
$EDITOR README.md
$EDITOR LICENSE
$EDITOR NOTICE
$EDITOR AUTHORS.md
$EDITOR CONTRIBUTORS.md
$EDITOR MAINTAINERS.md
$EDITOR REPRODUCED_WORK_NOTICE.md
$EDITOR CITATION.cff
```

Keep personnel allegations out of public license/README files unless you have
written evidence and legal/institutional approval to publish them. The safer
public framing is: current maintainership, historical contribution attribution,
and reproduced-work provenance.

## 4. Push with the helper script

```bash
bash PUBLISH_TO_GITHUB.sh git@github.com:YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git "Your Name" "your.email@example.com"
```

For HTTPS instead of SSH:

```bash
bash PUBLISH_TO_GITHUB.sh https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git "Your Name" "your.email@example.com"
```

The helper uses `git add -f --pathspec-from-file=REPO_MANIFEST.txt` so the
initial commit includes the reproduced project files even when `.gitignore`
would normally skip generated result artifacts.

## 5. Manual commands, if you prefer not to use the script

```bash
git init
git checkout -B main
git config user.name "Your Name"
git config user.email "your.email@example.com"
git add -f --pathspec-from-file=REPO_MANIFEST.txt
git commit -m "License and reproduce TBXT hackathon research repository"
git remote add origin git@github.com:YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

## 6. Hardcoded upstream references to review

Some original project files reference previous private GitHub/Hugging Face
locations and local machine paths. Before asking others to run setup scripts,
search and update these strings as needed:

```bash
grep -RIn "anandsahuofficial\|/home/anandsahu\|git@github.com:anandsahuofficial" .
```

Common files to review:

- `TBXT/setup.sh`
- `TBXT/setup_hf.sh`
- `TBXT/dashboard/00_setup.md`
- `TBXT/dashboard/ON_DAY_PLAYBOOK.md`
- `TBXT/START.md`
- `TBXT/PROGRESS.md`
- `TBXT/final/*.md`
- `TBXT/report/*.md`

The scientific content and project layout have been preserved; hardcoded
references are operational/documentation pointers, not necessarily the right
values for your new GitHub repo.
