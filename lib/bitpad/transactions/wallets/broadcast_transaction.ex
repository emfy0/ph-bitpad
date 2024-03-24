defmodule Bitpad.Transactions.Wallets.BroadcastTransaction do
  require OK

  alias Bitpad.Validations.Wallets.BroadcastTransactionSchema
  alias Bitpad.Operations.Wallets.BroadcastTransaction

  alias Bitpad.Entities.Wallet
  
  def call(wallet, token, transaction_params) do
    wallet = Wallet.fill_provider_attrs(wallet)

    OK.for do
      transaction_params <- BroadcastTransactionSchema.validate_to_changeset(
        :broadcast, transaction_params, %{wallet: wallet}
      )
      status <- BroadcastTransaction.call(wallet, token, transaction_params)
    after
      status
    end
  end
end

