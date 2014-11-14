#!/usr/bin/perl
#################################################################################
#
# USAGE: perl BNGCompare.pl [options]
# Script outputs...
#  Created by jennifer shelton //14
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
print "#  Created by Jennifer Shelton //14                       #\n";
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
my $makeQue = `perl ${dirname}/cmap_stats.pl -c $que -o $outFile_D -t "CMAP from assembled BNG molecules"`;
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

BNGCompare.pl - Script outputs ...

=head1 USAGE
 
 perl BNGCompare.pl [options]
 
 Documentation options:
    -help    brief help message
    -man	    full documentation
 Required parameters:
    -f	    fasta to annotate with blastx
 Optional parameters:
    -m	     maximum sequences to report alignments for

 
=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the more detailed manual page with output details and examples and exits.
 
=item B<-f, --input_fasta>
 
The fullpath for the fasta file of assembled transcripts. These will be split into smaller files with no more than 100 sequences per file and blasted against the "nr" database.


=back

=head1 DESCRIPTION

B<OUTPUT DETAILS:>

Script requires writes... For more detailed tutorial see...

B<Test with sample datasets:>
 
git clone https://github.com/i5K-KINBRE-script-share/RNA-Seq-annotation-and-comparison

mkdir test_blastx
 
cd test_blastx
 
ln -s /homes/bioinfo/pipeline_datasets/Blastx/* ~/test_blastx/

perl ~/RNA-Seq-annotation-and-comparison/KSU_bioinfo_lab/Blastx/BNGCompare.pl -m 10 -f ~/test_blastx/CDH_clustermergedAssembly_cell_line_33.fa
 

=cut
