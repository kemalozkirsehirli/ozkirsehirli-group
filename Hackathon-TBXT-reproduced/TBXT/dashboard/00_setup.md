# Task 0 — Setup + Environment Distribution

**Owner:** Each team member runs `setup.sh` themselves. **Compute:** any A100 + 28-core CPU machine. **Effort:** ~30 min per member (mostly download). **Blocks:** all other tasks.

## ⚡ TL;DR for team members (you)

```bash
# 1. Clone the repo anywhere
git clone git@github.com:anandsahuofficial/Hackathon.git ~/Hackathon
cd ~/Hackathon/TBXT

# 2. Run setup. Defaults to ~/Hackathon; pass a path arg to override.
bash setup.sh                                # default: ~/Hackathon
# or
bash setup.sh /opt/work                      # custom: /opt/work/Hackathon
# or
TBXT_ROOT=/data/h bash setup.sh

# 3. Done. Find your task assignment in dashboard/MEMBERS.md.
```

That's it. The script is idempotent — safe to re-run if something glitches.

## What setup.sh does

| Step | Action | Time |
|---:|---|---|
| 1 | Verify prerequisites (bash, tar, sha256sum, wget/curl, git) | < 1 s |
| 2 | Install Miniconda at `~/miniconda3` if not present | ~1 min |
| 3 | Clone (or pull) the GitHub repo to `<TBXT_ROOT>/Hackathon` and checkout the TBXT branch | ~10 s |
| 4 | Download from public Drive (via `wget`/`curl`): env tarball (9.9 GB), data bundle (1.6 GB), CHECKSUMS, MANIFEST | ~10 min on fiber |
| 5 | Verify all bundles via `sha256sum -c CHECKSUMS.sha256` | < 5 s |
| 6 | Unpack conda env to `~/miniconda3/envs/tbxt` and run `conda-unpack` | ~3 min |
| 7 | Unpack data bundle into the project: `bin/gnina`, `data/`, etc. | ~30 s |
| 8 | Run `scripts/team/setup_check.sh` (12 sanity checks) | < 5 s |
| 9 | Run `tests/smoke_test.py` (full RDKit→Vina→GNINA→QSAR pipeline on 1 compound) | ~10 s |
| **Total** | | **~15 min** |

## What you'll have after setup

- **Project root:** `<TBXT_ROOT>/Hackathon/TBXT/` (default: `~/Hackathon/TBXT/`)
- **Conda env:** `~/miniconda3/envs/tbxt/` (RDKit + Vina + Meeko + GNINA libs + Boltz + OpenMM + OpenFF + xgboost + sklearn + scipy)
- **GNINA binary:** `<TBXT_ROOT>/Hackathon/TBXT/bin/gnina` (executable)
- **Receptor:** prepped 6F59 G177D PDBQT at `data/dock/receptor/6F59_apo.pdbqt`
- **All 540+ docking results, 650-compound QSAR training set, all validation reports** under `data/`
- **All scripts** are path-portable — work from any project root

## Drive folder

Bundles are at: **https://drive.google.com/drive/folders/100ivRu-oFAL6fmvjqaHiBRaycGI3yP41?usp=sharing**

setup.sh downloads them automatically from public file IDs hardcoded in the script. You don't need a Google account.

## Verify after setup

```bash
source ~/miniconda3/etc/profile.d/conda.sh
conda activate tbxt
cd ~/Hackathon/TBXT

# Re-run smoke test anytime
python tests/smoke_test.py
```

Expected output ends with: `=== ALL SMOKE-TEST CHECKS PASSED ===`

## What you're solving

Get the workspace + Python env onto every team member's machine in ≤ 30 min per member, with zero manual conda/pip troubleshooting. The current environment took ~6 hours to set up (cuDNN, cuequivariance, scipy fix, GNINA binary, etc.) — we are NOT doing that 10 times.

## What you produce

1. A **public-but-private git repo** with the workspace contents (everything except the 2 GB GNINA binary + 356 MB Naar SPR XLSX archive)
2. A **Drive bundle** with the data the repo doesn't include + the conda-pack tarball
3. Instructions members can copy-paste

