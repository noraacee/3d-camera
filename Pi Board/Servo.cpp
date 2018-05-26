#include "Servo.h"


Servo::Servo() {
	currentTiltAngle = 0;
	currentPanAngle = 0;
	lastTiltAngle = 90;
	lastPanAngle = 90;
	servoSelectPin = new GPIOClass(SERVO_GPIO_SELECT, "out");
	servoDataPin0 = new GPIOClass(SERVO_GPIO_DATA_0, "out");
	servoDataPin1 = new GPIOClass(SERVO_GPIO_DATA_1, "out");
	servoDataPin2 = new GPIOClass(SERVO_GPIO_DATA_2, "out");
	servoDataPin3 = new GPIOClass(SERVO_GPIO_DATA_3, "out");
	servoDataPin4 = new GPIOClass(SERVO_GPIO_DATA_4, "out");
	servoDataPin5 = new GPIOClass(SERVO_GPIO_DATA_5, "out");
	servoDataPin6 = new GPIOClass(SERVO_GPIO_DATA_6, "out");
	updateOutputs();
}

void Servo::setTiltAngle(int angle) {
	if(angle >= SERVO_MIN_ANGLE && angle <= SERVO_MAX_ANGLE) {
		currentTiltAngle = angle;
		updateOutputs();
	}
}

void Servo::setPanAngle(int angle) {
	if(angle >= SERVO_MIN_ANGLE && angle <= SERVO_MAX_ANGLE) {
		currentPanAngle = angle;
		updateOutputs();
	}
}

int Servo::getTiltAngle() const {
	return currentTiltAngle;
}

int Servo::getPanAngle() const {
	return currentPanAngle;
}

void Servo::updateOutputs() {
	if(lastTiltAngle != currentTiltAngle) {
		// You ready for this?
		int tempTiltAngle = currentTiltAngle;
		servoDataPin0->setval_gpio((tempTiltAngle % 2 == 1) ? "1" : "0");
		tempTiltAngle /= 2;
		servoDataPin1->setval_gpio((tempTiltAngle % 2 == 1) ? "1" : "0");
		tempTiltAngle /= 2;
		servoDataPin2->setval_gpio((tempTiltAngle % 2 == 1) ? "1" : "0");
		tempTiltAngle /= 2;
		servoDataPin3->setval_gpio((tempTiltAngle % 2 == 1) ? "1" : "0");
		tempTiltAngle /= 2;
		servoDataPin4->setval_gpio((tempTiltAngle % 2 == 1) ? "1" : "0");
		tempTiltAngle /= 2;
		servoDataPin5->setval_gpio((tempTiltAngle % 2 == 1) ? "1" : "0");
		tempTiltAngle /= 2;
		servoDataPin6->setval_gpio((tempTiltAngle % 2 == 1) ? "1" : "0");
		tempTiltAngle /= 2;
		servoSelectPin->setval_gpio("1");
		usleep(1);
		lastTiltAngle = currentTiltAngle;
	}

	if(lastPanAngle != currentPanAngle) {
		int tempPanAngle = currentPanAngle;
		servoDataPin0->setval_gpio((tempPanAngle % 2 == 1) ? "1" : "0");
		tempPanAngle /= 2;
		servoDataPin1->setval_gpio((tempPanAngle % 2 == 1) ? "1" : "0");
		tempPanAngle /= 2;
		servoDataPin2->setval_gpio((tempPanAngle % 2 == 1) ? "1" : "0");
		tempPanAngle /= 2;
		servoDataPin3->setval_gpio((tempPanAngle % 2 == 1) ? "1" : "0");
		tempPanAngle /= 2;
		servoDataPin4->setval_gpio((tempPanAngle % 2 == 1) ? "1" : "0");
		tempPanAngle /= 2;
		servoDataPin5->setval_gpio((tempPanAngle % 2 == 1) ? "1" : "0");
		tempPanAngle /= 2;
		servoDataPin6->setval_gpio((tempPanAngle % 2 == 1) ? "1" : "0");
		tempPanAngle /= 2;
		servoSelectPin->setval_gpio("0");
		usleep(1);
		lastPanAngle = currentPanAngle;
	}
}

Servo::~Servo() {
	delete servoSelectPin;
	delete servoDataPin0;
	delete servoDataPin1;
	delete servoDataPin2;
	delete servoDataPin3;
	delete servoDataPin4;
	delete servoDataPin5;
	delete servoDataPin6;
}
