defmodule Bitpad.Transactions.Users.SignUp do
  require OK

  alias Bitpad.Validations.Users.CreateSchema
  alias Bitpad.Operations.Users.Create

  def call(params) do
    OK.for do
      user_params <- CreateSchema.validate_to_changeset(:create, params)
      user <- Create.call(user_params)
    after
      user
    end
  end
end
