# SCC-ESRC

This folder contains synthetic (simulation) data generated during the ESRC-funded project "Constant Rate Effects and Beyond: Modelling Interactions of Language-Internal and Language-External Factors in Language Change" (ES/S011382/1). These data, which form part of the first submission version of a manuscript (but not necessarily its final published version), are deposited here as per the [ESRC Research Data Policy](https://esrc.ukri.org/funding/guidance-for-grant-holders/research-data-policy/). (Principle 1 of [this document](https://www.ukri.org/files/legacy/documents/rcukcommonprinciplesondatapolicy-pdf/) of the UKRI explicitly says that simulation inputs and outputs constitute research data.)

The simulation data were generated on a scientific computing cluster running the SGE queuing system, by code written in R. Here's a brief description of each folder. In each case, the simulation outputs reside in the `results` subfolder, the other folders containing inputs and various auxiliary files. Each `results` subfolder contains a number of CSV files, each the output of one parallel process. To produce the final datasets, these CSV files were concatenated using the utilities provided by [hipster](https://github.com/hkauhanen/hipster).

Folders `classical_posthoc` and `pbcm` contain post hoc power analyses on data gathered by other people. Since I do not own the copyright to these data, they have been redacted here (they would otherwise reside in a subfolder named `data`).


## Folder `classical`

Power analysis of classical CRE detection methods (methods M4--M7 in the manuscript). Description of CSV columns (please refer to the manuscript for further details):

* `H`: horizontal resolution
* `V`: vertical resolution
* `E`: effect size
* `low_bound`: lowest frequency attested in change
* `high_bound`: highest frequency attested in change
* `method`: CRE detection method
* `reps`: number of Monte Carlo repetitions
* `alpha`: alpha level
* `runtime`: run time of process
* `runtime_scaled`: `runtime` divided by 2 times `reps`
* `P`: number of positives
* `TP`: number of true positives
* `FN`: number of false negatives
* `N`: number of negatives
* `TN`: number of true negatives
* `FP`: number of false positives

## Folder `classical_alpha`

Exploration of the effect of alpha level on the classical methods. CSV columns as in `classical`.

## Folder `classical_highbound`

Exploration of the effect of variation in the higher frequency bound on the classical methods. CSV columns as in `classical`.

## Folder `classical_posthoc`

Post-hoc power analysis of the 46 external datasets explored in the manuscript. Description of CSV columns for `confusion.*.csv` files:

* `ID`: dataset ID
* `H`: horizontal resolution
* `V`: vertical resolution
* `E`: effect size
* `low_bound`: lowest frequency attested in change
* `high_bound`: highest frequency attested in change
* `method`: CRE detection method
* `reps`: number of Monte Carlo repetitions
* `alpha`: alpha level
* `runtime`: run time of process
* `runtime_scaled`: `runtime` divided by 2 times `reps`
* `P`: number of positives
* `TP`: number of true positives
* `FN`: number of false negatives
* `N`: number of negatives
* `TN`: number of true negatives
* `FP`: number of false positives
* `J`: Youden's _J_
* `own_boundaries`: whether `low_bound` and `high_bound` came from the dataset itself

Description of CSV columns for `runtime.*.csv` files:

* `ID`: dataset ID
* `reps`: number of Monte Carlo repetitions
* `alpha`: alpha level
* `runtime`: total process run time

## Folder `pbcm`

PBCM power analyses. Description of CSV columns for `confusion.*.csv` files:

* `k`: number of neighbours considered in _k_ nearest neighbours classification
* `P`: number of positives
* `N`: number of negatives
* `TP`: number of true positives
* `FP`: number of false positives
* `TN`: number of true negatives
* `FN`: number of false negatives
* `alpha`: type I error
* `beta`: type II error
* `model1`: first model subjected to the PBCM comparison
* `model2`: second model subjected to the PBCM comparison
* `case`: an identifier put together from `model1` and `model2`
* `ID`: dataset ID

Description of CSV columns for `empirical.*.csv` files:

* `k`: number of neighbours considered in _k_ nearest neighbours classification
* `dist_model1`: _k_-NN distance for model 1
* `dist_model2`: _k_-NN distance for model 2
* `PBCM`: _k_-NN decision
* `model1`: first model subjected to the PBCM comparison
* `model2`: second model subjected to the PBCM comparison
* `case`: an identifier put together from `model1` and `model2`
* `ID`: dataset ID

Description of CSV columns for `runtime.*.csv` files:

* `ID`: dataset ID
* `H`: horizontal resolution
* `V`: vertical resolution
* `L`: lateral resolution
* `case`: an identifier put together from `model1` and `model2`
* `budget`: computational budget supplied to the nonlinear least squares algorithm fitting the alternative models of the CRE
* `reps`: number of Monte Carlo repetitions
* `no_of_ks`: number of different values of _k_ considered
* `runtime`: total process run time
