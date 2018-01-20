import random

fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

finalstr = ""
for i in range(1,151):
	for j in range(1,5):
		a = random.choice(text.splitlines())
		finalstr += str(i) 
		finalstr += "\t"
		finalstr += a
		finalstr += "\n"

	

out_file = open("out2.txt","w")
out_file.write(finalstr)
out_file.close()
