#ifndef VIDEO_FEED_H
#define VIDEO_FEED_H

#include <chrono>
#include "GenericComm.h"
#include "Frame.h"


class VideoFeed {
public:

	VideoFeed();
	~VideoFeed();

	Frame * getFrame();
	void updateLoop();

private:
	Frame * currentFrame;
	Frame * completeFrame;

	int offset;
	std::chrono::high_resolution_clock::time_point t_start;

	GenericComm * comm;
};

#endif