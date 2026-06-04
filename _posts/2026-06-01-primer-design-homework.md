#### 1/06/2026
  
## Primer Designing and Phyologenetic tree Homework


# Primer Design and Phylogenetic Analysis of *Durinskia occulata* Using the rbcL Gene

## Objective

The objective of this project was to design PCR primers for species identification of *Durinskia occulata* using the chloroplast **rbcL** gene, and to examine its evolutionary relationship with related taxa using phylogenetic analysis.

---

## Target Organism and Barcode Gene

**Target species:** *Durinskia occulata*  

**Gene used:** rbcL — ribulose-1,5-bisphosphate carboxylase/oxygenase large subunit

The **rbcL** gene is commonly used as a DNA barcode for algae and plants because it contains conserved regions suitable for primer design, as well as variable regions that can help distinguish between species.

---

## Sequence Collection

The DNA sequences were obtained from NCBI GenBank.

### Accession numbers

| Accession number |
|---|
| KY693719.1 |
| LC385878.1 |
| MK792452.1 |
| AF155877.1 |

The FASTA sequences were downloaded from GenBank and used for alignment, primer design, Primer-BLAST verification, and phylogenetic analysis.

---

## Multiple Sequence Alignment

The sequences were aligned using **ClustalW** in **MEGA**.

**Sequence type:** DNA

The alignment was used to identify conserved regions and variable regions.

Conserved regions were selected as possible primer-binding sites. Variable regions containing SNPs and/or indels were used as informative regions for species identification.

![Diatom sequence alignment](images/fasta1.png)
![Multiple sequence alignment](images/fasta2.png)
![Multiple sequence alignment](images/fasta3.png)
![Multiple sequence alignment](images/fasta4.png)
---

## Primer Design

Primers were designed using **Primer3**.

### Selected primer pair

| Primer | Sequence 5'→3' |
|---|---|
| Forward primer | TGGATGCGTATGTCTGGTGT |
| Reverse primer | CAACTGGCATACAACGACGT |

### Primer characteristics

| Parameter | Forward primer | Reverse primer |
|---|---:|---:|
| Length | 20 bp | 20 bp |
| Tm | 59.10°C | 58.86°C |
| GC content | 50% | 50% |
| Position | 977–996 | 1141–1160 |

**Expected amplicon size:** 184 bp

![Primer3 results](images/primer3_results.png)

---

## Primer Verification Using Primer-BLAST

The primer pair was verified using **NCBI Primer-BLAST**.

**Database used:** nucleotide collection (nt)

Primer-BLAST confirmed amplification of the target sequence:

- KY693719.1 — *Durinskia occulata* rbcL gene

The expected PCR product size was **184 bp**.

The primers also amplified related diatom species, including:

- *Nitzschia sp.*
- *Psammodictyon sp.*
- *Nitzschia inconspicua*

Therefore, the primers are not completely species-specific. However, they amplify a barcode region that can be sequenced and compared among species. Species identification would rely on sequence variation within the amplified region rather than PCR amplification alone.

![Primer-BLAST results](images/primer_blast_results.png)

---

## Phylogenetic Analysis

A phylogenetic tree was constructed using **MEGA**.

### Tree-building parameters

| Parameter | Setting |
|---|---|
| Alignment method | ClustalW |
| Tree-building method | Neighbor-Joining |
| Substitution model | Kimura 2-parameter |
| Bootstrap replicates | 1000 |
| Rates among sites | Uniform rates |
| Gaps/missing data treatment | Pairwise deletion |

![Phylogenetic tree](images/phylogenetic_tree.png)

---

## Tree Interpretation

The phylogenetic tree showed that **LC385878.1** and **KY693719.1** clustered together with strong bootstrap support (**100%**), indicating a very close evolutionary relationship.

**MK792452.1** formed a separate branch that was more closely related to the LC385878.1–KY693719.1 cluster than to **AF155877.1**.

**AF155877.1** was the most divergent sequence and formed the most distant branch in the tree.

These results are consistent with the multiple sequence alignment, which showed high similarity between LC385878.1 and KY693719.1 and greater sequence divergence in MK792452.1 and AF155877.1.

---

## Conclusion

Primers were successfully designed for amplification of the **rbcL** barcode region of *Durinskia occulata*. Primer-BLAST confirmed that the primers amplify the expected target region with a predicted amplicon size of **184 bp**. Although the primers also amplified related diatom species, the amplified barcode region can be sequenced and used for species identification based on SNPs and/or indels.

The phylogenetic analysis showed that KY693719.1 and LC385878.1 are closely related, while AF155877.1 is the most divergent sequence among the analyzed taxa.
