#ifndef SERVO_H
#define SERVO_H

#define SERVO_GPIO_SELECT "6"
#define SERVO_GPIO_DATA_0 "12"
#define SERVO_GPIO_DATA_1 "13"
#define SERVO_GPIO_DATA_2 "16"
#define SERVO_GPIO_DATA_3 "19"
#define SERVO_GPIO_DATA_4 "20"
#define SERVO_GPIO_DATA_5 "26"
#define SERVO_GPIO_DATA_6 "21"

#define SERVO_MIN_ANGLE 0
#define SERVO_MAX_ANGLE 90

#include <string>
#include "GPIOClass.h"
using namespace std;

class Servo {

public:
	Servo();
	~Servo();

	void setTiltAngle(int angle);
	void setPanAngle(int angle);
	int getTiltAngle() const;
	int getPanAngle() const;

private:
	int currentTiltAngle;
	int currentPanAngle;
	int lastTiltAngle;
	int lastPanAngle;

	GPIOClass * servoSelectPin;
	GPIOClass * servoDataPin0;
	GPIOClass * servoDataPin1;
	GPIOClass * servoDataPin2;
	GPIOClass * servoDataPin3;
	GPIOClass * servoDataPin4;
	GPIOClass * servoDataPin5;
	GPIOClass * servoDataPin6;

	void updateOutputs();
};

#endif