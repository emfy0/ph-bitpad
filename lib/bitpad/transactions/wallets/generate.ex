defmodule Bitpad.Transactions.Wallets.Generate do
  alias Bitpad.Validations.Wallets.GenerateSchema
  alias Bitpad.Operations.Wallets.Generate
  
  def call(user, token, wallet_params) do
    with(
      {:ok, generate_params} <- GenerateSchema.validate_to_changeset(:generate, wallet_params),
      {:ok, wallet} <- Generate.call(generate_params, user, token),
      do: {:ok, wallet}
    )
  end
end
