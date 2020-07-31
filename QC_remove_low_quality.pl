#!usr/bin/perl -w

$forwardf=$ARGV[0];
$reversef=$ARGV[1];
$outfile1=$ARGV[2];
$outfile2=$ARGV[3];

open(O1,">$outfile1")||die"$!";
open(O2,">$outfile2")||die"$!";
open(I1,"$forwardf")||die"$!";
open(I2,"$reversef")||die"$!";

my $inputnum;
my $outputnum;
my $name;
my $name2;
my $seq;
my $seq2;
my $seq_bc;
my $seq_bc2;
my $qual;
my $qual2;
my $tmp;
my @gseq1;
my @gseq2;
my @gqual1;
my @gqual2;
my $lgth;
my $GC1;
my $GC2;
my $N1;
my $N2;
my $low1;
my $low2;
my $Q201;
my $Q202;
my $Q301;
my $Q302;
my $Qt1;
my $Qt2;
while(<I1>){
	chomp;  
	$name=$_;
	$name2=<I2>;
	chomp($name2);
	$seq=<I1>;
	chomp $seq;
	$seq2=<I2>;
	chomp($seq2);
	$seq_bc=$seq;
	$seq=uc $seq;
	$seq_bc2=$seq2;
	$seq2=uc $seq2;
	<I1>;
	$qual=<I1>;
	<I2>;
	$qual2=<I2>;
	chomp $qual;
	chomp($qual2);
	$inputnum++;
	$lgth=length ($seq);
	@gseq1=split('',$seq);
	@gseq2=split('',$seq2);
	@gqual1=split('',$qual);
	@gqual2=split('',$qual2);
	$N1=0;
	$N2=0;
	$low1=0;
	$low2=0;
	for (my $i=0;$i<$lgth;$i++){
		if (($gseq1[$i] eq 'G') or ($gseq1[$i] eq 'C')){
			$GC1++;
			}
		if (($gseq2[$i] eq 'G') or ($gseq2[$i] eq 'C')){
			$GC2++;
			}
		if ($gseq1[$i] eq 'N'){
			$N1++;
			}
		if ($gseq2[$i] eq 'N'){
			$N2++;
			}
		$gqual1[$i]=ord($gqual1[$i])-33;
		$gqual2[$i]=ord($gqual2[$i])-33;
		if ($gqual1[$i]<=5){
			$low1++;
		}
		if ($gqual2[$i]<=5){
			$low2++;
		}
		if ($gqual1[$i]>=20){
			$Q201++;
		}
		if ($gqual2[$i]>=20){
			$Q202++;
		}
		if ($gqual1[$i]>=30){
			$Q301++;
		}
		if ($gqual2[$i]>=30){
			$Q302++;
		}
		$Qt1+=$gqual1[$i];
		$Qt2+=$gqual2[$i];
	}
	$tmp=0.1*$lgth;
	if (($N1>$tmp)or ($N2>$tmp)){
		next;
	}
	$tmp=0.5*$lgth;
	if (($low1>$tmp)or ($low2>$tmp)){
		next;
	}

	print O1 "$name\n$seq_bc\n+\n$qual\n";
	print O2 "$name2\n$seq_bc2\n+\n$qual2\n";
	$outputnum++;
}	
my $total_length;
my $effective;
my $err1;
my $err2;
$effective=$outputnum/$inputnum;
$total_length=$inputnum*$lgth;
$GC1=$GC1/$total_length;
$GC2=$GC2/$total_length;
$Q201=$Q201/$total_length;
$Q202=$Q202/$total_length;
$Q301=$Q301/$total_length;
$Q302=$Q302/$total_length;
$Qt1=$Qt1/$total_length;
$Qt2=$Qt2/$total_length;
$err1=(-1)*$Qt1/10;
$err2=(-1)*$Qt2/10;
$err1=10**$err1;
$err2=10**$err2;
$total_length=$total_length*2;
my $outf;
$outf=chop($outfile1);
$outf=chop($outf);
$outf=chop($outf);
$outf=chop($outf);
$outf=chop($outf);
print "Sample_name\tRaw_reads\tRaw_Base(bp)\tEffective_Rate\tError_Rate\tQ20\tQ30\tGC_Content\n";
print "$outf\t$inputnum\t$total_length\t$effective\t$err1\t$err2\t$Q201\t$Q202\t$Q301\t$Q302\t$GC1\t$GC2\n";
close O1;
close O2;