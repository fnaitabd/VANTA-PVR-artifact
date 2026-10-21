PYTHON ?= .venv/bin/python

.PHONY: validate verify-results figures clean

validate:
	$(PYTHON) -m compileall -q vanta experiments scripts plots
	$(PYTHON) -m experiments.test_topology validate --config config/default.yaml
	$(PYTHON) -m experiments.test_traffic validate --config config/default.yaml
	$(PYTHON) -m experiments.test_detector demo --config config/default.yaml
	$(PYTHON) -m experiments.run_paper validate --config config/default.yaml
	$(PYTHON) -m experiments.test_comparison validate --config config/default.yaml

verify-results:
	$(PYTHON) scripts/verify_paper_results.py

figures:
	$(PYTHON) plots/plot_f1_vs_pvr.py
	$(PYTHON) plots/plot_low_visibility.py
	$(PYTHON) plots/plot_intrinsic_results.py

clean:
	rm -rf plots/generated __pycache__ vanta/__pycache__ experiments/__pycache__ scripts/__pycache__ plots/__pycache__
