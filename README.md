# ML-project
Uncovering High-Response Subgroups to Neurofeedback in ADHD Using Machine Learning

Description
This repository contains the code, data processing scripts, and analysis pipeline for our Late Breaking Results IEEE paper on identifying high-response subgroups to Neurofeedback (NF) therapy in children with ADHD. Using unsupervised clustering (K-means) on EEG and demographic features from the largest double-blind randomized NF trial to date (openICPSR Dataset), we uncovered a subgroup — primarily young females with moderate theta/beta ratios — showing a 45–50% improvement on the Clinical Global Impression–Improvement (CGI-I) scale.

Our analysis demonstrates the potential of machine learning for precision medicine in ADHD treatment and provides reproducible code for data preprocessing, clustering, visualization, and preliminary evaluation.

Key Features
Data Preprocessing: Cleans and normalizes EEG and demographic data, handles missing values.
Feature Engineering: Extracts theta, beta, hi-beta, TBR, age, sex, and school grade variables.
Clustering: Applies K-means (k=3) with SSE minimization and post-hoc responder evaluation.
Visualization: Generates cluster scatterplots (Age vs TBR) and response rate charts.
Reproducibility: Fully documented scripts to replicate results with open-access data.

Technologies
MATLAB (for EEG feature visualization)
Jupyter Notebooks

Citation
If you use this code or methodology, please cite:
Argil, S., Cohen, R., Cohen, T. (2025). Uncovering a High-Response Subgroup to Neurofeedback in ADHD: A Clustering Approach. Department of Biomedical Engineering, Ben-Gurion University of the Negev.
Original dataset:
Arnold, L. Gene, and DeBeus, Roger. Double-Blind 2-Site Randomized Clinical Trial of Neurofeedback for ADHD. Ann Arbor, MI: ICPSR, 2024. https://doi.org/10.3886/E198003V1
