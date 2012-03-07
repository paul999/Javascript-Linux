window.testOpCodes = []
window.resultOpCodes = []
window.testOpCodes[0] = []
window.testOpCodes[1] = []
window.resultOpCodes[0] = []
window.resultOpCodes[1] = []

window.testOpCodes[0][0] = [0xbc,0x00, 0x30] //BC0030
window.resultOpCodes[0][0] = [13,12288,33,2]

window.testOpCodes[0][1] = [0x01, 0x00]
window.resultOpCodes[0][1] = [9,63,20,21,0,2]

window.testOpCodes[0][2] = [0x51]
window.resultOpCodes[0][2] = [30, 4, 2]

window.testOpCodes[0][3] = [0x53]
window.resultOpCodes[0][3] = [25, 4, 2]

window.testOpCodes[0][4] = [0x50]
window.resultOpCodes[0][4] = [6, 4, 2]

window.testOpCodes[0][5] = [0xe8, 0xf3, 0x2f]
window.resultOpCodes[0][5] = [2, 13, 12275, 28] // Derde/vierde waarde fout?

window.testOpCodes[0][6] = [0x00, 0x00]
window.resultOpCodes[0][6] = [22, 73, 20, 66, 0, 2] // Mogelijk fout?

window.testOpCodes[0][7] = []//[0x83, 0xc4, 0x0c] //83C40C
window.resultOpCodes[0][7] = [22, 73, 20, 66, 0, 2]

window.testOpCodes[0][8] = []//[0xbe, 0x00, 0x00]
window.resultOpCodes[0][8] = [22, 73, 20, 66, 0, 2]


window.testOpCodes[0][9] = []//[0x09, 0x00]
window.resultOpCodes[0][9] = [22, 73, 20, 66, 0, 2]

window.testOpCodes[0][10] = []//[0xea, 0x00, 0x00, 0x10, 0x00]
window.resultOpCodes[0][10] = [22, 73, 20, 66, 0, 2]


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
