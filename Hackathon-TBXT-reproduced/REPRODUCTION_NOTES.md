# Reproduction Notes

Created: 2026-06-12

Source archive: `Hackathon-TBXT 2.zip`

Source archive SHA256:

```text
62e6d4d41d9e7032ba2e5dbe7e6f8aba73403ecc6e44a5717127845c8133740c
```

Processing performed:

1. Safely extracted the uploaded ZIP.
2. Removed macOS metadata that should not be committed to GitHub:
   - `__MACOSX/`
   - AppleDouble resource-fork files named `._*`
   - `.DS_Store`
3. Preserved all substantive project files from the archive.
4. Added GitHub publication helper files:
   - `PUBLISH_TO_GITHUB.md`
   - `PUBLISH_TO_GITHUB.sh`
   - `CONTRIBUTORS.md`
   - `LICENSE_PENDING.md`
   - `REPO_MANIFEST.txt`
   - `.gitattributes`
5. Ran syntax-only validation:
   - Python: `py_compile` on all `.py` files.
   - Shell: `bash -n` on all `.sh` files.

No project scripts were executed. Syntax checks do not validate scientific correctness, external dependencies, private bundle availability, or runtime access to Google Drive / Hugging Face / GitHub resources.

Important repository note:

The included `.gitignore` intentionally ignores many generated data/result paths to prevent huge regenerated artifacts from being accidentally committed. Because this reproduced ZIP intentionally includes some small data and result artifacts, use `PUBLISH_TO_GITHUB.sh` or the `git add -f --pathspec-from-file=REPO_MANIFEST.txt` command in `PUBLISH_TO_GITHUB.md` for the initial commit.

Archive entry count: 602

Removed metadata entry count: 308

Final repository file count: 262
