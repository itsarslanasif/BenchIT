import { createConsumer } from '@rails/actioncable';
import mitt from 'mitt';

const protocol = window.location.protocol === 'https:' ? 'wss' : 'ws';
const consumer = createConsumer(`${protocol}://${window.location.host}/cable`);
const emitter = mitt();
let channel = null;
let notificationChannel = null

function Cable() { }

Cable.prototype.on = (channel, callback) => {
  return emitter.on(channel, callback);
};

Cable.prototype.send = message => {
  channel.send({ message: message });
};

Cable.prototype.install = app => {
  app.plugin = this;
  app.config.globalProperties.$cable = this;
};

export const createCable = options => {
  channel = consumer.subscriptions.create(
    {
      channel: options.channel,
      id: options.id,
      type: options.type,
      current_profile_id: options.current_profile_id,
    },
    {
      received(data) {
        emitter.emit('chat', data);
      },
    }
  );
  return new Cable(channel);
};

export const createNotificationCable = options => {
  notificationChannel = consumer.subscriptions.create(
    {
      channel: options.channel,
      workspace_id: options.workspace_id,
      profile_id: options.profile_id,
    },
    {
      received(data) {
        emitter.emit('notification', data);
      },
    }
  );
  return new Cable(notificationChannel);
};

export const unsubscribe = () => {
  channel.unsubscribe();
}

export const unsubscribeNotification = () => {
  notificationChannel.unsubscribe();
}
