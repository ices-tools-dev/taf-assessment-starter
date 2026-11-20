---
name: taf-ggplot
description: Convert base R plots to ggplot2 plots, or create new ggplot2 plots
             in TAF scripts. Use this skill when the developer mentions ggplot
             or ggplot2 in a TAF workflow (data.R, model.R, output.R, report.R).
             Covers which files may be edited, the utilities.R theme, and the
             visual style.
---

# TAF plots with ggplot2

This skill extends the general TAF workflow skill (`taf-workflow`). Read that
one for how TAF workflows are structured and run. Invoking this skill means the
developer has asked for ggplot2 in TAF scripts, which overrides the general
preference of base R code in TAF scripts.

The base graphics code in a TAF repository is often deliberately simple. The
purpose of converting base R plots to ggplot2 is to produce better looking
figures while keeping the code simple and readable. The conversion should only
change the plotting code, not the data or numerical computations.

## Scope

Generally, only these files should be edited in a workflow:

- `report.R` and `report_*.R`: the plotting code
- `utilities.R`: the plot theme (if the workflow includes multiple ggplots)

The `model.R` and `output.R` scripts should not be edited.

Load ggplot2 with `library(ggplot2)` in the report script. Target the current
version of ggplot2 only, with no backward-compatibility code.

## Workflow

1. Run the integrity check first (see "Verification") so you know the workflow
   runs before you make any changes.

2. Read the existing report script and note what each plot shows, including any
   grouping, sorting, and calculations the script does after plotting.

3. Convert one plot, run the workflow, and look at the rendered PNG. If you
   cannot view images, say so and ask the developer to check.

4. Iterate on formatting with the developer. Make small, focused edits per
   round.

5. Run the verification again after each round and report what changed and what
   you checked.

Flag anything that disagrees between files instead of silently fixing it. For
example, if an axis label says one unit and `model.R` computes another, tell the
developer and let them decide.

## Output pattern

Use the TAF function `taf.png()` as the graphics device and organize the
ggplot() and plot() calls between `taf.png()` and `dev.off()`:

```r
taf.png("biomass")
p <- ggplot(...)
plot(p)
dev.off()
```

`source.all()` also runs `utilities.R`, so that file should contain function
definitions only, with no side effects.

## Verification

After every change, check that only the plots changed:

1. In R, from the workflow directory: `library(TAF)`, `clean.boot(force=TRUE)`,
   `clean()`, `taf.boot()`, `source.all()`.

2. Confirm all scripts ran without errors or warnings.

3. Take note of the CSV files that are created in the workflow. They should not
   change when converting to ggplot2 code. If a CSV changed, the conversion
   altered the analysis. Find out why and fix it before continuing.

4. Look at the PNG image and evaluate whether the new ggplot looks good and
   shows the same data as the original base plot.

## Visual style

The following preferences may serve as a useful starting point when formatting a
new ggplot. Start here, then adjust when asked.

- Palette: Instead of grayscale, prefer a color palette. Use the color palette
  consistently between ggplots within the same workflow.

- Title: bold, centered, no subtitle. Axis titles short. No axis title when the
  labels are self-explanatory.

- Base text size 12, with value labels sized to match (about 0.3 times the base
  size) if they are used. No numbers on bars.

- Light gridlines. Scatterplots and line plots should have both x and y
  gridlines, while barplots and boxplots have gridlines on the value axis.

- Draw barplots without borders around the bars.

- Keep a 10 percent margin on the value axis so the highest values do not touch
  the edge: `scale_y_continuous(expand=expansion(mult=c(0, 0.1)))`.

- Ensure there is space around the plot title and axis title. This space could
  be approximately equivalent to the height of an uppercase character. The exact
  amount of space is not that important, as long as the titles are not too close
  to the nearest plot elements.

– Ensure there is an outer margin between the plot and the image extent. The
  extent of the margin could be similar to that used in presentation slides. The
  exact margin is not that important, as long as the plot does not extend too
  near the edge of the image.

- Legend inside the plot, top left if there is space. Use small text and a white
  background without a border. Make sure that the legend does not overlap with
  any data points. If the top-left corner is occupied, choose another location
  and say so. In the case of horizontal grouped barplots, prefer a vertical
  legend layout and ensure that legend entries are in the same order as the bars
  in the plot: series A at the top, series B at the bottom.

If the workflow contains multiple ggplots, a common style can be implemented
inside the `utilities.R` script.
