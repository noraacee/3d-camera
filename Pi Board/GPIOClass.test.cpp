#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include "GPIOClass.h"
using namespace std;

void signal_handler(int s);
GPIOClass * led;

int main (void)
{

	// Detect Ctrl+C exit
	struct sigaction sigIntHandler;
	sigIntHandler.sa_handler = signal_handler;
	sigemptyset(&sigIntHandler.sa_mask);
	sigIntHandler.sa_flags = 0;
	sigaction(SIGINT, &sigIntHandler, NULL);

	led = new GPIOClass("2", "out");
	while(1) {
		led->setval_gpio("1");
		sleep(1);
		led->setval_gpio("0");
		sleep(1);
	}
    return 0;
}

void signal_handler(int s) {
	printf("Caught Signal: %d\n", s);
	led->setval_gpio("0");
	led->unexport_gpio();
	delete led;
	exit(1);
}