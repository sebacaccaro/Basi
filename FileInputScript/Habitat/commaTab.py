import random

random.seed(238293284)
pkstart = 10
pkstop = 143
zstart = 1
zstop = 140
finalstr = ""

periodo = ["Giorno","Mattina","Notte","Sempre"]

for i in range(pkstart,pkstop):
	num = random.randint(0,5)
	for j in range(1,num):
		finalstr += str(random.randint(zstart,zstop))
		finalstr += '\t'
		finalstr += str(random.choice(periodo))
		finalstr += '\t'
		finalstr += str(i)
		finalstr += '\n'
	


out_file = open("out.txt","w")
out_file.write(finalstr)
out_file.close()
