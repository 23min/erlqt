#
#	Sample subscriber to Erlang publisher
#

import zmq
import time

def main():
	context = zmq.Context()
	subscriber = context.socket(zmq.SUB)
	subscriber.connect('tcp://127.0.0.1:5561')
	# subscriber.setsockopt(zmq.SUBSCRIBE, '')

	time.sleep(1)

	while True:
		msg = subscriber.recv()
		if msg == 'END':
			break
		print 'Message: %s' % msg

if __name__ == '__main__':
	main()