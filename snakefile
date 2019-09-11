rule all:
    # input: "reports/iqtree/iqtreefiles.txt"
    input: "finished.done"

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

rule fasttree: # build ML phylogenetic tree
    input:
        "results/trimal/{sample}.afa.trimal"
    output:
        "results/fasttree/{sample}.afa.trimal.nwk",
    shell:
        '''
        FastTree -quiet -gtr -nt {input} > {output}
        touch finished.done
        '''
# rule raxmltree:
#         input:
#             "results/trimal/{sample}.afa.trimal"
#         output:
#             "results/raxml/RAxML_bestTree.outRaxml",
#             touch("finished.done")
#         shell:
#             "raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s {input} -n outRaxml -p 12345"
#
# rule prep_iqtree: # copy the alignment file to iqtree folder
#     input:
#         "results/trimal/{sample}.afa.trimal"
#     output:
#         "results/iqtree/{sample}.afa.trimal"
#     shell:
#         "cp {input} {output}"
#
# rule iqtree: # ML phylogenetic analysis
#         input:
#             "results/iqtree/{sample}.afa.trimal"
#         output:
#             #directory("results/iqtree/{sample}/"),
#             touch("finished.done") #this creates or updates a Flag file, and makes rule all easier
#         shell:
#             "iqtree -s {input} -m GTR+I+G -quiet" # why no output file?

# not working!
# rule samples_report: # write the name of every iqtree file to a report
#     shell: # is this ls or echo?
#         "ls results/iqtree/*.afa.trimal_fixed.iqtree >> reports/iqtree/iqtreefiles.txt"
