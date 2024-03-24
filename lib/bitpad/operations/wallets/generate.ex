defmodule Bitpad.Operations.Wallets.Generate do
  import Bitpad.Operations.Wallets.Encryptor

  alias Bitpad.Entities.Wallet
  alias Bitpad.Repo

  def call(wallet_params, user, token) do
    %{ raw: _, wif: wif } = BitcoinLib.Key.PrivateKey.generate()

    private_key = BitcoinLib.Key.PrivateKey.from_wif(wif)

    address =
      private_key
      |> BitcoinLib.Key.PublicKey.from_private_key()
      |> BitcoinLib.Address.from_public_key(:p2pkh, :testnet)

    wallet_params
    |> Map.put("user_id", user.id)
    |> Map.put("encrypted_private_key", encrypt(token, wif))
    |> Map.put("hashed_id", SecureRandom.uuid())
    |> Map.put("address", address)
    |> Wallet.create_changeset()
    |> Repo.insert()
    |> case do
      {:ok, wallet} ->
        {:ok, {wallet, wif}}
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
