fileINP = raw_input("Nomefile: ")
in_file = open("3gen.txt","r")
text = in_file.read()
in_file.close()

text = text.replace(',','\n')
i = 1
num_col = 8
finalstr = ""
for line in text.splitlines():
	if (i % num_col == 1) or (i % num_col == 2) or (i % num_col == 4):
		finalstr += line
		finalstr += "\t"
	if (i % num_col == 2):
		finalstr += "\N\t"
	if  (i % num_col == 5):
		finalstr += line
		finalstr += "\n"
	i += 1

out_file = open("out.txt","w")
out_file.write(finalstr)
out_file.close()
