rule all:
    input:
        "results/raxml/out.nwk"
#results/fasttree/ape_alignment.afa.trimal.nwk
rule mafft_align:
    input:
        "data/{sample}.fasta"
    output:
        "results/mafft/{sample}.afa"
    shell:
        "mafft --auto --quiet {input} > {output}"

# trimAl is a tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment
# https://vicfero.github.io/trimal/
rule trimal:
    input:
        "results/mafft/{sample}.afa"
    output:
        "results/trimal/{sample}.afa.trimal"
    shell:
        "trimal -in {input} -out {output} -gappyout"

# rule fasttree:
#     input:
#         "results/trimal/{sample}.afa.trimal"
#     output:
#         "results/fasttree/{sample}.afa.trimal.nwk",
#     shell:
#         "FastTree -quiet -gtr -nt {input} > {output}"

rule raxmltree:
        input:
            "results/trimal/{sample}.afa.trimal"
        output:
            "results/raxml/{input}.nwk"
        shell:
            "raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s {input} -n"
            #raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 --no­bfgs -s {input} -n {output}
#raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s ape_alignment.afa.trimal.fas -n T20
