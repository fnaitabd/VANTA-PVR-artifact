# Implementation Architecture

## Network and workload layer

- `vanta/topology.py` builds the routed Mininet topology and configures the protected IPv4 prefix.
- `vanta/hosts.py` creates the active, inactive, monitored, and unmonitored destination sets from AUR and PVR.
- `vanta/traffic.py` generates legitimate TCP and UDP traffic.
- `vanta/attacks.py` generates reproducible carpet bombing traffic and records the actual attacked set.

## Telemetry and detection layer

- `vanta/telemetry.py` exports host-side measurements and prefix-router counters.
- `vanta/detectors.py` computes host-level and prefix-level evidence used by the paper pipeline.
- `vanta/visibility.py` estimates attacked-destination visibility online.
- `vanta/fusion.py` adapts the relative contribution of host and prefix evidence.
- `vanta/pipeline.py` coordinates measurement windows, detection, and result export.
- `vanta/metrics.py` computes confusion counts, classification metrics, PVR error, and detection delay.

## Comparative evaluation

- `vanta/comparison.py` defines compact per-destination traffic sketches used by the baseline adaptations.
- `experiments/run_comparison.py` trains and evaluates the full-visibility upper-bound baselines.
- `experiments/run_visibility_comparison.py` retrains and evaluates matched-observability baselines using only monitored destinations.

## Campaign entry points

- `experiments/run_paper.py` plans and executes the VANTA Mininet campaign.
- `experiments/test_topology.py` validates topology invariants and provides a live topology smoke test.
- `experiments/test_traffic.py` validates traffic and attack generation.
- `experiments/test_detector.py` validates detector construction and deterministic examples.
- `experiments/test_comparison.py` validates comparative feature construction and offline model training.
