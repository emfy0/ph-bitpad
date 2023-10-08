defmodule Bitpad.Operations.Wallets.Encryptor do
  alias Plug.Crypto

  def encrypt(token, data) do
    secret = Crypto.KeyGenerator.generate(token, "encrypted wallet")
    sign_secret = Crypto.KeyGenerator.generate(token, "signed encrypted wallet")

    Crypto.MessageEncryptor.encrypt(data, secret, sign_secret)
  end

  def decrypt(token, data) do
    secret = Crypto.KeyGenerator.generate(token, "encrypted wallet")
    sign_secret = Crypto.KeyGenerator.generate(token, "signed encrypted wallet")

    Crypto.MessageEncryptor.decrypt(data, secret, sign_secret)
  end
end
