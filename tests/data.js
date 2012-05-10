window.testOpCodes = []
window.resultOpCodes = []
window.testOpCodes[0] = []
window.testOpCodes[1] = []
window.resultOpCodes[0] = []
window.resultOpCodes[1] = []

window.testOpCodes[0][0] = [0xbc,0x00, 0x30] //BC0030
window.resultOpCodes[0][0] = [13,12288,33,2]

window.testOpCodes[0][1] = [0x01, 0x00]
window.resultOpCodes[0][1] = [14,18,43,1,9,63,20,14,18,43,1,21,35,0,2]

window.testOpCodes[0][2] = [0x51]
window.resultOpCodes[0][2] = [30, 4, 2]

window.testOpCodes[0][3] = [0x53]
window.resultOpCodes[0][3] = [25, 4, 2]

window.testOpCodes[0][4] = [0x50]
window.resultOpCodes[0][4] = [6, 4, 2]

window.testOpCodes[0][5] = [0xe8, 0xf3, 0x2f] // Emulator geeft error op deze fout (seg0 niet opgeslagen)
window.resultOpCodes[0][5] = [2, 13, 12275, 28] // Derde/vierde waarde fout?

window.testOpCodes[0][6] = [0x00, 0x00]
window.resultOpCodes[0][6] = [14,18,43,1,22,73,20,14,18,43,1,66,62,0,2] // Mogelijk fout?

window.testOpCodes[0][7] = [0x83, 0xc4, 0x0c] //83C40C
window.resultOpCodes[0][7] = [19, 27, 12, 20, 33, 35, 2]

window.testOpCodes[0][8] = [0xbe, 0x00, 0x00]
window.resultOpCodes[0][8] = [13,0, 40, 2]


window.testOpCodes[0][9] = [0x09, 0x00]
window.resultOpCodes[0][9] = [14,18,43,1,9,63,84,14,18,43,1,21,50,0,2]

window.testOpCodes[0][10] = [0xea, 0x00, 0x00, 0x10, 0x00]
window.resultOpCodes[0][10] = [2, 13, 0, 27, 16, 142]

window.testOpCodes[0][11] = [0x55]
window.resultOpCodes[0][11] = [31, 4, 2]

window.testOpCodes[0][12] = [0x89, 0xe5]
window.resultOpCodes[0][12] = [19, 17, 2]

window.testOpCodes[0][13] = [0x56]
window.resultOpCodes[0][13] = [48, 4, 2	]

window.testOpCodes[0][14] = [0x53]
window.resultOpCodes[0][14] = [25, 4, 2]

window.testOpCodes[0][15] = [0x83, 0xec, 0x20]
window.resultOpCodes[0][15] = [19, 27, 32, 16, 33, 36, 2]

window.testOpCodes[0][16] = [0x8b, 0x5d, 0x08]
window.resultOpCodes[0][16] = [14, 95, 3, 8, 1, 9, 15, 0, 2]

window.testOpCodes[0][17] = [0x8b, 0x75, 0x0c]
window.resultOpCodes[0][17] = [14, 95, 3, 12, 1, 9, 40, 0, 2]

window.testOpCodes[0][18] = [0xc7, 0x04, 0x24, 0xa4]
window.resultOpCodes[0][18] = [13, 42020, 14, 43, 1, 21, 0, 2]

window.testOpCodes[0][19] = [0x90] //nop
window.resultOpCodes[0][19] = [0, 2]

/*
window.testOpCodes[0][] = []
window.resultOpCodes[0][] = []
*/


window.testOpCodes[1][0] = [0xbc,0x00, 0x30] //BC0030
window.resultOpCodes[1][0] = [13,12288,33,2]

window.testMicroCodes = []
window.resultMicroCodes = []
window.testMicroCodes[0] = []
window.testMicroCodes[1] = []
