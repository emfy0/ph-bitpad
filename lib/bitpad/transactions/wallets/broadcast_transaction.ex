defmodule Bitpad.Transactions.Wallets.BroadcastTransaction do
  require OK

  alias Bitpad.Validations.Wallets.BroadcastTransactionSchema
  alias Bitpad.Operations.Wallets.BroadcastTransaction
  
  def call(wallet, token, transaction_params) do
    OK.for do
      transaction_params <- BroadcastTransactionSchema.validate(:broadcast, transaction_params)
      status <- BroadcastTransaction.call(wallet, token, transaction_params)
    after
      status
    end
  end
end

