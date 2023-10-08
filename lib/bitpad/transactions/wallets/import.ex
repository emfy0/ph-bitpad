defmodule Bitpad.Transactions.Wallets.Import do
  require OK

  alias Bitpad.Validations.Wallets.ImportSchema
  alias Bitpad.Operations.Wallets.Import
  
  def call(user, token, wallet_params) do
    OK.for do
      generate_params <- ImportSchema.validate(:import, wallet_params)
      wallet <- Import.call(generate_params, user, token)
    after
      wallet
    end
  end
end

