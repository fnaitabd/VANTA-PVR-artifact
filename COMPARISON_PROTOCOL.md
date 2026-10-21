# Comparative Evaluation Protocol

## Methods

The artifact evaluates four methods on common one-second windows:

- **VANTA**, the visibility-aware detector proposed in the paper
- **NetRadar-S**, a lightweight server-assisted and cross-destination adaptation
- **FlowLens-S**, a packet-size and inter-arrival histogram adaptation
- **Whisper-S**, a packet-sequence frequency-domain adaptation

The `-S` suffix must be retained because these are task-adapted feature-level reference implementations for the common binary prefix-level detection task. They preserve representative feature constructions used in the comparative study but do not execute the original end-to-end pipelines, datasets, or original task objectives.

## Observation regimes

The comparative evaluation distinguishes two regimes.

### Full-visibility upper bound

Gateway packet sketches are available for every active destination. This regime estimates the performance attainable when traffic-side evidence is complete. It is not the primary comparison because it provides more attacked-destination visibility than the deployment model studied by VANTA.

### Matched observability

Only destinations marked `monitored` are retained for baseline training, feature selection, threshold tuning, and testing. VANTA is evaluated using its independently validated campaign over the same held-out repetition numbers. This is the primary paper comparison because all methods are assessed under equivalent attacked-destination visibility.

## Baseline features

### NetRadar-S

For every retained destination and one-second window, NetRadar-S uses packet count, byte count, mean packet length, packet-length variance, minimum packet length, maximum packet length, receive rate, connection rate, source diversity, protocol distribution, resource utilization, and a server-feature availability indicator. The destination vector is augmented with permutation-invariant network-wide means and maxima. A Random Forest performs destination classification and a top-fraction aggregation produces the prefix score.

### FlowLens-S

FlowLens-S uses 375 packet-size bins and 500 inter-arrival bins. An initial Random Forest ranks feature importance. The ten strongest candidates are retained, 20 deterministic six-feature subsets are evaluated on validation data, and the selected six features train the final Random Forest.

### Whisper-S

Whisper-S retains up to 160 packet embeddings per destination and window. Each embedding combines packet size, protocol or TCP state, and logarithmic inter-arrival time. Five 32-point FFT blocks are computed and the first 16 spectral magnitudes are averaged before Random Forest classification.

## Data split

The 30 repetitions are partitioned before model fitting:

- training repetitions 1--10
- validation repetitions 11--15
- test repetitions 16--30

Classifiers are fitted only on training repetitions. FlowLens-S feature selection and all baseline thresholds use only validation repetitions. Comparative performance is reported only on test repetitions.

## Metrics

The artifact reports precision, recall, F1-score, false-positive rate, accuracy, and detection delay. Destination labels are derived from the attack generator's actual target set. Prefix-window labels follow the benign and attack phases of each campaign round.

## Published claims

The principal comparisons in the paper use `VANTA-Validated` against `NetRadar-S-Matched`, `FlowLens-S-Matched`, and `Whisper-S-Matched`. `VANTA-Paired-Fixed` and `VANTA-Paired-Calibrated` are diagnostic variants and are not used as the main VANTA result.
