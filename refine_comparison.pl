#!/usr/bin/perl
###############################################################################
#
#	USAGE: perl refine_comparison.pl <comparison_metrics_temp_file> <comparison_metrics_final>
#
#  Created by Jennifer Shelton 5/05/15
#
# DESCRIPTION: Cleans output of sewing_machine.pl
###########################################################
#                 Refine BNGCompare file
###########################################################
my $comparison_metrics_temp_file = "$ARGV[0]";
open (my $comparison_metrics, "<", $comparison_metrics_temp_file) or die "Can't open $comparison_metrics_temp_file: $!";
my $comparison_metrics_file = "$ARGV[1]";
open (my $comparison_metrics_final, ">", $comparison_metrics_file) or die "Can't open $comparison_metrics_file: $!";
my $seen_line = 0;
my $xmap_line;
my($genome_map_alignment_length,$genome_map_length,$in_silico_alignment_length,$in_silico_map_length);
while (<$comparison_metrics>)
{
    if ((/,XMAP name,Breadth of alignment coverage for CMAP \(Mb\),Length of total alignment for CMAP \(Mb\)/) || (/,File Name,N50/) ||(/^$/))
    {
        next;
    }
    if (/XMAP alignment/)
    {
        ++$seen_line;
        if (($seen_line == 1) || ($seen_line == 3))
        {
            
            s/XMAP alignment/XMAP alignment lengths relative to the in silico maps/;
            chomp;
            $xmap_line = $_;
            ($in_silico_alignment_length) = (split(/,/),$_)[2];
            next;
            
        }
        if (($seen_line == 2) || ($seen_line == 4))
        {
            
            s/XMAP alignment/XMAP alignment lengths relative to the genome maps/;
            ($genome_map_alignment_length) = (split(/,/),$_)[2];
            my $genome_map_percent_align = ($genome_map_alignment_length/$genome_map_length) * 100;
            my $in_silico_percent_align = ($in_silico_alignment_length/$in_silico_map_length) * 100;
            chomp;
            $xmap_line = "$xmap_line".",$in_silico_percent_align\n"."$_".",$genome_map_percent_align\n";
            next;
        }
        
    }
    elsif (/Genome fasta/)
    {
        if (($seen_line == 2) || ($seen_line == 4))
        {
            s/Genome fasta/Super scaffold genome FASTA/;
            print $comparison_metrics_final "$_";
            print $comparison_metrics_final ",XMAP name,Breadth of alignment coverage for CMAP (Mb),Length of total alignment for CMAP (Mb),Percent of CMAP covered by alignment\n";
            #            printf '<%.1f>', "$xmap_line";
            print $comparison_metrics_final "$xmap_line";
            next;
        }
        else
        {
            s/Genome fasta/Genome FASTA/;
            print $comparison_metrics_final " ,File Name,N50 (Mb),Number of Contigs,Cumulative Length (Mb)\n";
            
            print $comparison_metrics_final "$_";
            next;
        }
    }
    elsif (/CMAP from assembled BioNano molecule maps/)
    {
        ($genome_map_length) = (split(/,/),$_)[4];
    }
    elsif (/in silico CMAP from FASTA/)
    {
        ($in_silico_map_length) = (split(/,/),$_)[4];
    }
    
    print $comparison_metrics_final "$_";
}
close ($comparison_metrics_final);
close ($comparison_metrics);
unlink($comparison_metrics_temp_file);