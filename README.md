# Piezo1-Aerospace-Bibliometry

PIEZO1 Aerospace Bibliometry Analysis
This repository contains the data and MATLAB implementation for a bibliometric study of PIEZO1 mechanosensitive ion channels in the context of aerospace medicine and microgravity research (2010–2026).

Methodology
The analysis utilizes two datasets exported from PubMed:

Master Dataset: All publications matching PIEZO1[Title/Abstract].

Aerospace Subset: Publications matching PIEZO1 AND a specific 35-term aerospace keyword library (e.g., microgravity, hindlimb unloading, ISS, SANS, iRED).

Algorithmic Era Detection (Phase Shifts)
Research "Eras" were identified using Change-Point Analysis (via the MATLAB findchangepts function). This algorithm detects structural breaks in the mean velocity of global publications to identify when the field fundamentally shifted in scale and intensity.

Keyword Library
The aerospace subset was identified by searching for the following terms within titles and abstracts:

Microgravity, Weightlessness, Unloading, Hindlimb unloading, Simulated microgravity, Spaceflight, Space physiology, Zero gravity, Myofiber shift, Fluid shift, Cephalad shift, Orthostatic intolerance, Cardiovascular deconditioning, Space motion sickness, Space adaptation syndrome, Vestibular dysfunction, Free fall, Parabolic flight, Bed rest model, Head-down tilt, Dry immersion, ARED, G-transitions, Landing effects, ISS, Astronaut, Cosmonaut, Taikonaut, Mir, Lunares, Mars500, CONCORDIA, SANS, Spaceflight-Associated Neuro-Ocular Syndrome, iRed.

Repository Contents
asma2026piezoeras2_public.m: The cleaned MATLAB script used to generate the dual-axis timeline and perform change-point detection.

PUBMED_Piezo1_titleabstract.csv: Raw master dataset from PubMed.

PUBMED_Space.csv: Targeted aerospace-filtered dataset.

ASMA_Final_Timeline.png: output of the analysis.

Citation
If using this code or dataset for your own research, please cite:
TAKANAMI DE OLIVEIRA, A. (2026). PIEZO1 AGONISM AS AN ADDITIONAL COUNTERMEASURE FOR SPACE BONE LOSS AND POTENTIAL MULTISYSTEM PROTECTION. Aerospace Medical Association (AsMA) 96th Annual Scientific Meeting, [Denver, Colorado/United States of America].
