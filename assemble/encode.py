with open("verilog.txt",'w') as f:
	for m,line in enumerate(open('m_code.txt')):
		f.write(str(m) + ': data <=' + line.strip().replace('0x',"32'h") + ';')
		f.write('\n')


