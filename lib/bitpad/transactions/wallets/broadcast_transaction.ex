defmodule Bitpad.Transactions.Wallets.BroadcastTransaction do
  alias Bitpad.Validations.Wallets.BroadcastTransactionSchema
  alias Bitpad.Operations.Wallets.BroadcastTransaction

  alias Bitpad.Entities.Wallet
  
  def call(wallet, token, transaction_params) do
    wallet = Wallet.fill_provider_attrs(wallet)

    with(
      {:ok, transaction_params} <- BroadcastTransactionSchema.validate_to_changeset(
        :broadcast, transaction_params, %{wallet: wallet}
      ),
      {:ok, status} <- BroadcastTransaction.call(wallet, token, transaction_params),
      do: {:ok, status}
    )
  end
end

