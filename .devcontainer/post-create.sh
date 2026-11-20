#!/usr/bin/env bash
# Runs once after the container is created: the R packages TAF assessments use
set -euo pipefail

apt-get update -qq
apt-get install -y -qq --no-install-recommends libcurl4-openssl-dev libssl-dev libxml2-dev git

Rscript -e '
pkgs <- c("TAF", "icesTAF", "qcTAF", "icesAdvice", "icesSAG", "icesASD",
          "icesDatsu", "icesDatsuQC", "stockassessment", "FLCore", "FLfse")
repos <- c("https://fishfollower.r-universe.dev",
           "https://ices-tools-prod.r-universe.dev",
           "https://flr.r-universe.dev", getOption("repos"))
install.packages(setdiff(pkgs, rownames(installed.packages())), repos = repos,
                 Ncpus = parallel::detectCores())
missing <- setdiff(pkgs, rownames(installed.packages()))
if (length(missing) > 0) stop("not installed: ", toString(missing))'

claude --version || echo "Claude Code not on PATH"
