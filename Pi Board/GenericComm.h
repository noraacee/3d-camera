#ifndef GENERIC_COMM_H
#define GENERIC_COMM_H

#define GENERIC_COMM_0 2
#define GENERIC_COMM_1 3
#define GENERIC_COMM_2 4
#define GENERIC_COMM_3 14
#define GENERIC_COMM_4 17
#define GENERIC_COMM_5 15
#define GENERIC_COMM_6 27
#define GENERIC_COMM_7 18
#define GENERIC_COMM_8 22
#define GENERIC_COMM_9 23
#define GENERIC_COMM_10 10
#define GENERIC_COMM_11 24
#define GENERIC_COMM_12 9
#define GENERIC_COMM_13 25
#define GENERIC_COMM_14 5
#define GENERIC_COMM_15 7

#define GENERIC_COMM_RDY 11
#define GENERIC_COMM_ACK 8

class GenericComm {
public:
	GenericComm();
	unsigned int readData(); // This method will hang until there is data and
					// also hang until the DE2 has acknowledged receipt of data
	bool isDataReady(); // Can be used to avoid hanging
};

#endif