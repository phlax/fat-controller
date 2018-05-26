from zope import component, interface

from ctrl.core.interfaces import ISystemctl
from ctrl.zmq.interfaces import IZMQRPCReply, IZMQRPCServer


@interface.implementer(IZMQRPCReply)
class FatControllerRPCReply(object):

    def __init__(self, context):
        self.context = context

    async def handle_stop(self, service):
        await component.getUtility(ISystemctl).stop(
            "controller-%s.service" % service)
        return 'RPC STOP RECV: %s, thanks' % service

    async def reply(self, message):
        message = ' '.join([m.decode('utf-8') for m in message])
        return await getattr(
            self,
            ('handle_%s'
             % message.split(' ')[0]))(message.split(' ')[1])


class RPCRouter(object):

    async def route(self):
        print('Setting up zmq rpc routing...')
        component.provideAdapter(
            adapts=(IZMQRPCServer, ),
            provides=IZMQRPCReply,
            factory=FatControllerRPCReply,
            name='fc-rpc')
