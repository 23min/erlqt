#
#	Sample subscriber to Erlang publisher
#

import zmq
import time

def main():
	context = zmq.Context()
	sock = context.socket(zmq.PULL)
	sock.connect('tcp://127.0.0.1:5561')
	# subscriber.setsockopt(zmq.SUBSCRIBE, '')

	time.sleep(1)

	while True:
		msg = sock.recv()
		if msg == 'END':
			break
		print 'Message: %s' % msg

if __name__ == '__main__':

	print zmq.zmq_version_info()
	main()