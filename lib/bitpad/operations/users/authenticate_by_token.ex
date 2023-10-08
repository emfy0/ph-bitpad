defmodule Bitpad.Operations.Users.AuthenticateByToken do
  def call(user, token) do
    case user do
      nil ->
        Bcrypt.no_user_verify()
      _ -> 
        Bcrypt.verify_pass(token, user.token_digest)
    end
  end
end