---

## Coordinator notes (already done — skip if you're a regular member)

The bundles are already uploaded to Drive and the repo is on GitHub. The steps below are kept as documentation of how the bundles were produced, in case they need to be regenerated.

## Step 1: prepare the git repo

```bash
cd /home/anandsahu/Hackathon/TBXT

# Init repo if not already
git init -b main

# .gitignore: exclude big files
cat >> .gitignore << 'EOF'
bin/gnina
data/naar/*.xlsx
data/naar/spr_decrypted/
data/dock/receptor/*.cif
data/full_pool_gnina_F/poses/
data/full_pool_gnina_F/ligands/
data/dock/validation_*/poses/
data/dock/validation_*/ligands/
data/analogs/smoke_test_*/poses/
data/analogs/smoke_test_*/ligands/
data/analogs/ensemble_smoke_F/*/poses/
data/dock/ensemble_F/*/poses/
data/boltz/runs/*/boltz_results_*/processed/
data/boltz/runs/*/boltz_results_*/lightning_logs/
__pycache__/
*.pyc
data/snapshots/
EOF

git add -A
git commit -m "Initial workspace state — TBXT hackathon team handoff"

# Push to remote (create at github.com/<team>/tbxt-hackathon, private)
git remote add origin <REPO_URL>
git push -u origin main
```

Repo size after gitignore: ~50 MB (manageable for clone).

## Step 2: pack the conda env

```bash
# Install conda-pack into base
/home/anandsahu/miniconda3/bin/conda install -n base -c conda-forge -y conda-pack

# Pack the tbxt env
cd /tmp
/home/anandsahu/miniconda3/bin/conda-pack -n tbxt -o tbxt_env.tar.gz \
    --ignore-missing-files --exclude '*.pyc' --exclude '__pycache__'

ls -lh tbxt_env.tar.gz   # expect ~3-4 GB
```

## Step 3: bundle the data deferred from git

```bash
mkdir -p /tmp/tbxt_data_bundle
cp /home/anandsahu/Hackathon/TBXT/bin/gnina /tmp/tbxt_data_bundle/        # 2 GB
cp /home/anandsahu/Hackathon/TBXT/data/naar/*.xlsx /tmp/tbxt_data_bundle/ # 180 MB
cp -r /home/anandsahu/Hackathon/TBXT/data/naar/spr_decrypted /tmp/tbxt_data_bundle/  # 180 MB
cp /home/anandsahu/Hackathon/TBXT/data/dock/receptor/*.cif /tmp/tbxt_data_bundle/    # ~1 MB
cd /tmp
tar -czf tbxt_data_bundle.tar.gz tbxt_data_bundle/
ls -lh tbxt_data_bundle.tar.gz   # expect ~2.5 GB
```

## Step 4: upload to Drive

Drive folder: **https://drive.google.com/drive/folders/100ivRu-oFAL6fmvjqaHiBRaycGI3yP41?usp=sharing**

Upload these from `/tmp/tbxt_drive/`:
- `tbxt_env.tar.gz` (9.9 GB) — packed conda env
- `tbxt_data_bundle.tar.gz` (1.6 GB) — `bin/gnina` + `data/` (raw + decrypted SPR + receptors + results + snapshots)
- `CHECKSUMS.sha256` — verify file integrity after download
- `MANIFEST_data_bundle.txt` — what's in the data bundle

After upload, copy the folder URL into the per-member instructions in Step 5 (already done — see folder URL above).

### Upload methods

**Method A — Web UI (simplest):** open the folder URL in a browser, drag-and-drop the 4 files. Wait ~10 min on a fiber line for the 11.5 GB to upload.

**Method B — `rclone` (recommended for repeat uploads):**
```bash
# One-time setup:
curl https://rclone.org/install.sh | sudo bash
rclone config       # follow Drive setup; name remote "drive"

# Upload:
cd /tmp/tbxt_drive
rclone copy tbxt_env.tar.gz drive:TBXT_handoff/ -P
rclone copy tbxt_data_bundle.tar.gz drive:TBXT_handoff/ -P
rclone copy CHECKSUMS.sha256 drive:TBXT_handoff/
rclone copy MANIFEST_data_bundle.txt drive:TBXT_handoff/
```

