import { createConsumer } from '@rails/actioncable';
import mitt from 'mitt';

const protocol = window.location.protocol === 'https:' ? 'wss' : 'ws';
const consumer = createConsumer(`${protocol}://${window.location.host}/cable`);
const emitter = mitt();
let channel = null;

function Cable() {}

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
      current_user_id: options.current_user_id,
    },
    {
      received(data) {
        emitter.emit('chat', data);
      },
    }
  );
  return new Cable(channel);
};

export const unsubscribe = () => {
  channel.unsubscribe();
}