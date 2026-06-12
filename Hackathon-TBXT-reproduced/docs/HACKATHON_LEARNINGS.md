# Hackathon Playbook

Lessons from running ML hackathons. Read this before your next one. Hackathon-agnostic.

> The point is not to remember what we built. The point is to remember what to do *differently* next time.

---

## 1. The single most important rule

**OOF cross-validation scores do NOT predict external-test performance when the test set is from a different distribution (different institutions, scanners, populations, time periods).**

Every hackathon we've seen has this property. Cross-validation tells you how the model fits *your training distribution*. The leaderboard tells you how it fits *theirs*. They are different problems.

Practical consequences:
- A model with OOF log loss 0.34 can score 0.68 on the leaderboard -- worse than a "dumber" model with OOF 0.55.
- Picking "best fold" by OOF can hurt: that fold may have happened to align with your training distribution.
- Ensembles that look great on OOF can be worse on OOD because they all share the same training-distribution bias.

**Heuristic:** if your OOF score is *much* better than the public leaderboard baseline, suspect overfitting to your training distribution. Trust the leaderboard.

---

## 2. Pre-hackathon (the week before)

### Build the official environment, twice

The starter code's `requirements.txt` specifies an exact framework version (e.g. `torch==2.8.0`). The judges run *their* venv against your model. If your model was trained with a different version's behaviour, prediction can silently differ.

Build the official venv from `requirements.txt` exactly as documented, *and* a development venv with whatever extras you want for training. Keep them separate. Use the official one for `predict.sh`.

```bash
# Official venv -- matches scoring environment
virtualenv .venv/official
source .venv/official/bin/activate
pip install -r starter/requirements.txt

# Dev venv -- training, extras, notebooks
virtualenv .venv/dev
source .venv/dev/bin/activate
pip install -r starter/requirements.txt
pip install optuna shap matplotlib jupyter ipywidgets
```

### Read the starter code end-to-end

Not skim. Read every file. The starter code's pre-trained baseline is often the strongest single submission you'll see all event. Understand *why* before deciding to replace it.

Things that bit us last time and would have been obvious from a careful read:
- The hyperparameter `colsample_bytree=0.1` (10% feature subsampling per tree) was *the* regularizer for high-dimensional data. Our Optuna search blew past it.
- The argparse `choices=` whitelist silently rejected our new loss function.
- The submission script `cd`'d to the team root, not the script directory -- breaking relative paths.

### Test the full submission pipeline

Write a fake `test_metadata` from a slice of training data. Run `predict.sh` against it locally. Confirm:
- The script finds `predict.py`
- The right venv activates
- The model loads
- Predictions write to the expected output path

If you can't do this, you cannot submit, no matter how good your model is.

### Set up a backup workflow

Before the event, decide and *script* the backup workflow. Don't improvise it under time pressure.

```bash
# In the submission directory, before any change:
mkdir -p backup_working
cp predict.sh predict.py backup_working/
cp -r weights/ backup_working/   # or checkpoints/

# Restore:
cp backup_working/predict.* .
cp -r backup_working/weights/* weights/
```

The leaderboard model is production. Treat any change to it as a deploy.

### Drill the team

The biggest gap last time was *execution speed*, not preparation. The remedy is repetition.

- Have every coder run the full pipeline (train → save → predict.sh → submit) at least twice on dummy data
- Time it. If it takes more than 20 minutes from "start training" to "submission deployed", figure out why
- Have non-coders own a slide template *with placeholder numbers* so the moment the result lands, the slide is filled in

---

## 3. Day-of execution rules

### Submit something within the first hour

The first leaderboard score you submit is the *baseline starter code*. Just deploy it. Don't tune anything. Don't even read the data yet.

Why: getting on the leaderboard verifies that submission works end-to-end. If something is broken (venv path, file location, GPU access), you find out in hour 1, not hour 5. This single rule would have saved us hours.

### Always have a working baseline behind every change

Never overwrite the live submission. Always:
1. Train the new candidate to a *separate* directory
2. Compare on whatever validation you have
3. Backup live → deploy candidate → wait for leaderboard
4. If it gets worse: revert *immediately* from backup

If it takes more than 60 seconds to revert, your backup workflow is broken. Fix that before doing anything else.

### Don't iterate on the public leaderboard

The leaderboard is usually 20-30% of the final test set. Iterating to climb it can overfit to that subset. If the leaderboard is volatile (other teams swinging by 0.1+ between submissions), that's a sign it's a small slice and noisy.

**Rule:** make at most 3-5 leaderboard submissions per challenge. Each should be a deliberate experiment, not a tuning step.

### Stop coding 60 minutes before the deadline

Last hour: presentation, submission verification, sanity-check that `predict.sh` still runs, `weights/` files have the right timestamps. No new code, no new training, no new ideas.

