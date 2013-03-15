import sys
import zmq
from PyQt4 import QtGui, QtCore

def incoming():
    context = zmq.Context()
    sock = context.socket(zmq.PULL)
    sock.connect('tcp://127.0.0.1:5561')

class MyView(QtGui.QGraphicsView):
    def __init__(self):
        QtGui.QGraphicsView.__init__(self)

        self.scene = QtGui.QGraphicsScene(self)
        self.scene.setSceneRect(QtCore.QRectF(0, 0, 245, 245))

        self.setScene(self.scene)

        self.item = QtGui.QGraphicsEllipseItem(0, 0, 60, 40)
        self.scene.addItem(self.item)

def loop():
    while True:
        msg = sock.recv()

        # parse command

        # examples:
        # update id [parameter list]
        # create 5 10 # creates an ellipse at 5,10
        X, Y = msg.split(' ')

        self.item = QtGui.QGraphicsEllipseItem(0, 0, 60, 40)
        self.scene.addItem(self.item)

        print msg
        if msg == 'END':
            break

if __name__ == '__main__':
    incoming()
    app = QtGui.QApplication(sys.argv)
    view = MyView()
    view.show()
    sys.exit(app.exec_())