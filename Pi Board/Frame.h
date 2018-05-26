#ifndef FRAME_H
#define FRAME_H

#define WIDTH 320
#define HEIGHT 240
#define NUM_PIXELS (WIDTH * HEIGHT)

struct Frame {
	unsigned int pixels[NUM_PIXELS];
	bool completed;
	bool lock;
};

#endif