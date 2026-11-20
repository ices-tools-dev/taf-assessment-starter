---
name: taf-assessment
description: Build a new ICES stock assessment as a TAF analysis, starting from
             a TAF template or an earlier assessment. Use this skill when the
             developer wants to set up, start, or convert a stock assessment
             in TAF, or asks which template to use.
---

# New TAF stock assessment

This skill extends the general TAF workflow skill (`taf-workflow`). Read that
one for how TAF workflows are structured and run. The rules cited here as
`[ID]` are in `../references/rules.md`.

The developer may be an expert on the stock but not on R or TAF. Explain each
step briefly in plain words, show what was made, and ask before moving on.

## Who decides what

The developer decides everything about the science: the data, the model, its
configuration, priors, reference points, and the forecast settings. Never
invent or guess these. If a value is missing, ask for it. If the template has an
example value, say so and ask whether to keep it.

The AI agent decides how the code is laid out, following the TAF rules.

## 1. Ask about the stock

Start with the stock code and the assessment year, then look the stock up in
the ICES Stock Information Database (SID), with its OData v4 service:

```
https://sid.ices.dk/services/odata4/StockListDWs4
  ?$filter=StockKeyLabel eq 'cod.27.46a7d20' and ActiveYear eq 2026
  &$select=StockKeyLabel,StockKeyDescription,ActiveYear,ExpertGroup,
           AdviceDraftingGroup,DataCategory,ModelName,ModelType,
           PreviousStockKeyLabel,YearOfLastAssessment
```

The answer is JSON, with one record for each stock and year in `value`. It
gives:

- `ExpertGroup`: the working group, e.g. WGNSSK;
- `AdviceDraftingGroup`: e.g. ADGNS;
- `DataCategory`: the ICES category, e.g. 1, or 3.2;
- `ModelName` and `ModelType`: e.g. SAM, A (age-based).

Assume the assessment is for the current year. If SID has no records for the
current year yet, use the latest year it has
(`$orderby=ActiveYear desc&$top=1&$select=ActiveYear`).

If no record matches, the code is probably wrong. List the stocks of the same
species for that year, using the first part of the code:

```
https://sid.ices.dk/services/odata4/StockListDWs4
  ?$filter=startswith(StockKeyLabel,'cod.') and ActiveYear eq 2026
  &$select=StockKeyLabel,StockKeyDescription,ExpertGroup
```

Suggest the codes that best match the areas in the developer's code, with
their descriptions, and ask which one they meant.

Show the developer what was found and confirm it is the right stock. Then find
out:

- the ICES category and the model or method, if SID has none, or they are
  changing;
- whether there is an earlier assessment of the stock in TAF
  (`ices-taf/<year>_<stock>_assessment`), or on stockassessment.org;
- the data: which files, where they come from, and whether any are restricted
  (RDB, InterCatch, RDBES, VMS, logbooks) [D3];
- what the assessment must produce: the summary table, a forecast, SAG upload,
  a report.

## 2. Choose a starting point

1. An earlier TAF assessment of the same stock is usually the best start, if it
   runs. Check it with the `taf-qc` skill.
2. Otherwise use the template that fits, from `templates.md`. Tell the
   developer what the template does and what it lacks.
3. If nothing fits, start from `taf.skeleton()` [L7].

Confirm the choice with the developer.

## 3. Set up the repository

Copy the starting point into the assessment repository. Then:

- use a `boot` folder, renaming `bootstrap` if needed [L1];
- copy only the scripts the analysis runs, so that `deps()` finds only the
  packages it needs;
- remove the example's data and results;
- write the `.gitignore` entries of `taf.skeleton()` [L6];
- remove anything that breaks the rules, such as a top-level script that
  installs packages [C6, S6].

## 4. Boot

1. Put the files the developer provides in `boot/initial/data` [B6].
2. Data to download go in a boot script `boot/<key>.R`, or a URL entry for a
   file that is always there [B11, B13].
3. Write `boot/DATA.bib` with `draft.data()`, then fill in each entry with the
   developer [B3, B16]. Keep restricted data off GitHub [D3].
4. Use R packages from CRAN or the `fishfollower`, `ices-tools-prod` and
   `flr` r-universes, and install the missing ones with
   `install.packages(deps(installed = FALSE), repos = ...)` [S0]. Declare only other
   software, such as a model executable, in `boot/SOFTWARE.bib` [S1, S2, S3].
5. Run `taf.boot()`. Check that `boot/data` has what `data.R` will read [B9].

## 5. The four scripts

Write and run one script at a time, with `source.taf()`, in this order:

| Script | Makes | Show the developer |
|---|---|---|
| `data.R` | `data/`: input tables as CSV [F2, F3] | the tables, and plots of the inputs |
| `model.R` | `model/`: the fit, diagnostics, forecast | convergence, and the diagnostics [T6] |
| `output.R` | `output/`: result tables as CSV [F4] | the summary table |
| `report.R` | `report/`: plots and rounded tables [C9, F5] | the plots |

Data flow forwards: each script reads only from `boot/data` and the folders of
earlier steps (`report.R` may read `output`, `model`, `data` and `boot/data`),
and writes only to its own folder [C1, C2]. Start each one with a short header
of what it reads and writes [C11].
Use the TAF helpers [C10], and keep the packages to those the analysis needs
[C12]. Plots may use base R or ggplot2; follow the template.

After each script, compare the results with the developer's expectations, and
with the earlier assessment if there is one. Raise any difference; do not
adjust the analysis to make it go away.

## 6. Check

1. Run the integrity check of `taf-workflow` [R1].
2. Run the `taf-qc` skill and fix what it finds.
3. Tell the developer which template markers the assessment has, and which are
   missing [T1–T10].

## Record

Keep a short `README.md` in the repository: the stock, the method, the
starting point it was made from, and the decisions the developer made.
