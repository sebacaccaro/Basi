import random

random.seed(238293284)
periodo = ["Prateria","Grotta","Acqua","Edificio"]
finalstr = ""
for i in range(1,140):
	num = random.randint(1,1)
	finalstr += random.choice(periodo) + '\n'
	


out_file = open("out.txt","w")
out_file.write(finalstr)
out_file.close()
