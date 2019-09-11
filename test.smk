rule all:
    input: "reports/iqtree/iqtreefiles.txt"

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
        "trimal -in {input} -out {output} -gappyout -keepheader"

# rule fasttree:
#     input:
#         "results/trimal/{sample}.afa.trimal"
#     output:
#         "results/fasttree/{sample}.afa.trimal.nwk",
#     shell:
#         "FastTree -quiet -gtr -nt {input} > {output}"

# rule raxmltree:
#         input:
#             "results/trimal/ape.afa.trimal"
#         output:
#             "results/raxml/RAxML_bestTree.outRaxml"
#         shell:
#             "raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s {input} -n outRaxml -p 12345"

rule prep_iqtree: # copy the alignment file to iqtree folder
    input:
        "results/trimal/{sample}.afa.trimal_fixed"
    output:
        "results/iqtree/{sample}.afa.trimal_fixed"
    shell:
        "cp {input} {output}"

rule iqtree: # ML phylogenetic analysis
        input:
            "results/iqtree/{sample}.afa.trimal_fixed"
        output:
            "results/iqtree/{sample}.afa.trimal_fixed.iqtree"
        shell:
            "iqtree -s {input} -m GTR+I+G -quiet"
# rule iqtree: # ML phylogenetic analysis
#         input:
#             "results/iqtree/{sample}.afa.trimal_fixed"
#         output:
#             "results/iqtree/{sample}.afa.trimal_fixed.iqtree"
#         shell:
#             python "myspp.py" -i 'input.fas' -o 'output.afa'