**Method C — `gdrive` CLI:** `gdrive files upload --parent <folder_id> /tmp/tbxt_drive/tbxt_env.tar.gz`

## Step 5: per-member instructions (paste into team channel)

```bash
# Time: ~30 min per member (mostly download time)

# 1. Clone the repo
git clone git@github.com:anandsahuofficial/Hackathon.git ~/tbxt
cd ~/tbxt
git checkout TBXT     # the event branch with all the work

# 2. Download the env tarball + data bundle from Drive folder
#    https://drive.google.com/drive/folders/100ivRu-oFAL6fmvjqaHiBRaycGI3yP41?usp=sharing
#
#    Click each file in the Drive UI to get a direct download URL, OR use gdown:
pip install gdown
gdown <env_file_id> -O tbxt_env.tar.gz             # 9.9 GB
gdown <data_file_id> -O tbxt_data_bundle.tar.gz    # 1.6 GB
gdown <checksums_file_id> -O CHECKSUMS.sha256

# Verify integrity
sha256sum -c CHECKSUMS.sha256

# 3. Unpack the env (workspace becomes the conda env directory)
TBXT_DIR="$HOME/tbxt"
mkdir -p $HOME/miniconda3/envs/tbxt
tar -xzf tbxt_env.tar.gz -C $HOME/miniconda3/envs/tbxt
source $HOME/miniconda3/envs/tbxt/bin/activate
conda-unpack       # finalize the unpacked env paths

# 4. Unpack the data bundle into the cloned repo
tar -xzf tbxt_data_bundle.tar.gz -C $TBXT_DIR/TBXT/
chmod +x $TBXT_DIR/TBXT/bin/gnina

# 5. Verify
cd $TBXT_DIR/TBXT
bash scripts/team/setup_check.sh
# Expected: "all 12 checks passed"

# 6. Find your task in dashboard/MEMBERS.md
cat dashboard/MEMBERS.md
# Then read your task brief: dashboard/NN_<task>.md
```

## Success criteria

- All 10 members have run `setup_check.sh` and reported "all 12 checks passed" in LIVE_TRACKER.md.
- Each member can run `python -c "import vina, meeko, rdkit; from openmm.app import PDBFile; print('ok')"` without error.
- Each member can run `LD_LIBRARY_PATH=$CONDA_PREFIX/lib bin/gnina --version` without error.

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Coordinator>  STATUS=done
RESULT: env tarball + data bundle uploaded to Drive (links: <env>, <data>); repo at <REPO_URL>; 10/10 members verified
DELIVERABLE: <Drive folder URL>
GOTCHAS: gdown requires `pip install gdown` if not in env
NEXT: members proceed to their assigned tasks per MEMBERS.md
```

## If something goes wrong

| Error | Fix |
|---|---|
| `conda-pack: command not found` | `conda install -n base -c conda-forge conda-pack` |
| `gdown: No such file` | `pip install gdown` (gdown for Google Drive download) |
| `conda-unpack failed: bad path` | The env tarball was extracted into the wrong dir; ensure `tar -xzf X -C ~/miniconda3/envs/tbxt/` |
| `gnina: error while loading shared libraries: libcudnn.so.9` | `export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH` (also done in scripts/team/run_*.sh) |
| Repo push rejected (size) | Re-check `.gitignore`; the GNINA binary should NOT be in git |

## Notes

- The Drive bundle is **2.5 GB + 3-4 GB = 5-6 GB total** per member to download. On a typical fiber line that's ~5-10 min.
- The env tarball is the heaviest single dependency. If a member's bandwidth is a problem, they can rebuild from `environment.yml` (slower, ~30 min but no large download).
- After unpack, conda env should auto-activate from `source ~/miniconda3/envs/tbxt/bin/activate`. If they want global `conda` command, they can `conda init bash`.
