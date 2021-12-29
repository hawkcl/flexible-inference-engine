#ifndef UDP_H
#define UDP_H
#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>
#include "boost/lexical_cast.hpp"

using boost::asio::ip::udp;

class UDPClient
{
public:
	UDPClient(
		boost::asio::io_service& io_service,
		const std::string& host,
		const std::string& port
		) : io_service_(io_service), socket_(io_service, udp::endpoint(udp::v4(), 0)) {
		udp::resolver resolver(io_service_);
		udp::resolver::query query(udp::v4(), host, port);
		udp::resolver::iterator iter = resolver.resolve(query);
		endpoint_ = *iter;
	}
	~UDPClient()
	{
		socket_.close();
	}

	void send(unsigned char* send_buf, int len) {
		socket_.send_to(boost::asio::buffer(send_buf, len), endpoint_);
	}

	void receive(unsigned char* rec_buf, int& len) {
		boost::array<char, 128> recv_buf;
		size_t len1 = socket_.receive_from(
			boost::asio::buffer(recv_buf), endpoint_);
		len = len1;
		for(int i = 0; i < len; i++)
			rec_buf[i] = recv_buf.data()[i];
		//std::cout.write(recv_buf.data(), len);
	}

private:
	boost::asio::io_service& io_service_;
	udp::socket socket_;
	udp::endpoint endpoint_;
};


#endif