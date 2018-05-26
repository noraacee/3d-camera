#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include "Servo.h"
using namespace std;

void signal_handler(int s);
Servo * servo;

int main (void)
{

	// Detect Ctrl+C exit
	struct sigaction sigIntHandler;
	sigIntHandler.sa_handler = signal_handler;
	sigemptyset(&sigIntHandler.sa_mask);
	sigIntHandler.sa_flags = 0;
	sigaction(SIGINT, &sigIntHandler, NULL);

	servo = new Servo();
	int angle = 1;
	bool forward = true;

	while(1) {
		servo->setTiltAngle(angle);
		printf("Tilt Angle: %d\r\n", servo->getTiltAngle());
		usleep(50000);
		servo->setPanAngle(angle);
		printf("Pan Angle: %d\r\n", servo->getPanAngle());
		usleep(50000);

		if(angle == 90 || angle == 0) {
			forward = !forward;
		}

		if(forward) {
			angle++;
		} else {
			angle--;
		}
	}
    return 0;
}

void signal_handler(int s) {
	printf("Caught Signal: %d\n", s);
	delete servo;
	exit(1);
}