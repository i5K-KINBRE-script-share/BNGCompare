SCRIPT

**BNGCompare.pl -** Script outputs summary stats from a FASTA and an in silico CMAP
(reference) of the same FASTA and a of a CMAP inferred from assembly of BioNano
molecule maps (query) as well as a summary of an XMAP generated aligning the
CMAPs.

USAGE

perl BNGCompare.pl [options]

Documentation options:

    -help    brief help message
    -man            full documentation

Required parameters:

    -f      genome FASTA
    -f      genome FASTA
    -q      CMAP inferred from assembly of BioNano molecule maps (query)
    -r      in silico CMAP (reference)
    -x      XMAP generated aligning the CMAP

Optional parameters:

    -o      output filename

Options:

    -help   Print a brief help message and exits.

    -man    Prints the more detailed manual page with output details and
    examples and exits.

    -f, --input_fasta
    The fullpath for the genome FASTA file.

    -r, --ref
    The fullpath for the in silico CMAP (reference) of the genome
    FASTA.

    -q, --que
    The fullpath for the CMAP inferred from assembly of BioNano
    molecule maps (query).

    -x, --xmap
    The fullpath for the XMAP generated by aligning the reference
    and query CMAPs.

    -o, --out
    The fullpath for the in output comma separated values file.

DESCRIPTION

    OUTPUT DETAILS:

    Script outputs a CSV file with the file prefix "BNGCompare.csv" that includes
    summary metrics for XMAP alignment's query map (e.g. where "total aligned
    length" is the length of the aligned region for the query in silico genome
    maps), the genome FASTA, in silico CMAP, and the in silico CMAP from FASTA file.

UPDATES

####BNGCompare.pl Version 1.1 

Added optional `-o` output filename parameter
