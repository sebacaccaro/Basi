# -*- coding: utf-8 -*-
fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

text = text.replace("OHKO","-1")
text = text.replace("Variabile","-2")
text = text.replace("–","0")

out_file = open("out.txt","w")
out_file.write(text)
out_file.close()
