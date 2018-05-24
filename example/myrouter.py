
import zope.event.classhandler

from ctrl.zmq.events import ZMQSubscriberEvent
from ctrl.zmq.interfaces import IZMQRPCReply, IZMQRPCServer
from ctrl.zmq.rpc import ZMQRPCServer


class ZMQRPCCLIReply(object):

    def __init__(self, context):
        self.context = context

    def respond(self, socket, message):
        print("CLI: % message" % message)
        return 'thanks'


class ConfiguredRouter(object):

    def handle_subscribe(self, event):
        print('SUB(%s): %s' % (event.zmqid, event.message))

    async def route(self):
        print('Setting up zmq routing...')
        zope.event.classhandler.handler(
            ZMQSubscriberEvent,
            self.handle_subscribe)

        zope.component.provideAdapter(
            adapts=(IZMQRPCServer, ),
            provides=IZMQRPCReply,
            factory=ZMQRPCCLIReply,
            name='cli')
