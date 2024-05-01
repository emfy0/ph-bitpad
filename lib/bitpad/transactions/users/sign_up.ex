defmodule Bitpad.Transactions.Users.SignUp do
  alias Bitpad.Validations.Users.CreateSchema
  alias Bitpad.Operations.Users.Create

  def call(params) do
    with(
      {:ok, user_params} <- CreateSchema.validate_to_changeset(:create, params),
      {:ok, user} <- Create.call(user_params),
      do: {:ok, user}
    )
  end
end
