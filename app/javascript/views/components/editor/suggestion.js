import { VueRenderer } from '@tiptap/vue-3'
import { createPopper } from '@popperjs/core';
import MentionList from './MentionList.vue'
import { useProfileStore } from '../../../stores/useProfileStore'

export default {

  items: ({ query }) => {
    return useProfileStore().profiles.filter(item => item.username.toLowerCase().startsWith(query.toLowerCase())).slice(0, 5)
  },

  render: () => {
    let component
    let popup

    return {
      onStart: props => {
        component = new VueRenderer(MentionList, {
          props,
          editor: props.editor,
        });

        if (!props.clientRect) {
          return;
        }

        const reference = (props.clientRect ? { getBoundingClientRect: props.clientRect } : null)
        const popper = component.element;

        const options = {
          placement: 'bottom-start',
          modifiers: [
            {
              name: 'offset',
              options: {
                offset: [0, 10],
              },
            },
            {
              name: 'preventOverflow',
              options: {
                rootBoundary: 'viewport',
              },
            },
          ],
        };
        popup = createPopper(reference, popper, options)
      },

      onUpdate(props) {
        component.updateProps(props);

        if (!props.clientRect) {
          return;
        }

        popup.update()
      },

      onKeyDown(props) {
        if (props.event.key === 'Escape') {
          popup[0].hide();

          return true;
        }

        return component.ref?.onKeyDown(props);
      },

      onExit() {
        popup.destroy()
        component.destroy()
      },
    };
  },
}