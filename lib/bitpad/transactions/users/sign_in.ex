defmodule Bitpad.Transactions.Users.SignIn do
  alias Bitpad.Repositories.UserRepository
  alias Bitpad.Operations.Users.AuthenticateByToken

  def call(login, token) do
    user = UserRepository.find_by_login(login)

    AuthenticateByToken.call(user, token)
    |> case do
      true ->
        {:ok, user}
      false ->
        {:error, "Invalid login or password"}
    end
  end
end
