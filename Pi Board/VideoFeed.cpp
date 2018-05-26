#include <iostream>
#include <cstdlib>
#include <bitset>
#include <ctime>
#include "VideoFeed.h"


VideoFeed::VideoFeed() {
	currentFrame = new Frame();
	currentFrame->completed = false;
	currentFrame->lock = false;
	completeFrame = NULL;
	comm = new GenericComm();
	offset = 0;
	t_start = std::chrono::high_resolution_clock::now();
}

VideoFeed::~VideoFeed() {
	delete currentFrame;
	delete completeFrame;
	delete comm;
}

Frame * VideoFeed::getFrame() {
	return completeFrame;
}

void VideoFeed::updateLoop() {
	if(comm->isDataReady()) {
		unsigned int pixel = comm->readData();
		//std::cout << std::bitset<16>(pixel).to_string() << "\n";

		if(offset == 0 || offset == NUM_PIXELS) {
	  //   	std::chrono::high_resolution_clock::time_point t_end = std::chrono::high_resolution_clock::now();
			// std::cout << "Wall clock time passed: "
	  //           << std::chrono::duration<double, std::milli>(t_end-t_start).count()
	  //           << " ms\n"
	  //           << "Current FPS: "
	  //           << 1.0f / (std::chrono::duration<double, std::milli>(t_end-t_start).count() / 1000.0f) << std::endl;
			// t_start = std::chrono::high_resolution_clock::now();
			// New frame, so swap them
			if(completeFrame == NULL || !completeFrame->lock) {
				delete completeFrame;
				completeFrame = currentFrame;
			} else {
				delete currentFrame;
			}
			currentFrame = new Frame();
			offset = 0;
		}

		currentFrame->pixels[offset] = pixel;
		offset++;
	}
}
