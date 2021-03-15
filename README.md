# bios629
Repository for BIOSTAT 629 001 WN 2021

## Literature review

We used [Google scholar](https://scholar.google.com/) to search for literature relevant to ths project. Our findings are tabulated [here](https://github.com/soumikp/bios629/blob/main/review.xlsx).

## Reproducing findings

The [code](https://github.com/soumikp/bios629/tree/main/code) has all the code we used to clean and analyse the data relevant to this project. They are arranged in chronological order and we present a brief summary of what each file does below. 

1. [03_10_2021.R](https://github.com/soumikp/bios629/blob/main/code/03_10_2021.R) extracts self-reported PROMIS scores at time of enrollment. 
2. [03_11_2021.R](https://github.com/soumikp/bios629/blob/main/code/03_11_2021.R) extracts self-reported PROMIS scores in follow-up surveys. 
3. [03_13_2021_forSlurm.R](https://github.com/soumikp/bios629/blob/main/code/03_11_2021_forSlurm.R) helps extract Apple Exercise Time values for study participants which correspond to self-reported PROMIS scores. For more information please see the [report](https://github.com/soumikp/bios629/blob/main/report/report.pdf). The bash file [batchSubmit.sh](https://github.com/soumikp/bios629/blob/main/code/batchSubmit.sh) was used to submit jobs to Slurm on Armis2.
4. [03_13_2021.R](https://github.com/soumikp/bios629/blob/main/code/03_13_2021.R) was used to accumulate information from the cluster runs, create one data from for exploratory data analysis, figure and table generation and final analysis. 

All figures may be found in the [images](https://github.com/soumikp/bios629/tree/main/images) folder, with [03_13_2021_images.R](https://github.com/soumikp/bios629/blob/main/images/03_13_2021_images.R) encapsulating code used to generate the figures. 

## Report
The [report](https://github.com/soumikp/bios629/tree/main/report) contains both word and pdf versions of the report. 

## Queries
Please send me an [email](mailto:soumikp@umich.edu) if you have any questions. 

