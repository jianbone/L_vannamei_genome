#! /usr/bin/perl
if(@ARGV<2){
    print "orthomcl2extract.pl groups.txt speciesList\n";
    exit;  
}

my $group = shift;
my $species = shift;
my %mark;
open(SPE,"<$species") or die;
while(<SPE>){
   chomp $_;
   $mark{$_} =1;
   #print "$_\n";
}

open(GROUP,"<$group") or die;
while(<GROUP>){
    chomp $_;
    my @line = split /: /,$_;
    my @line2 = split / /,$line[1];
    #print "$line[0]\n";
    my $num=0;
    my @line3;
    for($i=0;$i<@line2;$i++){
       $line2[$i] =~ /(\S+)\|(\S+)/;
       if($mark{$1} ==1){
          $num++;
          $line3[@line3] = $line2[$i];
       }
   }
   if($num >0){
      $tmp = join " ", @line3;
      print "$line[0]\t$tmp\n";
   }
}
close(GROUP);

