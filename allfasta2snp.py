import sys,os
from Bio import SeqIO
from collections import Counter,OrderedDict

if len(sys.argv) <2 :
	print "python allfasta2snp.py abspath"
	sys.exit()

path = sys.argv[1]
names = os.listdir(path)
for i in names:
	if i.endswith('.mus'):
		abspath = os.path.join(path,i)
		outdict = OrderedDict()
		for i in SeqIO.parse(abspath,'fasta'):
			if outdict.has_key(i.id[:4]):
				outdict[i.id[:4]] += str(i.seq)
			else:
				outdict[i.id[:4]] =str(i.seq)


		seq = outdict.values()
		trans = zip(*seq)
		outseq = []
		for i in trans:
			d = Counter(tran)
			if len(d) >1 and '-' not in d.key():
				outseq.append(tran)
		outseq = zip(*outseq)
		outseq = [''.join(x) for i in outseq]
		outnames = outdict.key()
		assert len(outnames) == len(outseq)
		for i in range(len(outnames)):
			print '>%s\n%s' % (outnames[i],outseq[i ])
