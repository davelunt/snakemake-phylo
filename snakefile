rule all:
    input: "reports/iqtree/iqtreefiles.txt"

rule mafft_align: # alignment
    input:
        "data/{sample}.fasta"
    output:
        "results/mafft/{sample}.afa"
    shell:
        "mafft --auto --quiet {input} > {output}"

rule replace_spaces: # replace spaces with underscores in fasta
    input:
        "results/mafft/{sample}.afa"
    output:
        "results/trimal/{sample}.afa"
    shell:
        "sed -E 's/ /_/g' {input} {output}"

rule trimal: # alignment curation https://vicfero.github.io/trimal/
    input:
        "results/mafft/{sample}.afa"
    output:
        "results/trimal/{sample}.afa.trimal"
    shell:
        "trimal -in {input} -out {output} -gappyout"

rule replace_underscores: # replace underscores with spaces in fasta
    input:
        "results/trimal/{sample}.afa.trimal"
    output:
        "results/trimal/{sample}.afa.trimal_fixed"
    shell:
        "sed -E 's/_/ /g' {input} {output}"

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

# not working!
rule samples_report: # write the name of every iqtree file to a report
    shell:
        "ls results/iqtree/*.afa.trimal_fixed.iqtree >> reports/iqtree/iqtreefiles.txt"
