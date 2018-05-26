#include <unistd.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <bitset>
#include "GenericComm.h"

extern "C" {
	void setupGPIO();
	void setGPIOIn(int pin); // Set pin to INPUT
	void setGPIOOut(int pin); // Set pin to OUTPUT
	int getGPIOValue(int pin); // Get value of pin (0 or 1)
	void setGPIOHigh(int pin); // Set pin HIGH
	void setGPIOLow(int pin); // Set pin LOW
};

GenericComm::GenericComm() {
	setupGPIO();
	setGPIOIn(GENERIC_COMM_0);
	setGPIOIn(GENERIC_COMM_1);
	setGPIOIn(GENERIC_COMM_2);
	setGPIOIn(GENERIC_COMM_3);
	setGPIOIn(GENERIC_COMM_4);
	setGPIOIn(GENERIC_COMM_5);
	setGPIOIn(GENERIC_COMM_6);
	setGPIOIn(GENERIC_COMM_7);
	setGPIOIn(GENERIC_COMM_8);
	setGPIOIn(GENERIC_COMM_9);
	setGPIOIn(GENERIC_COMM_10);
	setGPIOIn(GENERIC_COMM_11);
	setGPIOIn(GENERIC_COMM_12);
	setGPIOIn(GENERIC_COMM_13);
	setGPIOIn(GENERIC_COMM_14);
	setGPIOIn(GENERIC_COMM_15);
	setGPIOIn(GENERIC_COMM_RDY);
	setGPIOOut(GENERIC_COMM_ACK);
	setGPIOLow(GENERIC_COMM_ACK);
}

bool GenericComm::isDataReady() {
	//std::cout << getGPIOValue(GENERIC_COMM_RDY) << "\n";
	return getGPIOValue(GENERIC_COMM_RDY) == 1;
}

unsigned int GenericComm::readData() {
	int rdy = 0;
	while(rdy == 0) {
		rdy = getGPIOValue(GENERIC_COMM_RDY);
		//usleep(1);
	}

	unsigned int data = 0;

	data = getGPIOValue(GENERIC_COMM_0);
	data += getGPIOValue(GENERIC_COMM_1) << 1;
	data += getGPIOValue(GENERIC_COMM_2) << 2;
	data += getGPIOValue(GENERIC_COMM_3) << 3;
	data += getGPIOValue(GENERIC_COMM_4) << 4;
	data += getGPIOValue(GENERIC_COMM_5) << 5;
	data += getGPIOValue(GENERIC_COMM_6) << 6;
	data += getGPIOValue(GENERIC_COMM_7) << 7;
	data += getGPIOValue(GENERIC_COMM_8) << 8;
	data += getGPIOValue(GENERIC_COMM_9) << 9;
	data += getGPIOValue(GENERIC_COMM_10) << 10;
	data += getGPIOValue(GENERIC_COMM_11) << 11;
	data += getGPIOValue(GENERIC_COMM_12) << 12;
	data += getGPIOValue(GENERIC_COMM_13) << 13;
	data += getGPIOValue(GENERIC_COMM_14) << 14;
	data += getGPIOValue(GENERIC_COMM_15) << 15;

	setGPIOHigh(GENERIC_COMM_ACK);

	while(rdy == 1) {
		rdy = getGPIOValue(GENERIC_COMM_RDY);
		//usleep(1);
	}

	setGPIOLow(GENERIC_COMM_ACK);

	return data;
}