import axios from '../../modules/axios';


export const createBookmark = async (name, bookmark_URL, bookmarkable_type, bookmarkable_id) => {
  return await axios
    .post('v1/bookmarks', {
      name: name,
      bookmark_URL: bookmark_URL,
      bookmarkable_type: bookmarkable_type,
      bookmarkable_id: bookmarkable_id
    }, {
      headers: {
        Authorization: sessionStorage.getItem('token')
      }
    });
};

export const getBookmarks = async (bookmarkable_type, bookmarkable_id) => {
  console.log(bookmarkable_type, bookmarkable_id)
  return await axios
    .get('v1/bookmarks', {
      headers: {
        Authorization: sessionStorage.getItem('token')
      }
      ,params: { bookmarkable_type: bookmarkable_type, bookmarkable_id: bookmarkable_id },
    })
    .then(response => {
      console.log(response)
      return response.data.bookmarks;
    })
}

export const updateBookmark = async (bookmark_id, name, url) => {
  return await axios
    .patch(`v1/bookmarks/${bookmark_id}`, {
      headers: {
        Authorization: sessionStorage.getItem('token')
      }
    ,bookmark: { name: name, bookmark_URL: url },
    })
}

export const deleteBookmark = async (bookmark_id) => {
 
  return await axios
    .delete(`v1/bookmarks/${bookmark_id}`, {
      headers: {
        Authorization: sessionStorage.getItem('token')
      }
    })
}
