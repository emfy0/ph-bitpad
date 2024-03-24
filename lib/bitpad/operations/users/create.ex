defmodule Bitpad.Operations.Users.Create do
  alias Bitpad.Entities.User

  def call(user_params) do
    %{"token" => token} = user_params

    user_params
    |> Map.delete("token")
    |> Map.put("token_digest", Bcrypt.hash_pwd_salt(token))
    |> User.create_changeset
    |> Bitpad.Repo.insert
  end
end
