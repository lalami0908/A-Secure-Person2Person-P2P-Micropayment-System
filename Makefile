INCLUDE = /usr/local/opt/openssl/include/
LIBRARY = /usr/local/opt/openssl/lib/
FLAGS_mac = -lssl -lcrypto
CXX_mac = clang++
FLAGS_ubuntu = -lssl -lcrypto -lpthread
CXX = g++ -std=c++11

all:
	@echo "please specify os by using below command:"
	@echo "make mac"
	@echo "make ubuntu"


ubuntu: clean server_ubuntu client_ubuntu

mac: clean server_mac client_mac

server_ubuntu:
	$(CXX) server.cpp $(FLAGS_ubuntu) -o server

client_ubuntu:
	$(CXX) client.cpp $(FLAGS_ubuntu) -o client

server_mac:
	$(CXX_mac) -I$(INCLUDE) -L$(LIBRARY) $(FLAGS_mac) server.cpp -o server

client_mac:
	$(CXX_mac) -I$(INCLUDE) -L$(LIBRARY) $(FLAGS_mac) client.cpp -o client

clean:
	touch client
	touch server
	rm client server