---
name: taf-qc
description: Check a TAF analysis against the TAF rules with qcTAF, explain
             the results in plain words, and fix what fails. Use this skill
             when the developer asks whether an analysis is ready for TAF,
             asks about qcTAF or the QC dashboard, or before finishing any new
             or changed TAF analysis.
---

# TAF quality checks

This skill extends the general TAF workflow skill (`taf-workflow`). The rules
cited as `[ID]` are in `../references/rules.md`.

## Levels

The checks follow the TAF readiness levels:

- **Level 2**, the QC test: `qcTAF::qc()` passes. An analysis with no
  `SOFTWARE.bib` still passes, but one with an invalid `SOFTWARE.bib` does not.
- **Level 3**, the QC run test: the analysis runs from start to finish after a
  full clean [R1].

Say which level the analysis reaches.

## 1. Run qcTAF

```r
library(qcTAF)
qc()
```

If qcTAF is not installed, ask the developer before installing it from
`ices-tools-prod/qcTAF`.

`qc()` returns `TRUE` or `FALSE` for each check. The `*.processed` checks need
`taf.boot()` to have been run first.

## 2. Check the other rules

Some rules in `rules.md` have no qcTAF check yet. Look for these by reading the
code:

- `.R` file extensions in uppercase [L5];
- install and download functions outside boot scripts [C6, S6];
- each script reading only from `boot/data` and earlier steps [C1];
- each script writing only to its own folder [C2];
- non-ASCII text that is not UTF-8, using `file.encoding()` [C8];
- credentials or confidential information [D1, D2];
- restricted data committed to the repository [D3];
- rounding before `report.R` [C9].

## 3. Run test

1. Install missing packages with `deps()` and the r-universe repos [S0], then
   `clean.boot(force = TRUE)`, `clean()`, `taf.boot(taf = TRUE)` and
   `source.all()` [R1, R3].
2. Check that `data`, `model`, `output` and `report` exist and have files.
3. If the analysis has run before, check that the CSV outputs are the same
   [R2].

Ask the developer first if the run is likely to be long, or needs software or
access they may not have.

## 4. Report

Give one table, failures first:

| Check | Result | Rule | What it means | Fix |
|---|---|---|---|---|

Use plain words in "What it means". The
[fixing qcTAF issues guide](https://github.com/ices-tools-prod/taf-qc-dashboard/blob/main/docs/fixing-qcTAF-issues.md)
explains each qcTAF check for non-programmers, and can be linked.

## 5. Fix

Fix the layout and metadata, never the science. A fix should not change any
CSV in `data/` or `output/`. If one does, stop and tell the developer.

Ask the developer for anything only they know, such as the `title`, `period`
or `access` of a `DATA.bib` entry. Never invent metadata.

After fixing, run the checks again and report what changed.

## Known limits of qcTAF

- `qc.data.bib.valid` checks only the first entry of `DATA.bib`.
- `qc.only.relative.paths` checks only the top-level scripts.
- `qc.data.bib.missing.attributes` is described in the dashboard guide but is
  not yet in qcTAF.
