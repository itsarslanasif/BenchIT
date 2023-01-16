import CryptoJS from "crypto-js";

export const encryption = async (storage, key, value) => {
  if (value) {
    const ciphertext = CryptoJS.AES.encrypt(JSON.stringify(value), 'secret key 123').toString()
    console.log(ciphertext)
    storage.setItem(key, ciphertext)
  }
}

export const decryption = (storage, key) => {
  const value = storage.getItem(key)
  if (value) {
    const plaintext = CryptoJS.AES.decrypt(value, 'secret key 123').toString(CryptoJS.enc.Utf8)
    return JSON.parse(plaintext)
  }
}
