defmodule Bitpad.Operations.Wallets.Import do
  import Bitpad.Operations.Wallets.Encryptor

  alias Ecto.Changeset

  alias Bitpad.Entities.Wallet
  alias Bitpad.Repo

  def call(wallet_params, user, token) do
    %{ "wif" => wif } = wallet_params

    case get_private_key(wif, wallet_params) do
      {:ok, private_key} ->
        import_wallet(wallet_params, user, token, private_key, wif)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp get_private_key(wif, wallet_params) do
   {:ok, BitcoinLib.Key.PrivateKey.from_wif(wif)}
  rescue
    _ ->
      {
        :error,
        %Changeset{
          valid?: false,
          data: %{},
          changes: wallet_params,
          errors: [wif: {"Invalid WIF", []}],
          action: :validate,
        }
      }
  end

  defp import_wallet(wallet_params, user, token, private_key, wif) do
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

