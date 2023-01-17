import { decryption } from "../crypto/crypto"

export const getHeaders = () => {
  return {
      Authorization: decryption(localStorage, 'token')
  }
}
