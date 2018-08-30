#!/usr/bin/perl -w
use Bio::SeqIO;

my $Usage="\t
    Usage:  According to SNP file, correct the SNP and indel for the fasta sequence.\n 
        perl $0 seq.fasta snp.xls [> output]

        snp.xls format(separated by tabs):
        fasta_id    position    ref_base    variant_base

        for example:
        ref_id  100 A   T
        ref_id  120 *   -AT
        ref_id  130 *   +G

        # ref_base not include 'N';
        # if variant_base is indel, please use '+/-[ACGT]', and the position is the sequence indices prior to a gap.

    Author: Zhihao Xie   \@2014.1.1 \\(#^0^)/  \n";

if (scalar (@ARGV) < 2) {
    print STDERR "$Usage\n";
    exit;
}
my $fasta=shift;
my $snpfile=shift;

open SNPFILE,"< $snpfile";
while (<SNPFILE>) 
{
    chomp;
    my @s = split /\t/,$_;
    if ($s[3] ne "N" && $s[3] =~ /[\+\-ACGTacgt]+/) {
        $hash{$s[1]}->{$s[0]}=$s[3];
    }
}
close SNPFILE;

my $seq_obj=Bio::SeqIO->new(-file=>"$fasta",-format=>"fasta");
while (my $seq=$seq_obj->next_seq()) 
{
    my $innum = 0;
    my $id = $seq->display_id();
    my $string=$seq->seq();
    foreach my $key (sort {$b<=>$a} keys %hash) {
        my $length=length ($string);
        if (defined $hash{$key}->{$id}) {
        if ($hash{$key}->{$id} =~ /-/) {
            my @n = split /\//,$hash{$key}->{$id};
            my @m = split //,$n[0];
            my $number =(scalar @m)-1;
            my $str1=substr ($string,0,$key);
            my $str2=substr ($string,$key+$number,$length-($key+$number)+1);
            $string=join "", $str1,$str2;
            $innum=$innum-$number;
        }
        elsif ($hash{$key}->{$id} =~ /\+/) {
            (my $tem=$hash{$key}->{$id})=~s/\+//g;
            my @n = split /\//,$tem;
            my @m = split //,$n[0];
#           print "@m\n";
            my $str1=substr ($string,0,$key);
            my $str2=substr ($string,$key,$length-$key+1);
            $string=join "", $str1,@m,$str2;
            $innum=$innum+(scalar @m);
        }
        unless ($hash{$key}->{$id} =~ /\+|-/){
            if ($hash{$key}->{$id} eq "*") {
                my $str1=substr ($string, 0, $key);
                my $str2=substr ($string, $key+1, $length-$key+1);
                $string=join "", $str1,$str2;
                $innum=$innum-1;
            } else {
                my $str1=substr ($string,0,$key-1);
                my $str2=substr ($string,$key,$length-$key+1);
                $string=join "", $str1,$hash{$key}->{$id},$str2;
            }
        }
    }
    }
    print ">",$id,"\n";
    print "$string\n";
    if ($innum > 0) {
        print STDERR "$id\t\+$innum\n";
    } else {
        print STDERR "$id\t$innum\n";
    }
}
