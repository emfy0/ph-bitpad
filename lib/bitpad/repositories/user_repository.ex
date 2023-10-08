defmodule Bitpad.Repositories.UserRepository do
  import Ecto.Query, warn: false

  alias Bitpad.Repo
  alias Bitpad.Entities.User

  def find_by_login(login) do
    from(u in User, where: u.login == ^login)
    |> Repo.one
  end
end
