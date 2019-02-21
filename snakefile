rule all:
    input:
        "results/fasttree/ape_alignment.afa.trimal.nwk"

rule mafft_align:
    input:
        "data/ape.fasta"
    output:
        "results/mafft/ape_alignment.afa"
    shell:
        "mafft --auto --quiet {input} > {output}"

# trimAl is a tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment
# https://vicfero.github.io/trimal/
rule trimal:
    input:
        "results/mafft/ape_alignment.afa"
    output:
        "results/trimal/ape_alignment.afa.trimal"
    shell:
        "trimal -in {input} -out {output} -gappyout"

rule fasttree:
    input:
        "results/trimal/ape_alignment.afa.trimal"
    output:
        "results/fasttree/ape_alignment.afa.trimal.nwk",
    shell:
        "FastTree -quiet -gtr -nt {input} > {output}"

# rule raxmltree:
#         input:
#             "results/trimal/ape_alignment.afa.trimal"
#         output:
#             "results/raxml/{input}"
#         shell:
#             "raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 --no­bfgs -s {input} -n {output}"
