#!/usr/bin/perl
#################################################################################
#
# USAGE: perl BNGCompare.pl [options]
# Script outputs summary stats from a FASTA and an in silico CMAP (reference) of the same FASTA and a of a CMAP inferred from assembly of BioNano molecule maps (query) as well as a summary of an XMAP generated aligning the CMAPs.
#  Created by Jennifer Shelton and Zachary Sliefert 2014
#
#################################################################################
use strict;
use warnings;
# use IO::File;
use File::Basename; # enable maipulating of the full path
# use File::Slurp;
# use List::Util qw(max);
# use List::Util qw(sum);
use Getopt::Long;
use Pod::Usage;
###############################################################################
##############         Print informative message             ##################
###############################################################################
print "###########################################################\n";
print "#  BNGCompare.pl Version 1.0                              #\n";
print "#                                                         #\n";
print "#  Created by Jennifer Shelton and Zachary Sliefert 2014  #\n";
print "#  github.com/i5K-KINBRE-script-share                     #\n";
print "#  perl BNGCompare.pl -help # for usage/options           #\n";
print "#  perl BNGCompare.pl -man # for more details             #\n";
print "###########################################################\n";
###############################################################################
##############                get arguments                  ##################
###############################################################################
my $man = 0;
my $help = 0;
my ($ref, $que);
my $fasta;
my $xmap;
GetOptions (
        'help|?' => \$help,
        'man' => \$man,
        'x|xmap:s' => \$xmap,
        'f|fasta:s' => \$fasta,	
        'r|ref:s' => \$ref,	
        'q|que:s' => \$que
)
or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitstatus => 0, -verbose => 2) if $man;
my $dirname = dirname(__FILE__); # program directory (all github directories must be in the same directory). requires File::Basename and DOES NOT add trailing slash to $dirname
my (${filename}, ${directories}, ${suffix}) = fileparse($fasta,'\.[^.]+$'); # requires File::Basename and adds trailing slash to $directories
my $outFile_D = "${directories}${filename}_BNGCompare.csv";

###############################################################################
##############              run                              ##################
###############################################################################
print "Generating xmap stats...\n";
my $makeX = `perl ${dirname}/xmap_stats.pl -x $xmap -o $outFile_D`;
print "$makeX";
print "xmap_stats completed\n";
###############################################################################
##############              run                              ##################
###############################################################################
print "Generating fasta stats...\n";
my $makeF = `perl ${dirname}/N50.pl $fasta $outFile_D`;
print "$makeF";
print "xmap_stats completed\n";
###############################################################################
##############              run                              ##################
###############################################################################
print "Generating Reference CMAP stats...\n";
my $makeRef = `perl ${dirname}/cmap_stats.pl -c $ref -o $outFile_D -t "in silico CMAP from FASTA"`;
print "$makeRef";
print "Reference_cmap_stats completed\n";
###############################################################################
##############              run                              ##################
###############################################################################
print "Generating Query CMAP stats...\n";
my $makeQue = `perl ${dirname}/cmap_stats.pl -c $que -o $outFile_D -t "CMAP from assembled BioNano molecule maps"`;
print "$makeQue";
print "Query_cmap_stats completed\n";
###############################################################################
############## Name output file based on input filename      ##################
###############################################################################


print "Done\n";
###############################################################################
##############                  Documentation                ##################
###############################################################################
## style adapted from http://www.perlmonks.org/?node_id=489861
__END__

=head1 NAME

BNGCompare.pl - Script outputs summary stats from a FASTA and an in silico CMAP (reference) of the same FASTA and a of a CMAP inferred from assembly of BioNano molecule maps (query) as well as a summary of an XMAP generated aligning the CMAPs.

=head1 USAGE
 
perl BNGCompare.pl [options]

Documentation options:
 
    -help    brief help message
    -man	    full documentation
 
Required parameters:
 
    -f	    genome FASTA
    -q	    CMAP inferred from assembly of BioNano molecule maps (query)
    -r	    in silico CMAP (reference)
    -x	    XMAP generated aligning the CMAP
 

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the more detailed manual page with output details and examples and exits.

=item B<-f, --input_fasta>

The fullpath for the genome FASTA file.

=item B<-r, --ref>

The fullpath for the in silico CMAP (reference) of the genome FASTA.

=item B<-q, --que>

The fullpath for the CMAP inferred from assembly of BioNano molecule maps (query).

=item B<-x, --xmap>

The fullpath for the XMAP generated by aligning the reference and query CMAPs.


=back

=head1 DESCRIPTION

B<OUTPUT DETAILS:>

Script outputs a CSV file with the file prefix "BNGCompare.csv" that includes summary metrics for XMAP alignment's query map (e.g. where "total aligned length" is the length of the aligned region for the query in silico genome maps), the genome FASTA, in silico CMAP, and the in silico CMAP from FASTA file.
 

=cut
