rule all:
    input: "results/iqtree/ape.afa.trimal.iqtree"

rule mafft_align:
    input:
        "data/{sample}.fasta"
    output:
        "results/mafft/{sample}.afa"
    shell:
        "mafft --auto --quiet {input} > {output}"

'''
trimAl is a tool for the automated removal of spurious sequences or poorly
aligned regions from a multiple sequence alignment
https://vicfero.github.io/trimal/
'''
rule trimal:
    input:
        "results/mafft/{sample}.afa"
    output:
        "results/trimal/{sample}.afa.trimal"
    shell:
        "trimal -in {input} -out {output} -gappyout"

rule prep_iqtree: #copy the alignment file to iqtree folder
    input:
        "results/trimal/{sample}.afa.trimal"
    output:
        "results/iqtree/{sample}.afa.trimal"
    shell:
        "cp {input} {output}"

rule iqtree:
        input:
            "results/iqtree/{sample}.afa.trimal"
        output:
            "results/iqtree/{sample}.afa.trimal.iqtree"
        shell:
            "iqtree -s {input} -m GTR+I+G -quiet"
