import sys
from Bio import SeqIO

d_faa = dict((i.id,i.seq) for i in SeqIO.parse(sys.argv[1],'fasta'))
d_ffn = dict((i.id,i.seq) for i in SeqIO.parse(sys.argv[2],'fasta'))

faa = open('%s.formate.faa' % sys.argv[4],'w')
ffn = open('%s.formate.ffn' % sys.argv[4],'w')

#with open(sys.argv[3]) as fa:
for i in open(sys.argv[3]):
	i = i.strip().split()
	if d_faa.get(i[3]):
		faa.write('>%s\n' % i[1])
		faa.write('%s\n' % str(d_faa[i[3]]))
#with open(sys.argv[3]) as fb:
for i in open(sys.argv[3]):
	i = i.strip().split()
	if d_ffn.get(i[2]):
		ffn.write('>%s\n' % i[1])
		ffn.write('%s\n' % str(d_ffn[i[2]]))
faa.close()
ffn.close()	
