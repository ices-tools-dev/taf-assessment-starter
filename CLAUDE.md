# TAF stock assessment

This repository is an ICES stock assessment in the Transparent Assessment
Framework (TAF): `boot/` holds the input data, and the scripts `data.R`,
`model.R`, `output.R` and `report.R` run in that order.

- To build or change the assessment, use the `taf-assessment` skill. To check
  it, use `taf-qc`. Follow `taf-workflow` for how TAF analyses are run.
- The rules the skills cite as `[ID]` are in
  `.claude/skills/references/rules.md`.
- Install the R packages the scripts use before the boot:

  ```r
  library(TAF)
  install.packages(deps(installed = FALSE),
                   repos = c("https://fishfollower.r-universe.dev",
                             "https://ices-tools-prod.r-universe.dev",
                             "https://flr.r-universe.dev",
                             "https://cloud.r-project.org"))
  ```

- The stock assessor makes every scientific decision: data, model, its
  configuration, reference points, forecast settings. Ask; never guess.
- Never upload anything to ICES (SAG, ASD, DATSU) or elsewhere; write the
  upload files and leave the upload to the assessor.