If you're tempted to start a 30-minute training run "just in case", you're going to ship a half-finished model. Don't.

---

## 4. Modelling strategy on OOD test sets

When the test set is from a different distribution:

**Prefer:**
- Simpler models with strong regularization (dropout, weight decay, label smoothing)
- Tree models with aggressive feature subsampling (`colsample_bytree=0.05-0.15` for high-D)
- Single well-calibrated model over complex ensembles
- Temperature scaling for probability calibration (cheap, often helps)
- The starter code's pre-tuned baseline as your floor

**Avoid:**
- Aggressive feature selection on high-dimensional data (let the tree handle it)
- Ensembles of similar models trained on the same data (they share the same OOD bias)
- Picking "best fold" by OOF metric (that fold may be the most OOD-fragile)
- Optuna on small datasets without a holdout: you'll overfit the search

**The "lower score without overfitting" principle:**

A model with OOF log loss 0.55 that's *robust* will likely beat a model with OOF 0.34 that's *brittle* on the full hidden test set. The fancy model that ranks #1 on the public leaderboard often plummets on full evaluation. Aim for the simpler, calibrated, less-aggressive model. Boring wins.

---

## 5. Calibration is half the score

For log-loss-scored competitions, calibration matters as much as discrimination. A model with AUC 0.74 and well-calibrated probabilities beats a model with AUC 0.78 and overconfident predictions.

Cheap calibration techniques that always help:
- **Temperature scaling**: fit a single scalar `T` on a validation set; divide logits by `T` before softmax. Reduces overconfidence.
- **Label smoothing during training**: replace 0/1 targets with 0.05/0.95. Built-in regularization against overconfidence.
- **Isotonic regression** as a post-hoc calibrator if you have enough validation data.

For regression with outliers:
- **Huber loss** (instead of MSE/MAE) is robust to extreme values.

---

## 6. Team composition realities

**The biggest team risk is concentration.** If 2 of 5 members do all the coding, those 2 cannot afford to lose an hour on environment debugging. The non-coders are blocked until the coders ship something.

Practical mitigations:
- **Non-coders own the presentation from hour 0**, with placeholder numbers. The moment a result lands, they fill it in.
- **Non-coders own the leaderboard watch.** They refresh it every few minutes and report changes. Coders shouldn't be context-switching.
- **Non-coders own the submission verification.** They are the second pair of eyes that confirms `predict.sh` ran without errors.
- **Pair programming when stuck.** If a coder is debugging for 15+ minutes, get the other coder on the screen. Solo debugging during a hackathon is expensive.

**If your team has skill gaps in coding/ML:** lean *harder* on the starter code. The starter code is likely the best baseline you can ship. Your modifications should be small, surgical, and well-understood. Big architectural rewrites are how teams without depth lose hours.

---

## 7. Psychological management

The leaderboard is a slot machine. It rewards short-term action and punishes long-term thinking. Watch for these failure modes:

### Sunk-cost iteration

You've made 5 changes to challenge A and it's still at rank 7. You feel like you're "almost there" with one more tweak.

**Reality check:** if 5 changes haven't moved you, the next one probably won't either. Pivot to a different challenge where you haven't yet hit the wall.

### Late-game gambling

It's the last hour. You're in 6th place. You ship a risky change because "we have nothing to lose."

**Reality check:** you have your current rank to lose. We did this -- went from rank 4 to rank 8 in the final hour by deploying an ensemble that looked great in CV. Lock the working submission *before* the last hour.

### Leaderboard staring

Refreshing the leaderboard every 30 seconds. Reading the gap between you and #1. Comparing teams.

**Reality check:** the leaderboard is information, not action. Set a fixed cadence (every 5 min) and have a non-coder report changes. Coders should be heads-down on whatever they're building.

### Comparing to winners during the event

You see team X at 0.49 log loss when you're at 0.63. You start trying to figure out what they did.

**Reality check:** you don't know what they did. Maybe they overfitted the public leaderboard and will lose on the full test. Maybe they got lucky. Run your own race. Compare *after* the event when results are public.

---

## 8. Submission discipline (the rules)

These are non-negotiable. Tape them above the monitor.

1. **Never modify the live submission directly.** Always: train to candidate dir → backup live → swap in → wait for score → revert if worse.
2. **Backup before any change** to `predict.sh`, `predict.py`, `weights/`, or `checkpoints/`.
3. **Verify the venv path** in `predict.sh` matches the venv your model was trained with (or that has the right framework version).
4. **Run `predict.sh` end-to-end against fake test data** at least once before relying on it.
5. **Check the leaderboard timestamp** to confirm your last submission was scored. If the timestamp didn't update, the judges didn't run yours.
6. **Lock the submission 60 min before deadline.** No more changes, only verification.

