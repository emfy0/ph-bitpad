defmodule Bitpad.Repositories.WalletRepository do
  import Ecto.Query

  alias Bitpad.Entities.Wallet
  alias Bitpad.Repo

  def find_by_user(user) do
    from(w in Wallet, where: w.user_id == ^user.id)
    |> Repo.all()
  end
  
  def find_by_hashed_id(hashed_id) do
    from(w in Wallet, where: w.hashed_id == ^hashed_id)
    |> Repo.one()
  end
end
