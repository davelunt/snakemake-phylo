rule all:
    input: "results/raxml/RAxML_bestTree.outRaxml"

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


# rule fasttree:
#     input:
#         "results/trimal/{sample}.afa.trimal"
#     output:
#         "results/fasttree/{sample}.afa.trimal.nwk",
#     shell:
#         "FastTree -quiet -gtr -nt {input} > {output}"

rule raxmltree:
        input:
            "results/trimal/ape.afa.trimal"
        output:
            "results/raxml/RAxML_bestTree.outRaxml"
        shell:
            "raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s {input} -n outRaxml -p 12345"
