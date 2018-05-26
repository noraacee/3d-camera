all: clean video_feed

video_feed: GPIO.o GenericComm.h GenericComm.o VideoFeed.h VideoFeed.o
	g++ -std=c++0x GPIO.o GenericComm.o VideoFeed.o video_feed.cpp -o video_feed -Ofast -pthread -I/usr/local/include/ -L/usr/local/lib/ -lzmq

VideoFeed.o: GPIO.o GenericComm.h GenericComm.o VideoFeed.h VideoFeed.cpp
	g++ -std=c++0x -c VideoFeed.cpp -Ofast

tests: clean servo_test comm_test

zmq: clean_zmq zmq_server zmq_client

zmq_server:
	g++ zmq_server.cpp -I/usr/local/include/ -L/usr/local/lib/ -lzmq -o zmq_server

zmq_client:
	g++ zmq_client.cpp -I/usr/local/include/ -L/usr/local/lib/ -lzmq -o zmq_client

comm_test: GPIOClass.h GPIOClass.o GenericComm.h GenericComm.o
	g++ GPIOClass.o GenericComm.o GenericComm.test.cpp -o comm_test

GenericComm.o: GPIO.o GenericComm.h GenericComm.cpp
	g++ -c GenericComm.cpp -Ofast

servo_test: GPIOClass.h Servo.h GPIOClass.o Servo.o
	g++ Servo.o GPIOClass.o Servo.test.cpp -o servo_test

Servo.o: GPIOClass.o GPIOClass.h Servo.h Servo.cpp
	g++ -c Servo.cpp

gpio_test: GPIOClass.o
	g++ GPIOClass.o GPIOClass.test.cpp -o gpio_test

GPIO.o:
	gcc -c GPIO.c -Ofast

clean:
	rm -f *.so *.o *.gch gpio_test servo_test comm_test video_feed

clean_zmq:
	rm -f zmq_client zmq_server