import math
import re
register_name = ['0','at','v0','v1','a0','a1','a2','a3','t0','t1','t2','t3','t4','t5','t6','t7','s0','s1','s2','s3','s4','s5','s6','s7','t8','t9','k0','k1','gp','sp','fp','ra']
opcode = {
    'nop':'000000',
    'lw':'100011','sw':'101011','lui':'001111',
    'add':'000000','addu':'000000','sub':'000000','and':'000000','or':'000000','xor':'000000','nor':'000000',
    'addi':'001000','addiu':'001001','andi':'001100',
    'sll':'000000','srl':'000000','sra':'000000',
    'slt':'000000','slti':'001010','sltiu':'001011',
    'beq':'000100','bne':'000101','blez':'000110','bgtz':'000111','bltz':'000001',
    'j':'000010','jal':'000011','jr':'000000','jalr':'000000'
}

funccode = {
    'nop':'000000',
    'add':'100000','addu':'100001','sub':'100010','and':'100100','or':'100101','xor':'100110','nor':'100111',
    'sll':'000000','srl':'000010','sra':'000011',
    'slt':'101010','jr':'001000','jalr':'001001'
}
def MachineCodeTranslate(assemblecode):    
    print(assemblecode)
    try:
        a = re.match(r'(.*)[ ]+\$(.*)[ ]*,[ ]*\$(.*),[ ]*\$(.*)',assemblecode)   
        if a:return opcode[a.group(1)] + register_translated(a.group(3)) + register_translated(a.group(4)) + register_translated(a.group(2)) + '00000' + funccode[a.group(1)]
        a = re.match(r'(.*)[ ]+\$(.*)[ ]*,[ ]*(.*)\(\$(.*)\)',assemblecode)
        if a:return opcode[a.group(1)] + register_translated(a.group(4)) + register_translated(a.group(2)) + imme_translated((lambda x:int(x,16) if x.startswith('0x') else int(x,10))(a.group(3)))
        a = re.match(r'(sll|srl|sra)[ ]*\$(.+)[ ]*,[ ]*\$(.+)[ ]*,[ ]*(.+)',assemblecode)
        if a:return opcode[a.group(1)] + '0'*5 + register_translated(a.group(3)) + register_translated(a.group(2)) + sha_translate(int(a.group(4))) + funccode[a.group(1)]
        a = re.match(r'(beq|bne)[ ]+\$(.*)[ ]*,[ ]*\$(.*)[ ]*,[ ]*([^\$]+)',assemblecode)
        if a:return opcode[a.group(1)] + register_translated(a.group(2)) + register_translated(a.group(3)) + imme_translated((lambda x:int(x,16) if x.startswith('0x') else int(x,10))(a.group(4)))
        a = re.match(r'(.*)[ ]+\$(.*)[ ]*,[ ]*\$(.*)[ ]*,[ ]*([^\$]+)',assemblecode)
        if a:return opcode[a.group(1)] + register_translated(a.group(3)) + register_translated(a.group(2)) + imme_translated((lambda x:int(x,16) if x.startswith('0x') else int(x,10))(a.group(4)))
        a = re.match(r'lui[ ]+\$(.*)[ ]*,[ ]*([^\$]+)',assemblecode)
        if a:return opcode['lui'] + '0'*5 + register_translated(a.group(1)) + imme_translated((lambda x:int(x,16) if x.startswith('0x') else int(x,10))(a.group(2)))
        a = re.match(r'(.*)[ ]+\$(.*)[ ]*,[ ]*([^\$]+)',assemblecode)
        if a:return opcode[a.group(1)] + register_translated(a.group(2)) + '0'*5 + imme_translated((lambda x:int(x,16) if x.startswith('0x') else int(x,10))(a.group(3)))
        a = re.match(r'(jal|j)[ ]+(.+)',assemblecode)
        if a:return opcode[a.group(1)] + imme_translated_26((lambda x:int(x,16) if x.startswith('0x') else int(x,10))(a.group(2)) + 2**20)
        a = re.match(r'(jr)[ ]+\$(.+)',assemblecode)
        if a:return opcode['jr'] + register_translated(a.group(2)) + '0'*15 + funccode['jr']
        a = re.match(r'jalr[ ]+\$(.+)[ ]*,[ ]*\$(.+)',assemblecode)
        if a:return opcode['jalr'] + register_translated(a.group(1)) + '0'*5 + register_translated(a.group(2)) + '0'*5 + funccode['jalr']
    except ValueError as e:
        print("Error in line:" + e.args[0].split()[0] + "is not a register name!")
        return None
    except KeyError as e:
        print("Error in line:" + e.args[0].split()[0] + " is not a instruction or the way using it is unproper")
        return None
    except Exception as e:
        print("Unknown Error!",e)
        return None
register_translated = lambda register:(lambda num:bin(num).replace('0b','0'*(4 - (lambda num:int(math.log2(num)) if num > 0 else 0)(num))))(register_name.index(register))
imme_translated = lambda imme:'0'*(18 - len(bin(imme))) + bin(imme).replace('0b','') if imme >= 0 else '0'*(18 - len(bin(2**16 - abs(imme)))) + bin(2**16 - abs(imme)).replace('0b','')
imme_translated_26 = lambda imme:'0'*(28 - len(bin(imme))) + bin(imme).replace('0b','') if imme >= 0 else '0'*(28 - len(bin(2**26 - abs(imme)))) + bin(2**26 - abs(imme)).replace('0b','')
sha_translate = lambda num:bin(num).replace('0b','0'*(4 - ((lambda num:int(math.log2(num)) if num >= 0 else 0)(num))))

instruction_set = []
for line in open("data.txt"):
    instruction_set.append(line.strip())

pos_dict = {}
pos = 0

for (m,instruction) in enumerate(instruction_set):
    a = re.match(r'^(.+):(.*)$',instruction)
    if a:
        if a.group(1) in pos_dict.keys():
            print("Error! ReDefine the name of a block")
        else:
            pos_dict[a.group(1)] = pos
            instruction_set[m] = re.sub(r'.+:','',instruction_set[m])
        if a.group(2) == '':
            continue
    pos += 1

instruction_set = [instruction for instruction in instruction_set if instruction]

for (m,instruction) in enumerate(instruction_set):
    try:
        instruction_set[m] = re.sub(r'((?:beq|bne)[ ]*\$.+,[ ]*\$.+,[ ]*)(.+)',lambda matched:matched.group(1) + str(pos_dict[matched.group(2)] - m - 1) if not re.match(r'-?(0x[0-9a-e]+|[0-9]+)',matched.group(2)) else matched.group(1) + matched.group(2),instruction)
        instruction_set[m] = re.sub(r'((?:jal[ ]|j[ ])[ ]*)(.+)',lambda matched:matched.group(1) + str(pos_dict[matched.group(2)]) if not re.match(r'-?(0x[0-9a-e]+|[0-9]+)',matched.group(2)) else matched.group(1) + matched.group(2), instruction_set[m])
    except Exception as e:
        print('Error!',e)
        
machine_instruction_set = [MachineCodeTranslate(instruction) for instruction in instruction_set]

#machine_instruction_set = [instruction for instruction in machine_instruction_set if instruction]

machine_instruction_set = ['0x' + "".join([hex(int("".join(instruction[i*4:(i+1)*4]),2)).replace('0x','') for i in range(8)]) for instruction in machine_instruction_set]

with open("m_code.txt",'w') as f:
    for instruction in machine_instruction_set:
        f.write(instruction)
        f.write('\n')
for instruction in machine_instruction_set:
    print(instruction)

    

    
