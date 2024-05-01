defmodule Bitpad.Transactions.Wallets.Import do
  alias Bitpad.Validations.Wallets.ImportSchema
  alias Bitpad.Operations.Wallets.Import
  
  def call(user, token, wallet_params) do
    with(
      {:ok, generate_params} <- ImportSchema.validate_to_changeset(:import, wallet_params),
      {:ok, wallet} <- Import.call(generate_params, user, token),
      do: {:ok, wallet}
    )
  end
end

