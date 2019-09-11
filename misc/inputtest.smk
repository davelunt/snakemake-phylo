# https://bioinformatics.stackexchange.com/questions/2572/snakemake-rule-all

from os.path import join

SAMPLES, = glob_wildcards("data/{sample}.fasta")

print("---Sample Names---")

for i in SAMPLES:
    print(i)

rule all:
    input:
        expand("results/fasttree/{sample}_alignment.afa.trimal.nwk", sample=SAMPLES)

rule mafft_align: # alignment
    input:
        "data/{sample}.fasta"
    output:
        "results/mafft/{sample}.afa"
    shell:
        "mafft --auto --quiet {input} > {output}"

rule trimal: # alignment curation
    input:
        "results/mafft/{sample}.afa"
    output:
        "results/trimal/{sample}.afa.trimal"
    shell:
        "trimal -in {input} -out {output} -gappyout -keepheader"

rule fasttree: # phylogeny
    input:
        "results/trimal/{sample}.afa.trimal"
    output:
        "results/fasttree/{sample}.afa.trimal.nwk",
    shell:
        "FastTree -quiet -gtr -nt {input} > {output}"
