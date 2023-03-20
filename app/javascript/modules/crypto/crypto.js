import CryptoJS from 'crypto-js';

export const encryption = async (storage, key, value) => {
  if (value) {
    const ciphertext = CryptoJS.AES.encrypt(
      JSON.stringify(value),
      import.meta.env.VITE_APP_SECRET_KEY
    ).toString();
    storage.setItem(key, ciphertext);
  }
};

export const decryption = (storage, key) => {
  const value = storage.getItem(key);
  if (value) {
    const plaintext = CryptoJS.AES.decrypt(
      value,
      import.meta.env.VITE_APP_SECRET_KEY
    ).toString(CryptoJS.enc.Utf8);
    return JSON.parse(plaintext);
  }
};
