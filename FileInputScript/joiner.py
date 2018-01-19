
in_file = open("out.txt","r")
in_file2 = open("out2.txt","r")
text = in_file.read()
tipi = in_file2.read()
in_file.close()
in_file2.close()

i = 0
finalstr = ""
for line in text.splitlines():
	line += "\t"	
	line += tipi.splitlines()[i]
	line += "\n"
	finalstr += line
	i += 1

out_file = open("out3.txt","w")
out_file.write(finalstr)
out_file.close()
