//
//  Hello World client in C++
//  Connects REQ socket to tcp://localhost:5555
//  Sends "Hello" to server, expects "World" back
//
#include <zmq.hpp>
#include <string>
#include <bitset>
#include <iostream>

int main ()
{
    //  Prepare our context and socket
    zmq::context_t context (1);
    zmq::socket_t socket (context, ZMQ_REQ);

    std::cout << "Connecting to hello world server…" << std::endl;
    socket.connect ("tcp://localhost:5555");

    while(true) {
        // Send anything to receive latest frame
        zmq::message_t request (6);
        memcpy ((void *) request.data (), "Hello", 5);
        std::cout << "Requesting Frame " << std::endl;
        socket.send (request);
        int receiveMore = 1;
        size_t sizeOfMore = sizeof(receiveMore);

        do {
            //  Get the reply.
            zmq::message_t reply;
            socket.recv (&reply);
            void * ptr = reply.data();
            unsigned int * data = (unsigned int *) ptr;
            std::cout << std::bitset<16>(*data).to_string() << std::endl;
            socket.getsockopt(ZMQ_RCVMORE, &receiveMore, &sizeOfMore);
        } while(receiveMore);
        std::cout << "Frame Received" << std::endl;
    }
    return 0;
}