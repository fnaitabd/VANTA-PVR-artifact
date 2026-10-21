# Reproducibility Guide

## Level 1: Static validation

Expected duration is below five minutes on a suitable machine. This level validates the topology configuration, traffic generation, detector construction, comparative feature extraction, Python syntax, and the campaign plan. Mininet must be installed because the topology modules are imported, but no live experiment is started.

```bash
make validate
```

## Level 2: Published-result verification

Expected duration is below one minute and does not require Mininet. It recomputes the principal aggregate VANTA metrics, PVR-estimation diagnostics, detection-delay diagnostics, and comparative claims from the included CSV files.

```bash
make verify-results
```

The final line should report:

```text
ALL PAPER RESULT CHECKS PASSED
```

## Level 3: Figure regeneration

Install the optional plotting dependency and regenerate the principal experimental figures:

```bash
.venv/bin/pip install -r requirements-plot.txt
make figures
```

Generated files are written under `plots/generated/`.

## Level 4: Live smoke test

This level requires Ubuntu, root privileges, Mininet, Open vSwitch, and Linux traffic control. It executes one topology and validates the exported comparison trace. Commands are provided in `README.md`.

## Level 5: Complete campaign

This level recreates the 2,160 VANTA campaign runs and comparative traces, then trains and evaluates the three task-adapted reference implementations. It is computationally intensive. A dedicated Ubuntu VM with at least 10 virtual CPUs and 16 GB RAM is recommended.

## Expected principal values

The validated campaign contains 2,160 successful rows. Pooled over all evaluation windows, it yields approximately:

- precision: 99.18%
- recall: 93.46%
- F1-score: 96.24%
- false-positive rate: 1.54%
- mean absolute PVR-estimation error: 0.0246
- median absolute PVR-estimation error: 0.00077
- valid detection delays: 2,139 of 2,160 runs
- mean valid detection delay: 4.12 s
- median valid detection delay: 4.00 s

Under matched observability with configured `PVR <= 0.10`, VANTA reaches approximately:

- F1-score: 95.89%
- recall: 92.39%
- accuracy: 94.72%
- false-positive rate: 0.63%

The strongest matched reference in this regime is NetRadar-S-Matched. These figures concern the common binary prefix-level detection task; they are not an end-to-end victim-localization comparison with the original NetRadar system.
