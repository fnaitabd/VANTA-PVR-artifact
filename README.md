# VANTA-PVR Artifact

This repository contains the implementation and validated experimental material accompanying the preprint **“Prefix Visibility Ratio: Quantifying Partial Observability in Carpet Bombing Detection.”** It provides the VANTA detection pipeline, Mininet experiment drivers, task-adapted reference implementations, validated campaign outputs, result-verification scripts, and figure-regeneration utilities.

This public release is a **frozen artifact for the validated campaign reported in the paper**. Ongoing experimental extensions and subsequent development are maintained separately and are not part of the results reported here.

## Authors

Farid Naït-Abdesselam, Laaziz Lahlou, Doha Bentaoussy, Hugo Lege, Eve Lin, and Nadjia Kara.

## Artifact contents

```text
config/                 Experiment configuration
vanta/                  VANTA topology, traffic, telemetry, detection, and fusion modules
experiments/            Static tests, live Mininet campaigns, and comparative evaluation
results/published/      Validated result files supporting the reported claims
scripts/                Numerical result verification
plots/                  Scripts that regenerate principal experimental figures
figures/published/      Pre-generated figures corresponding to the validated release
docs/                   Additional implementation documentation
```

The comparative methods are named **NetRadar-S**, **FlowLens-S**, and **Whisper-S**. The `-S` suffix is intentional: these are task-adapted, feature-level reference implementations evaluated on the common binary prefix-level detection task. They are **not** exact reproductions of the original end-to-end systems or their original objectives.

## Release scope

Release **`v1.0-arxiv`** corresponds to the validated experimental campaign used in the preprint. In particular, it contains:

- the complete 2,160-run VANTA campaign output;
- code and configuration for the validated VANTA implementation;
- comparative traces/results used for matched-observability analysis;
- task-adapted NetRadar-S, FlowLens-S, and Whisper-S references;
- scripts that verify the principal numerical claims; and
- scripts/data used to regenerate the principal result figures.

No experimental branch developed after the validated campaign is included in this release.

## Tested environment

The validated campaign was executed with:

- Ubuntu 24.04
- Python 3.12.3
- Mininet 2.3.0
- Open vSwitch 3.3.4
- 10 virtual CPUs
- 16 GB RAM

Result verification and figure regeneration do not start Mininet. Full live experiments require Linux, root privileges, Mininet, Open vSwitch, and Linux traffic control.

## Environment setup

On Ubuntu 24.04:

```bash
sudo apt update && sudo apt install -y mininet openvswitch-switch iproute2 iperf3 python3-venv
```

Create a virtual environment with access to the system Mininet package:

```bash
python3 -m venv --system-site-packages .venv
.venv/bin/pip install -r requirements.txt
```

Run the static checks after Mininet is installed:

```bash
make validate
```

Verify the principal numerical claims directly from the included validated results:

```bash
make verify-results
```

The final line should report:

```text
ALL PAPER RESULT CHECKS PASSED
```

Install the plotting dependency and regenerate the principal figures:

```bash
.venv/bin/pip install -r requirements-plot.txt
make figures
```

Generated figures are written under `plots/generated/`.

## Live Mininet smoke test

The following command executes one topology and exports the comparative traces required by the baseline analysis:

```bash
sudo env PYTHONPATH=. .venv/bin/python -m experiments.run_paper run \
  --config config/default.yaml \
  --output results/vanta_smoke.csv \
  --runtime-root results/vanta_smoke_runtime \
  --aur 0.20 --pvr 0.05 --attack-fraction 0.50 \
  --repetitions 1 --max-topologies 1 --no-resume \
  --export-comparison-traces
```

Validate the exported trace:

```bash
.venv/bin/python -m experiments.run_comparison validate \
  --trace-root results/vanta_smoke_runtime
```

## Complete VANTA campaign

Generate the experimental plan without starting Mininet:

```bash
.venv/bin/python -m experiments.run_paper plan \
  --config config/default.yaml \
  --output results/vanta_campaign_plan.csv
```

Execute the complete 30-repetition campaign and export comparative traces:

```bash
sudo env PYTHONPATH=. .venv/bin/python -m experiments.run_paper run \
  --config config/default.yaml \
  --output results/vanta_final_30reps.csv \
  --runtime-root results/comparison_runtime_30reps \
  --no-resume --export-comparison-traces
```

Train and evaluate the full-visibility upper-bound references using repetitions 1--10 for training, 11--15 for validation, and 16--30 for testing:

```bash
.venv/bin/python -m experiments.run_comparison run \
  --trace-root results/comparison_runtime_30reps \
  --output-directory results/comparison_analysis_30reps
```

Run the matched-observability analysis, which retrains and evaluates each reference method using only destinations marked as monitored:

```bash
.venv/bin/python -m experiments.run_visibility_comparison \
  --trace-root results/comparison_runtime_30reps \
  --full-summary results/comparison_analysis_30reps/comparison_summary.csv \
  --vanta-final-csv results/vanta_final_30reps.csv \
  --output-directory results/visibility_comparison_30reps
```

The complete campaign is computationally intensive. The files under `results/published/` allow readers to verify the reported numerical claims and regenerate the principal figures without rerunning Mininet.

## Observation regimes

The comparative artifact distinguishes two regimes:

- **Full visibility:** gateway packet sketches are available for every active destination. This is reported only as an optimistic upper bound.
- **Matched observability:** training, threshold selection, and testing are restricted to the same monitored destination set that defines destination-specific visibility for VANTA.

The primary comparison in the paper uses matched observability.

## Reproducibility notes

- Configured PVR values define the experimental grid; effective PVR is recomputed from the realized attacked/observable intersection.
- Aggregate VANTA metrics are obtained from pooled confusion-matrix counts.
- Comparative PVR-dependent figures first pool AUR and attack extent within each held-out repetition, then report the mean and two-sided Student-$t$ 95% confidence interval across repetitions 16--30.
- See `PAPER_RESULTS.md`, `ARTIFACT_EVALUATION.md`, and `COMPARISON_PROTOCOL.md` for the exact mapping between artifact outputs and paper claims.

## Safety note

Live commands refuse to start when an Open vSwitch bridge already exists unless explicitly overridden. They do not invoke global Mininet cleanup, reducing the risk of terminating unrelated Mininet experiments.

## Citation

Citation metadata is provided in `CITATION.cff`. Once the arXiv identifier and archival DOI are available, this metadata can be updated without changing the validated code or result files.

## License

The artifact is released under the MIT License for research and reproducibility.
