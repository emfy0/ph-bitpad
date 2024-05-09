defmodule Bitpad.Entities.Wallet do
  use Ecto.Schema

  import Ecto.Changeset

  alias ApiProviders.{Mempool, Bitfinex}

  schema "wallets" do
    belongs_to :user, Bitpad.Entities.User

    field :name, :string
    field :address, :string
    field :hashed_id, :string
    field :encrypted_private_key, :string

    field :balance, :integer, virtual: true
    field :usd_balance, :float, virtual: true
    field :transactions, {:array, :string}, virtual: true
    field :utxos, {:array, :string}, virtual: true
    field :next_transaction_bytes, :integer, virtual: true

    timestamps()
  end

  def create_changeset(params) do
    create_params = [:name, :address, :hashed_id, :encrypted_private_key, :user_id]

    %__MODULE__{}
    |> cast(params, create_params)
    |> validate_required(create_params)
    |> unique_constraint(:hashed_id)
    |> unique_constraint([:user_id, :address])
  end

  def fill_provider_attrs(wallet) do
    wallet
    |> fill_balance()
    |> fill_transactions()
    |> fill_utxos()
    |> fill_next_transaction_bytes()
  end

  def fill_balance(wallet) do
    wallet
      |> Map.put(:balance, Mempool.addr_balance(wallet.address))
      |> fill_usd_balance()
  end

  def fill_usd_balance(wallet) do
    wallet
      |> Map.put(:usd_balance, wallet.balance * Bitfinex.exchange_rate_of("BTC", "USD") / 100_000_000)
  end

  def fill_transactions(wallet) do
    wallet
      |> Map.put(:transactions, Mempool.addr_transactions_hashed_ids(wallet.address))
  end

  def fill_utxos(wallet) do
    wallet
      |> Map.put(:utxos, Mempool.utxo_ids_by_addr(wallet.address))
  end

  def fill_next_transaction_bytes(wallet) do
    wallet
      |> Map.put(:next_transaction_bytes, length(wallet.utxos) * 148 + 34 * 2 + 10)
  end
end
