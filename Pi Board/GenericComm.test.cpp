#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include "GenericComm.h"
using namespace std;

void signal_handler(int s);
GenericComm * comm;

int main (void) {

	// Detect Ctrl+C exit
	struct sigaction sigIntHandler;
	sigIntHandler.sa_handler = signal_handler;
	sigemptyset(&sigIntHandler.sa_mask);
	sigIntHandler.sa_flags = 0;
	sigaction(SIGINT, &sigIntHandler, NULL);

	comm = new GenericComm();
	int angle = 0;
	string data = "";
	string dataID = "";

	while(1) {
		comm->readData(dataID, data);
		printf("Data ID: %s  |  Data: %s\n", dataID.c_str(), data.c_str());
		sleep(1);
	}
    return 0;
}

void signal_handler(int s) {
	printf("\nCaught Signal: %d\n", s);
	delete comm;
	exit(1);
}