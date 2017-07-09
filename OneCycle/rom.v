`timescale 1ns/1ps

module ROM (addr,data);
input [31:0] addr;
output [31:0] data;
reg [31:0] data;
localparam ROM_SIZE = 32;
reg [31:0] ROM_DATA[ROM_SIZE-1:0];

always@(*)
	case(addr[9:2])	//Address Must Be Word Aligned.
/*
		0: data <=  32'h3c114000;
		1: data <=  32'h26310004;
		2: data <=  32'h241000aa;
		3: data <=  32'hae200000;
		4: data <=  32'h08100000;
		5: data <=  32'h0c000000;
		6: data <=  32'h00000000;
		7: data <=  32'h3402000a;
		8: data <=  32'h0000000c;
		9: data <=  32'h0000_0000;
		10: data <= 32'h0274_8825;
		11: data <= 32'h0800_0015;
		12: data <= 32'h0274_8820;
		13: data <= 32'h0800_0015;
		14: data <= 32'h0274_882A;
		15: data <= 32'h1011_0002;
		16: data <= 32'h0293_8822;
		17: data <= 32'h0800_0015;
		18: data <= 32'h0274_8822;
		19: data <= 32'h0800_0015; 
		20: data <= 32'h0274_8824;
		21: data <= 32'hae11_0003;
		22: data <= 32'h0800_0001;
*/
0: data <=32'h08000003;
1: data <=32'h08000035;
2: data <=32'h08000034;
3: data <=32'h00008020;
4: data <=32'h3c104000;
5: data <=32'h22100018;
6: data <=32'h00008820;
7: data <=32'h3c110000;
8: data <=32'h22310002;
9: data <=32'h00002020;
10: data <=32'h00002820;
11: data <=32'h2210fff0;
12: data <=32'hae000000;
13: data <=32'h2210fff8;
14: data <=32'h2008fc18;
15: data <=32'hae080000;
16: data <=32'h2008ffff;
17: data <=32'h22100004;
18: data <=32'hae080000;
19: data <=32'h20080003;
20: data <=32'h22100004;
21: data <=32'hae080000;
22: data <=32'h22100018;
23: data <=32'h00001020;
24: data <=32'h8e080000;
25: data <=32'h01114824;
26: data <=32'h1120fffd;
27: data <=32'h2210fffc;
28: data <=32'h8e040000;
29: data <=32'h22100004;
30: data <=32'h8e080000;
31: data <=32'h01114824;
32: data <=32'h1120fffd;
33: data <=32'h2210fffc;
34: data <=32'h8e050000;
35: data <=32'h22100004;
36: data <=32'h0800002b;
37: data <=32'h00805020;
38: data <=32'h01456022;
39: data <=32'h19800001;
40: data <=32'h01455022;
41: data <=32'h00a02020;
42: data <=32'h01402820;
43: data <=32'h1485fff9;
44: data <=32'h00801020;
45: data <=32'h3c104000;
46: data <=32'h2210000c;
47: data <=32'hae020000;
48: data <=32'h3c104000;
49: data <=32'h22100018;
50: data <=32'hae020000;
51: data <=32'h08000033;
52: data <=32'h03600008;
53: data <=32'h200dfff9;
54: data <=32'h0000b820;
55: data <=32'h3c174000;
56: data <=32'h22f70008;
57: data <=32'h8eee0000;
58: data <=32'h01ae6824;
59: data <=32'haeed0000;
60: data <=32'h22f7000c;
61: data <=32'h8eed0000;
62: data <=32'h31b60f00;
63: data <=32'h200e0100;
64: data <=32'h12c00007;
65: data <=32'h11d6000e;
66: data <=32'h000e7040;
67: data <=32'h11d60014;
68: data <=32'h000e7040;
69: data <=32'h11d6001a;
70: data <=32'h000e7040;
71: data <=32'h11d60000;
72: data <=32'h00007820;
73: data <=32'h30af00f0;
74: data <=32'h000f7902;
75: data <=32'h0c000068;
76: data <=32'h20180100;
77: data <=32'h01f87825;
78: data <=32'haeef0000;
79: data <=32'h080000a7;
80: data <=32'h00007820;
81: data <=32'h30af000f;
82: data <=32'h000f7902;
83: data <=32'h0c000068;
84: data <=32'h20180200;
85: data <=32'h01f87825;
86: data <=32'haeef0000;
87: data <=32'h080000a7;
88: data <=32'h00007820;
89: data <=32'h308f00f0;
90: data <=32'h000f7902;
91: data <=32'h0c000068;
92: data <=32'h20180400;
93: data <=32'h01f87825;
94: data <=32'haeef0000;
95: data <=32'h080000a7;
96: data <=32'h00007820;
97: data <=32'h308f000f;
98: data <=32'h000f7902;
99: data <=32'h0c000068;
100: data <=32'h20180800;
101: data <=32'h01f87825;
102: data <=32'haeef0000;
103: data <=32'h080000a7;
104: data <=32'h200d0000;
105: data <=32'h15ed0002;
106: data <=32'h200f0002;
107: data <=32'h03e00008;
108: data <=32'h21ad0001;
109: data <=32'h15ed0002;
110: data <=32'h200f009e;
111: data <=32'h03e00008;
112: data <=32'h21ad0001;
113: data <=32'h15ed0002;
114: data <=32'h200f0024;
115: data <=32'h03e00008;
116: data <=32'h21ad0001;
117: data <=32'h15ed0002;
118: data <=32'h200f000c;
119: data <=32'h03e00008;
120: data <=32'h21ad0001;
121: data <=32'h15ed0002;
122: data <=32'h200f0098;
123: data <=32'h03e00008;
124: data <=32'h21ad0001;
125: data <=32'h15ed0002;
126: data <=32'h200f0048;
127: data <=32'h03e00008;
128: data <=32'h21ad0001;
129: data <=32'h15ed0002;
130: data <=32'h200f0040;
131: data <=32'h03e00008;
132: data <=32'h21ad0001;
133: data <=32'h15ed0002;
134: data <=32'h200f001e;
135: data <=32'h03e00008;
136: data <=32'h21ad0001;
137: data <=32'h15ed0002;
138: data <=32'h200f0000;
139: data <=32'h03e00008;
140: data <=32'h21ad0001;
141: data <=32'h15ed0002;
142: data <=32'h200f0008;
143: data <=32'h03e00008;
144: data <=32'h21ad0001;
145: data <=32'h15ed0002;
146: data <=32'h200f0010;
147: data <=32'h03e00008;
148: data <=32'h21ad0001;
149: data <=32'h15ed0002;
150: data <=32'h200f00c0;
151: data <=32'h03e00008;
152: data <=32'h21ad0001;
153: data <=32'h15ed0002;
154: data <=32'h200f0062;
155: data <=32'h03e00008;
156: data <=32'h21ad0001;
157: data <=32'h15ed0002;
158: data <=32'h200f0084;
159: data <=32'h03e00008;
160: data <=32'h21ad0001;
161: data <=32'h15ed0002;
162: data <=32'h200f0070;
163: data <=32'h03e00008;
164: data <=32'h21ad0001;
165: data <=32'h200f0070;
166: data <=32'h03e00008;
167: data <=32'h0000b820;
168: data <=32'h3c174000;
169: data <=32'h22f70008;
170: data <=32'h8eee0000;
171: data <=32'h3c0f0000;
172: data <=32'h21ef0002;
173: data <=32'h01ee7025;
174: data <=32'haeee0000;
175: data <=32'h03400008;

	   default:	data <= 32'h0800_0000;
	endcase
endmodule
