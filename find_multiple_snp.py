import sys
if len(sys.argv)<2:
    print "python find_multiple_snp.py mclOout speciesnum multiple "
    sys.exit()

with open(sys.argv[1]) as fa:
    for i in fa:
        C = []
        i = i.strip().split('\t')
        if  len(i) == int(sys.argv[2])*int(sys.argv[3]):
            for j in i:
                C.append(j.strip().split('|')[0])
            if sorted(list(set(C))*int(sys.argv[3])) == sorted(C):
                print i
