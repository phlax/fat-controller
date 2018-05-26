
from zope import component
import zope.event

from ctrl.core.interfaces import ISettings
from ctrl.systemd.listener import SystemdListener
from ctrl.zmq.events import ZMQPublisherEvent


class PublishRouter(object):
    subscription = 'ctrl'

    @property
    def config(self):
        return component.getUtility(ISettings)

    @property
    def services(self):
        sections = [
            s for s
            in self.config
            if s.startswith('service:')]
        for section in sections:
            yield section[8:]

    async def emit_systemd(self, message):
        # timestamp = message['__REALTIME_TIMESTAMP']
        unit = message['_SYSTEMD_UNIT'].split('-')[1].split('.')[0]
        action = message['MESSAGE']
        message = (
            "%s %s"
            % (action, unit))
        print('Sending: %s' % message)
        zope.event.notify(ZMQPublisherEvent('publish', 'ctrl', message))

    def filter_systemd(self, journal):
        for service in self.services:
            journal.add_match(
                _SYSTEMD_UNIT="controller-%s.service" % service)
        for k in ['starting', 'started', 'stopping', 'stopped']:
            journal.add_match(MESSAGE=k.upper())

    async def route(self):
        print('Adding systemd listener...')
        SystemdListener(
            self.emit_systemd,
            self.filter_systemd).listen()
