defmodule Bitpad.Repo.Migrations.InitialMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string, null: false
      add :token_digest, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:login])

    create table(:wallets) do
      add :name, :string, null: false
      add :hashed_id, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :address, :string, null: false
      add :encrypted_private_key, :string, null: false

      timestamps()
    end

    create unique_index(:wallets, [:hashed_id])
    create index(:wallets, [:user_id, :address])
  end
end
