import axios from '../../modules/axios';

export const createBookmark = async (channel_id,name, bookmark_URL, user_id) => {
  return await axios
    .post(`v1/bench_channels/${channel_id}/bookmarks`, {
      name: name,
      bookmark_URL: bookmark_URL,
      user_id: user_id,
    }, {
      headers: {
        Authorization: sessionStorage.getItem('token')
      }
    })
    ;
};

export const getBookmarks = async (bench_channels_id) => {
  return await axios
    .get(`v1/bench_channels/${bench_channels_id}/bookmarks`, {
      headers: {
        Authorization: sessionStorage.getItem('token')
      },
    })
    .then(response => {
      return response.data.bookmarks;
    })
}
