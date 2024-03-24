defmodule Bitpad.Transactions.Wallets.Generate do
  require OK

  alias Bitpad.Validations.Wallets.GenerateSchema
  alias Bitpad.Operations.Wallets.Generate
  
  def call(user, token, wallet_params) do
    OK.for do
      generate_params <- GenerateSchema.validate_to_changeset(:generate, wallet_params)
      wallet <- Generate.call(generate_params, user, token)
    after
      wallet
    end
  end
end
