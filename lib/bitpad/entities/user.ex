defmodule Bitpad.Entities.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :login, :string
    field :token_digest, :string

    has_many :wallets, Bitpad.Entities.Wallet

    timestamps()
  end

  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:login, :token_digest])
    |> validate_required([:login, :token_digest])
    |> unique_constraint(:login)
  end
end
