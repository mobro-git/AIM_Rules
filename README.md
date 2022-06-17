# AIMRules

Code for EJ analysis for AIM Rules: Allocation Rule and Technology Transitions Rule.

## Getting Started:

The data pipeline is managed via targets. The overall plan is listed in _targets.R. To run the project, from the console run: ```targets::tar_make()``` from the project working directory. (e.g., via opening the EMF37.Rproj file). Final results are html and text in /outputs. 

TO run the project interactively:
1) Load packages: ```source("packages.R")```
2) Load custom functions: ```devtools::load_all(".")```
3) Load cached intermediate objects: ```targets::tar_load(everything())``` (or specify names of particular targets to load).

From their individual functions or targets can be run interactively. The targets package also provides customized debugging tools beyond the scope of this document.
