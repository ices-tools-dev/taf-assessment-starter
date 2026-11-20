# TAF assessment starter

A starting point for an ICES stock assessment in TAF, with Claude Code skills
that guide you through building it.

## Use

1. Make a repository from this template ("Use this template" on GitHub).
2. Open it in its dev container (VS Code: "Reopen in Container"). R, the TAF
   packages and Claude Code are installed for you.
3. Put your data files in `boot/initial/data/`.
4. Run `claude` in the terminal and ask, for example:

   > Set up this year's assessment for ple.27.7d using SAM. My data and
   > model.cfg are in boot/initial/data.

Claude looks up the stock, suggests a TAF template, and builds the boot,
data, model, output and report steps with you, asking you for every
scientific choice. It then checks the result with qcTAF and a full rerun.

## Contents

- `CLAUDE.md`: instructions for Claude in this repository.
- `.claude/skills/`: the TAF skills (`taf-workflow`, `taf-assessment`,
  `taf-qc`, `taf-ggplot`) and the rules they cite. Copied from
  [ices-taf-dev/ai](https://github.com/ices-taf-dev/ai), branch `rules-draft`,
  commit `0f76152`.
- `.devcontainer/`: R 4.6.1 with the TAF packages, GitHub CLI and Claude Code.
- `boot/initial/data/`: for your input data.
