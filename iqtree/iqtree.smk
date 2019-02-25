rule all:
    input: "results/iqtree/ape.afa.trimal.iqtree"

rule mafft_align: # alignment
    input:
        "data/{sample}.fasta"
    output:
        "results/mafft/{sample}.afa"
    shell:
        "mafft --auto --quiet {input} > {output}"

rule trimal: # alignment curation https://vicfero.github.io/trimal/
    input:
        "results/mafft/{sample}.afa"
    output:
        "results/trimal/{sample}.afa.trimal"
    shell:
        "trimal -in {input} -out {output} -gappyout"

rule prep_iqtree: # copy the alignment file to iqtree folder
    input:
        "results/trimal/{sample}.afa.trimal"
    output:
        "results/iqtree/{sample}.afa.trimal"
    shell:
        "cp {input} {output}"

rule iqtree: # ML phylogenetic analysis
        input:
            "results/iqtree/{sample}.afa.trimal"
        output:
            "results/iqtree/{sample}.afa.trimal.iqtree"
        shell:
            "iqtree -s {input} -m GTR+I+G -quiet"
