#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <zmq.hpp>
#include <string>
#include <pthread.h>
#include "VideoFeed.h"
#include "Frame.h"
using namespace std;

VideoFeed * vf;
void * zmq_server(void * ptr);

int main (void) {
	pthread_t zmqThread;
	int zmqThreadStatus = pthread_create(&zmqThread, NULL, zmq_server, NULL);
	// if(zmqThreadStatus) {
 //        fprintf(stderr,"Error - pthread_create() return code: %d\n",zmqThreadStatus);
 //        exit(EXIT_FAILURE);
 //    }

	vf = new VideoFeed();

	while(1) {
		//sleep(1);
		vf->updateLoop();
	}
    return 0;
}

void * zmq_server(void * ptr) {
	zmq::context_t context (1);
    zmq::socket_t socket (context, ZMQ_REP);
    socket.bind ("tcp://*:5555");

    while (true) {
    	try {
	        zmq::message_t request;

	        //  Wait for next request from client
	        if(socket.recv (&request)) {
	            //cout << "Received Frame Request" << std::endl;

	            //  Do some 'work'
	            Frame * f = vf->getFrame();
	            f->lock = true;

	            for(int i=0; i < NUM_PIXELS; i++) {
		            //  Send frame back to client
		            zmq::message_t frame(sizeof(unsigned int));
		            memcpy((void *) frame.data (), &f->pixels[i], sizeof(unsigned int));
		            int flags = ZMQ_SNDMORE;
		            if(i == NUM_PIXELS - 1) {
		            	flags = 0;
		            }
		            socket.send(frame, flags);
		        }

	            f->lock = false;
	        }
	    } catch(zmq::error_t &ex) {
	    	cout << "Error: " << ex.what() << std::endl;
	    }
    }
}
