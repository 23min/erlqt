#
#	Sample subscriber to Erlang publisher
#

import zmq
import time

def main():
	context = zmq.Context()
	sock = context.socket(zmq.PUSH)
	sock.bind('tcp://127.0.0.1:5561')
	# subscriber.setsockopt(zmq.SUBSCRIBE, '')

	time.sleep(1)

	while True:
		time.sleep(1)
		sock.send("Time" + ':' + time.ctime())

if __name__ == '__main__':
	main()