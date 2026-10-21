# Mapping Between Artifact Results and Paper Claims

This release corresponds to the validated campaign reported in **“Prefix Visibility Ratio: Quantifying Partial Observability in Carpet Bombing Detection.”**

## Complete VANTA campaign

`results/published/vanta_final_30reps.csv.gz` contains 2,160 successful runs. Summing TP, TN, FP, and FN over all rows gives:

- TP = 20,187
- TN = 10,634
- FP = 166
- FN = 1,413

Computing the metrics from these pooled counts gives the paper's global values: precision 99.18%, recall 93.46%, F1-score 96.24%, and FPR 1.54%.

The same file also supports the reported visibility-estimation and delay diagnostics. The mean absolute PVR-estimation error is approximately 0.0246, the median is approximately 0.00077, 2,139 runs have a valid detection delay, and the corresponding mean/median delays are approximately 4.12 s and 4.00 s.

## Matched-observability comparison

`results/published/visibility_comparison_low_pvr.csv` pools held-out test windows for repetitions 16--30. It supports the configured low-visibility (`PVR <= 0.10`) values of 95.89% F1-score and 92.39% recall for VANTA, together with the reported differences relative to the strongest matched reference.

## PVR-dependent comparative figures

`results/published/comparative_f1_vs_pvr_matched_per_repetition.csv` first pools AUR values and attack extents within each held-out repetition and configured PVR value. The plotted values are then the mean across 15 held-out repetitions with a two-sided Student-t 95% confidence interval.

Configured PVR values define the experimental grid. For small finite attacked sets, neighboring nominal values can map to identical or near-identical realized overlaps. Estimator-error analysis therefore uses the realized effective PVR stored in the campaign data rather than assuming that the configured label is exact.

## Intrinsic figures

The summary files under `results/published/intrinsic/` support the intrinsic performance, AUR--PVR heatmap, PVR-estimation error, and detection-delay figures. Pre-generated validated PDFs are available under `figures/published/`; the scripts under `plots/` regenerate corresponding figures from the published CSV files.

Small differences between pooled metrics and means of repetition-level or run-level metrics are expected because F1-score is nonlinear and because the aggregation conventions answer different questions.
