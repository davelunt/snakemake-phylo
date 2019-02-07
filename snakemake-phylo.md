# snakemake-phylo

created a conda environment called snakemake-phylo2
made an environment.yaml file containing blast, raxml, and mafft
It found them nicely and installed
Adding things requires an update to environment
```
conda env update -f environment.yaml
```
would alignment be better with transAlign?

## setup data
### MAFFT
fasta file unaligned
### RaxML
fasta file aligned

## data
made an ape.fasta file with 8 great ape COI sequences (about 650 bp) plus Hylobates lar gibbon outgroup as first record.

Work iMac tested mafft with `mafft -help` which worked

`mafft infile > outfile worked too.`

had to create environment on this computer, same as laptop because using environment file

`conda env create --name snakemake-phylo2 --file environment.yaml`

do a dry run

`snakemake -np results/ape_alignment.afa`

`SyntaxError in line 7 of /Users/davelunt/Dropbox/work/research/code/snakemake-phylo/Snakefile:
invalid syntax`

Yet this works fine copying and pasting input and output! and this too at cmd line

`mafft --auto ./data/ape.fasta > ./results/ape_alignment.afa`

must be a snakefile error

Tried without nesting the files. Worked. Tried with results in results folder, worked fine! It must be the input file!!
No, reinstating input file works. Must have been a typo??

Works fine without all rule at the top. Who knows what was the error!

Had to install raxml, why not installed with environment?? Its called raxmlHPC

raxmlHPC-PTHREADS-SSE3 -f e -m GTRGAMMA -s results/ape_alignment.afa -n output --no-bfgs

raxmlHPC -f e -m GTRGAMMA -s results/ape_alignment.afa -n output --no-bfgs

raxmlHPC -m GTRGAMMA -p 12345 -s results/ape_alignment.afa -# 20 -n T6

This works (3.5 secs) but creates a lot of output files. Needs to be in a folder, and we need a simple tree.
This has rapid bootstrapping

raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s results/ape_alignment.afa -n T20
worked in 6.4 secs, and much fewer files

## IQTREE

conda install -c bioconda iqtree

```
iqtree -s example.phy
```

example.phy.treefile is the treefile obviously as newick

```
snakemake -np results/ape_alignment.afa.treefile
```

throws error as its writing to wrong folder. I need to learn how to direct output

Iqtree spends a lot of time doing stuff that isn't clear. Go back to RAXML with SH support

No fasttree is VERY fast 0.12 secs to run mafft and fasttree


Found this metabarcoding snakemake

https://github.com/nioo-knaw/hydra/blob/master/Snakefile

https://gitlab.pasteur.fr/phylo/cytopast/blob/61cdca7c47ecb94957da1f35c6f647434962adaf/examples/C/snakemake/Snakefile

ETE to draw a treefile
need to midpoint root it first? http://etetoolkit.org/docs/latest/tutorial/tutorial_trees.html#tree-rooting
