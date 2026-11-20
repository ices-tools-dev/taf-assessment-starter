# TAF rules

One checklist of the rules a TAF analysis should follow, for the skills in this
repository to cite. Each rule gives its severity, its sources, and the check
that enforces it, if any.

**Status: draft for discussion.** Rules marked *open* need a decision; see
[Open questions](#open-questions).

## Severity

From [rules]:

- **error**: breaks a rule. The TAF server will not run the analysis.
- **warning**: a recommendation that should be straightforward to follow.
- **note**: a flag that may be an intentional feature of an unusual analysis.

## Sources

| Key | Source |
|---|---|
| [TAF] | TAF package 4.4.0 help pages, `?function` |
| [wiki] | [ices-taf/doc wiki](https://github.com/ices-taf/doc/wiki), page given |
| [rules] | [ices-taf/doc rules.md](https://github.com/ices-taf/doc/blob/master/rules.md) |
| [filenames] | [ices-taf/doc filenames.md](https://github.com/ices-taf/doc/blob/master/filenames.md) |
| [qcTAF] | [qcTAF](https://github.com/ices-tools-prod/qcTAF) 2026.05.23, README criterion or `qc.*` function |
| [dash] | [taf-qc-dashboard docs/fixing-qcTAF-issues.md](https://github.com/ices-tools-prod/taf-qc-dashboard/blob/main/docs/fixing-qcTAF-issues.md) |
| [gov] | [wg_wgtafgov claude_taf.md](https://github.com/ices-eg/wg_wgtafgov/blob/master/claude_taf.md) |
| [TRL] | [wg_wgtafgov readiness-level.qmd](https://github.com/ices-eg/wg_wgtafgov/blob/master/docs/system/readiness-level.qmd) |
| [markers] | [wg_wgtafgov github_repos.R](https://github.com/ices-eg/wg_wgtafgov/blob/master/docs/_taf/site/boot/github_repos.R), `template_markers` |
| [manifesto] | [wg_wgtafgov TAF Manifesto](https://github.com/ices-eg/wg_wgtafgov/blob/master/TAF_Manifesto/taf_manifesto.Rmd), section given |
| [workflow] | [taf-workflow/SKILL.md](../taf-workflow/SKILL.md) |
| [decision] | Decision by the TAF coordinator, date given |

## Conformance levels

From [TRL]. A skill should say which level it is aiming for.

| Level | Reached when |
|---|---|
| 1 | The assessment code is on GitHub. |
| 2 | The code passes `qcTAF::qc()`. Failing only `qc.software.bib.exists` and `qc.software.bib.valid` (no `SOFTWARE.bib`) still passes. |
| 3 | The code runs from start to finish (QC run test, under development). |
| 4 | The assessment is published in ices-advice and linked to advice. |

## 1. Layout

| ID | Rule | Severity | Sources | Check |
|---|---|---|---|---|
| L1 | The analysis has a `boot` folder at the top level. A legacy `bootstrap` folder is still accepted. | error | [qcTAF] 1; [TAF] `?taf.boot` | `qc.boot.exists` |
| L2 | The top level has the scripts `data.R`, `model.R`, `output.R` and `report.R`. `model.R` may be named `method.R`. | error, *open* (Q2) | [qcTAF] 6; [rules] 1.3.1(a); [TAF] `?source.all` | `qc.all.scripts.exist` |
| L3 | Helper functions go in `utilities.R`, which holds only definitions, with no side effects. `source.all()` runs it first. | warning | [TAF] `?source.all`; [gov]; [workflow] | none |
| L4 | TAF scripts may call other scripts with the same prefix (`data_*.R`, `report_*.R`, `utilities_*.R`) and dynamic reports (`*.Rmd`, `*.qmd`, `*.Rnw`). | note | [filenames]; [qcTAF] 6 | none |
| L5 | R scripts use the uppercase `.R` extension. | error | [rules] 1.1.1(a) | none |
| L6 | `.gitignore` excludes `/boot/data`, `/boot/library`, `/boot/software`, `/data`, `/model`, `/output` and `/report`, as written by `taf.skeleton()`. | warning | [TAF] `?taf.skeleton`; [gov] | none |
| L7 | A new analysis starts from `taf.skeleton()` or from a template. | note | [TAF] `?taf.skeleton`; [wiki] Creating TAF datasets | none |

## 2. Boot: data

| ID | Rule | Severity | Sources | Check |
|---|---|---|---|---|
| B1 | `boot/DATA.bib` exists. `DATA.bib` and `SOFTWARE.bib` exist only in `boot/`. | error | [qcTAF] 2; [rules] 1.1.1(b) | `qc.data.bib.exists` |
| B2 | `DATA.bib` can be read and has at least one entry with a non-empty `source`. | error | [qcTAF] | `qc.data.bib.valid` (checks the first entry only) |
| B3 | Each entry has the required fields. | error, *open* (Q1) | [TAF] `?draft.data`; [wiki] Bib entries; [dash]; [gov] | `qc.data.bib.missing.attributes` is documented in [dash] but not in qcTAF |
| B4 | `source` is one of: `file` or `folder` (inside `boot/initial/data`), a path starting `initial/`, a URL, a GitHub reference `owner/repo[/subdir]@ref`, or `script`. | error | [wiki] Bib entries; [TAF] `?draft.data` | none |
| B5 | A GitHub reference uses a fixed tag, release or SHA, not a branch name. | warning | [wiki] Bib entries; [manifesto] Organisation of TAF projects | none |
| B6 | Only files a person writes or uploads by hand go in `boot/initial/data`, each with an entry using `source = {file}` or `{folder}`. | warning | [gov]; [wiki] Creating TAF datasets | none |
| B7 | Nothing ever writes back into `boot/initial/data`. | error | [gov] rule 1 | none |
| B8 | `boot/data` is made by `taf.boot()` only. It is never edited by hand or committed. | error | [gov]; [TAF] `?taf.boot` | none |
| B9 | After `taf.boot()`, every `DATA.bib` entry is in `boot/data` and every file in `boot/data` has an entry. | error | [qcTAF] 3, 5 | `qc.data.bib.processed` (the dashboard treats it as a warning, because it does not run boot), `qc.data.declared` |
| B10 | A file in both `boot/initial/data` and `boot/data` has the same contents in each. | error | [qcTAF] 4 | `qc.initial.data` |
| B11 | A boot script `boot/<key>.R` has an entry with `source = {script}`. It runs inside an emptied `boot/data/<key>/` and writes there. | error | [wiki] Bib entries, Example data records; [gov] | none |
| B12 | Boot scripts run in `DATA.bib` order. A script that reads an earlier key's output (`../<key>/`) says so in its entry's `description`. | warning | [gov] | none |
| B13 | Anything that might not exist yet (a URL that can 404) is fetched by a boot script with a fallback, not a plain URL entry. | warning | [gov] | none |
| B14 | Model settings and configuration files are data: put them in `boot/initial/data` and give them a `DATA.bib` entry. | warning | [wiki] Bib entries; [TAF] `?taf.boot` | none |
| B15 | Data read from another TAF analysis are pinned to an exact version. | warning | [manifesto] Organisation of TAF projects | none |
| B16 | `access` is `Public`, `OSPAR` or `Restricted`, as coded in [vocab.ices.dk](https://vocab.ices.dk/?ref=1435). | warning | [TAF] `?draft.data` | none |

## 3. Boot: software

| ID | Rule | Severity | Sources | Check |
|---|---|---|---|---|
| S0 | R packages come from CRAN or the r-universes of `fishfollower`, `ices-tools-prod` and `flr`. They are installed before the boot with `install.packages(deps(installed = FALSE), repos = ...)`, and need no `SOFTWARE.bib` entry. | error | [decision] 2026-11-20; [TAF] `?deps` | none |
| S1 | `boot/SOFTWARE.bib` declares other key software, such as model executables. It is optional, but if it is present it must be valid. | warning (missing), error (invalid) | [TRL]; [qcTAF] 2; [workflow] | `qc.software.bib.exists`, `qc.software.bib.valid` |
| S2 | Every entry has `version` and `source`. A development version gives its branch and commit date in `version`, and a 7-character SHA in `source`. | warning | [wiki] Bib entries; [TAF] `?draft.software` | none |
| S3 | An entry comes after every entry it depends on. | error | [wiki] Bib entries; [TAF] `?taf.install` | none |
| S4 | After `taf.boot()`, every entry is in `boot/software` and every file there has an entry. | error | [qcTAF] 3, 5 | `qc.software.bib.processed`, `qc.software.declared` |
| S5 | Authors are written out in full, as `{First M Last and First M Last}`, with no commas. | note | [rules] 1.3.1(b) | none |
| S6 | Scripts never install packages. Load packages with `library()`; a package declared in `SOFTWARE.bib` is loaded from the TAF library with `taf.library()`. | error | [rules] 1.1.2(a); [TAF] `?taf.library` | none |

## 4. Scripts

| ID | Rule | Severity | Sources | Check |
|---|---|---|---|---|
| C1 | Scripts run in order: `data.R`, `model.R`, `output.R`, `report.R`. Data flow forwards: each script reads only from `boot/data` and the folders of earlier steps, and ends by writing files. So `data.R` reads `boot/data`; `model.R` also `data`; `output.R` also `model`; `report.R` also `output`. | error | [TAF] `?TAF-package`; [qcTAF] 11; [workflow] | QC run test (level 3) |
| C2 | Each script writes only to its own folder (`data.R` to `data/` and so on), and creates that folder with `mkdir()`. | error | [rules] 1.1.2(c); [qcTAF] 12; [TAF] `?source.taf` | none |
| C3 | Only files carry over between scripts, not objects in memory. The server runs `source.taf(taf = TRUE)`: `rm`, `clean` and `detach` are all `TRUE`. | error | [TAF] `?source.taf` | QC run test |
| C4 | `data.R` reads from `boot/data`, using `taf.data.path()` where it helps. | warning | [TAF] `?taf.skeleton`, `?taf.data.path`; [wiki] Creating TAF datasets | none |
| C5 | Paths are relative. No `setwd()` to a fixed location, no `C:/` or `~/`, no `/home/`. | error | [qcTAF] 7 | `qc.only.relative.paths` (top-level scripts only; it may flag a quoted URL, unverified) |
| C6 | `.libPaths`, `download`, `download.file`, `install_github`, `install.packages`, `process.bib` and `taf.boot` are used only in boot scripts. | error | [rules] 1.1.2(a) | none |
| C7 | URLs (`http`) appear only in boot scripts. | note | [rules] 1.3(a) | none |
| C8 | Text files with non-ASCII characters are UTF-8. | error | [rules] 1.1.2(b); [TAF] `?file.encoding` | none |
| C9 | No rounding (`round(`, `rnd(`, `icesRound(`) in `data.R`, `model.R` or `output.R`. Rounding is for `report.R`. | note | [rules] 1.3(b); [workflow] | none |
| C10 | Use the TAF helpers `mkdir`, `cp`, `read.taf`, `write.taf`, `taf.png` and `taf.data.path`. | warning | [gov]; [workflow]; [TAF] `?TAF-package` | none |
| C11 | Each script starts with a comment saying what it does, then `Before:` and `After:` lines listing the files it reads and writes. | warning | [workflow]; [wiki] Example cat 1 stock assessment | none |
| C12 | Keep dependencies to the packages the analysis needs. Base R and ggplot2 are both fine for plots. *open* (Q6) | warning | [workflow]; [TAF] `?TAF-package` | none |

## 5. Outputs and file formats

| ID | Rule | Severity | Sources | Check |
|---|---|---|---|---|
| F1 | Tables are CSV, raster images PNG and vector images PDF. | warning | [qcTAF] 9 | none |
| F2 | `data/` and `output/` hold the main data and results as CSV tables, written with `write.taf()`. `model/` may hold intermediate results in any format. | warning | [qcTAF] 8; [workflow] | none |
| F3 | Age-structured data use the standard names: `catage.csv`, `maturity.csv`, `natmort.csv`, `wstock.csv`, `wcatch.csv`, and `survey_<name>.csv` for each survey. | warning | [filenames] | none |
| F4 | Age-structured outputs use the standard names: `fatage.csv`, `natage.csv`, `summary.csv`, and `qatage_<survey>.csv` for each survey. Add `_est` for estimated series and `_full` for the full age range before a plus group. | warning | [filenames] | none |
| F5 | Plots are written with `taf.png()`, between it and `dev.off()`. | warning | [TAF] `?taf.png`; [workflow] | none |

## 6. Reproducibility

| ID | Rule | Severity | Sources | Check |
|---|---|---|---|---|
| R1 | A fresh clone runs successfully after a full clean: install missing packages [S0], `clean.boot(force = TRUE)`, `clean()`, `taf.boot()`, `source.all()`. | error | [qcTAF] 10; [workflow]; [TAF] `?clean` | QC run test |
| R2 | A re-run gives the same or similar results. Compare the CSV outputs row for row. | error | [qcTAF] 10; [gov] | none |
| R3 | On the server, boot runs with `taf.boot(taf = TRUE)`, which forces a download of everything. Test that way before submitting. | warning | [TAF] `?taf.boot`; [wiki] Example TAF scripts 1 | none |
| R4 | Run the integrity check (R1, then all four folders exist and are not empty) before and after any change. | warning | [workflow] | none |

## 7. Data policy and confidentiality

| ID | Rule | Severity | Sources | Check |
|---|---|---|---|---|
| D1 | No usernames, passwords or other credentials in the code. | error | [manifesto] Licensing and sensitive data | none |
| D2 | No confidential information in code or comments, such as vessel names. | error | [manifesto] Licensing and sensitive data | none |
| D3 | Restricted data (RDB, InterCatch, RDBES, VMS, logbooks) are never committed to GitHub. They have `access = {Restricted}` and are fetched on the server. | error | [manifesto] Licensing and sensitive data; [TAF] `?draft.data` | none |
| D4 | The project has separate, explicit licences for code and for data. | warning | [manifesto] Licensing and sensitive data | none |

## 8. Template completeness

These apply to the TAF templates (the `ices-tools-dev/*_taf_template` repositories) and are
recommended for assessments built from them. The markers are found by
[markers] and shown on the
[template status page](https://ices-eg.github.io/wg_WGTAFGOV/status/templates.html).

| ID | Marker | What it means | Where |
|---|---|---|---|
| T1 | inputs | Input data are checked, e.g. `stopifnot()` or a validation function | `data*.R`, `utilities*.R` |
| T2 | model | The model script does real work: at least 3 lines beyond `library`, `mkdir` and `source` | `model*.R` |
| T3 | forecast | A short-term forecast (`stf`, `forecast`, or SPiCT `manage`) | `model*.R` |
| T4 | plots | Plots are saved to files | `output*.R`, `report*.R` |
| T5 | tables | Tables are written (`write.taf`) | `output*.R`, `report*.R` |
| T6 | diagnostics | Retrospective, residuals, Mohn's rho, leave-out, hindcast, jitter, runs test or MASE | `model*.R`, `output*.R`, `report*.R` |
| T7 | report | A written report (Word, R Markdown or Quarto) | `report*.R` |
| T8 | sag | SAG XML for the Stock Assessment Graphs database | any |
| T9 | asd | ASD XML | any |
| T10 | flstock | An FLStock made as an output | `output*.R` |

Some markers don't apply to some methods. For example, Category 3 has no
forecast (the advice rules give the advice directly) and no FLStock.

## Open questions

Q1. **Required `DATA.bib` fields.** The sources disagree:

- [TAF] `?draft.data` and [wiki] Bib entries: `originator`, `year`,
  `title`, `period`, `access`, `source`. `access` is required for icesTAF
  workflows.
- [dash] `qc.data.bib.missing.attributes`: `author`, `title`, `year`,
  `source`.
- [gov]: `title` and `description`.

Q2. **Must all four scripts exist?** [qcTAF] `qc.all.scripts.exist` and
[rules] 1.3.1(a) say yes. [gov] says to leave out a stage that does nothing.
The dashboard sometimes treats this check as a warning, not a failure.

Q3. **Which templates.** [wiki] points to
`ices-taf-dev/ices_cat_3_template`, `ices_cat_5_template` and
`wiki-example-stockassessment`. The governance `templates.csv` lists
`ices-tools-dev/*_taf_template`. The skills should point to one set.

Q4. **`bootstrap/` folders.** TAF and qcTAF still accept them. Should new
work be required to use `boot/`?

Q5. **Checks to add to qcTAF.** The rules with "none" in the Check column
and severity "error" are candidates: L5, B3, B4, B7, B11, C2, C6, C8, D1.
Also:

- `qc.data.bib.valid` checks only the first entry.
- `qc.only.relative.paths` checks only top-level scripts.

Q6. **Base R or ggplot2.** [workflow] prefers base R for AI agents unless the
developer asks otherwise; `taf-ggplot` covers ggplot2 when asked. Many TAF
users prefer ggplot2, so should agents use it by default in templates?