---

## 9. Reusable patterns

### Temperature scaling

```python
from scipy.optimize import minimize_scalar
import numpy as np
from sklearn.metrics import log_loss

def fit_temperature(y_true, y_prob):
    y_logit = np.log(y_prob / (1 - y_prob))
    def neg_ll(T):
        cal = 1 / (1 + np.exp(-y_logit / T))
        return log_loss(y_true, np.clip(cal, 1e-6, 1-1e-6))
    return minimize_scalar(neg_ll, bounds=(0.1, 20.0), method='bounded').x
```

### Label-smoothed cross-entropy (PyTorch, manual for binary)

```python
SMOOTH = 0.10
target = torch.zeros(1, 2, device=device)
target[0, label] = 1.0 - SMOOTH
target[0, 1 - label] = SMOOTH
loss = -(target * F.log_softmax(logits, dim=-1)).sum()
```

### Optuna hyperparameter search (XGBoost classifier on tabular)

```python
import optuna

def objective(trial):
    params = {
        "n_estimators": 2000, "learning_rate": 0.02,
        "max_depth": trial.suggest_int("max_depth", 3, 8),
        "min_child_weight": trial.suggest_int("min_child_weight", 1, 50),
        "subsample": trial.suggest_float("subsample", 0.5, 1.0),
        "colsample_bytree": trial.suggest_float("colsample_bytree", 0.05, 0.3),
        "reg_alpha": trial.suggest_float("reg_alpha", 0.0, 10.0),
        "reg_lambda": trial.suggest_float("reg_lambda", 0.0, 10.0),
        "early_stopping_rounds": 100,
        "tree_method": "hist", "eval_metric": "logloss",
    }
    # 5-fold CV with early stopping
    ...

study = optuna.create_study(direction="minimize")
study.optimize(objective, n_trials=100, timeout=600)
```

But: only trust Optuna if you have a holdout that's distributionally similar to test. On small data with OOD test, the search will overfit.

### Backup workflow

```bash
# Before deploy
mkdir -p backup_$(date +%H%M)
cp predict.sh predict.py *.json backup_$(date +%H%M)/
cp -r weights backup_$(date +%H%M)/

# Quick revert
cp backup_$(date +%H%M)/* .
```

---

## 10. Pre-hackathon checklist

Tick each item before the event starts.

- [ ] Official venv built from starter `requirements.txt`, framework version verified
- [ ] Dev venv built with extras (optuna, jupyter, etc.)
- [ ] All starter code files read end-to-end
- [ ] Submission pipeline tested with dummy data
- [ ] Backup workflow scripted (not improvised)
- [ ] Backup directory created in each challenge dir
- [ ] Team aligned on roles (who codes, who watches leaderboard, who owns slides)
- [ ] Slide template created with placeholder numbers
- [ ] Compute access verified (GPU visible, queue working)
- [ ] Git repo initialized, `.gitignore` set, push tested
- [ ] Time-boxed plan: which challenge gets which hours
- [ ] Lock-down time decided (60 min before deadline)

---

## 11. Post-mortem template

After every hackathon, fill this in within 48 hours while it's fresh.

```markdown
## Hackathon: <name>, <date>
### Final result: <rank>/<total>

### What we shipped
- Challenge A: <model>, score <x>
- ...

### What worked
- (only things you'd repeat)

### What didn't
- (only things you'd not repeat)

### Time analysis
- Hours spent on environment setup: __
- Hours spent on training: __
- Hours spent on submission debugging: __
- Hours spent on presentation: __

### The decision I'd reverse
- (one specific decision, not "we should have prepared more")

### Update the playbook?
- (concrete additions / edits to this doc)
```

---

## 12. The honest summary

After every hackathon I've seen, the post-mortem comes back to the same handful of failures:

1. **We over-prepared infrastructure and under-rehearsed execution.** Setting up venvs, repos, and pipelines is satisfying but not the bottleneck on event day.
2. **We replaced strong starter code with weaker custom code.** Starters are pre-tuned by people who know the data; treat them as the floor, not the ceiling.
3. **We chased the public leaderboard and overfitted to it.** Locked-in robustness beats slot-machine optimization.
4. **We didn't lock submissions early enough.** The last hour of changes usually hurt.
5. **We assumed CV scores predicted test scores.** They don't, when the test set is OOD.
6. **We didn't pivot fast enough.** Sunk cost on one challenge meant another one stayed at baseline.

If you do nothing else, do these:
- Submit baseline starter code to leaderboard within hour 1.
- Make at most 5 leaderboard submissions per challenge.
- Lock submissions 60 minutes before deadline.
- Trust the boring, calibrated, well-regularized model over the fancy tuned one.

Boring wins.
