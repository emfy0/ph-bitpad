defmodule BitpadWeb.UserMeLive do
  use BitpadWeb, :live_view

  alias BitpadWeb.ModalComponent
  alias Bitpad.Entities.Wallet
  alias Bitpad.Repositories.WalletRepository
  alias Bitpad.Transactions.Wallets.BroadcastTransaction

  def mount(_params, session, socket) do
    Process.send_after(self(), :update_wallets, 0)

    {
      :ok,
      socket
      |> assign(user_token: session["user_token"])
      |> assign(broadcast_transaction_form: to_form(%{}, as: "broadcast-transaction-from"))
      |> assign(loading_wallets: true)
      |> assign(selected_wallet: nil)
      |> assign(recommended_fee: ApiProviders.Mempool.recommended_fee() || raise("Can't get recommended fee"))
    }
  end

  def handle_event("broadcast-transaction-modal", %{"wallet_hashed_id" => wallet_hashed_id, "next_transaction_bytes" => next_transaction_bytes }, socket) do
    wallet =
      WalletRepository.find_by_hashed_id(wallet_hashed_id)
      |> Map.put(:next_transaction_bytes, next_transaction_bytes)

    {
      :noreply,
      socket
      |> assign(selected_wallet: wallet)
    }
  end

  def handle_event(
    "broadcast-transaction-validate", 
    %{ "broadcast-transaction-from" =>  transaction_from_params },
    socket
    ) do
    {
      :noreply,
      socket
      |> assign(broadcast_transaction_form: to_form(transaction_from_params, as: "broadcast-transaction-from"))
    }
  end

  def handle_event(
    "broadcast-transaction",
    %{ "broadcast-transaction-from" =>  transaction_from_params },
    socket
  ) do
    case BroadcastTransaction.call(
      socket.assigns.selected_wallet,
      socket.assigns.user_token,
      transaction_from_params
    ) do
      {:ok, {:broadcasted, tx_id}} ->
        send_update(ModalComponent, id: "broadcast-transaction", oppened: false, outside: true)

        {
          :noreply,
          socket
          |> assign(broadcast_transaction_form: to_form(%{}, as: "broadcast-transaction-from"))
          |> put_flash(:info, "Transaction #{tx_id} broadcasted")
        }

      {:ok, {:print, tx_hex}} ->
        send_update(ModalComponent, id: "broadcast-transaction", oppened: false, outside: true)

        {
          :noreply,
          socket
          |> assign(broadcast_transaction_form: to_form(%{}, as: "broadcast-transaction-from"))
          |> assign(print_transaction: tx_hex)
        }

      {:error, error} ->
        {:noreply, socket |> assign(broadcast_transaction_form: to_form(error, as: "broadcast-transaction-from"))}
    end
  end

  def handle_info(:update_wallets, socket) do
    wallets = WalletRepository.find_by_user(socket.assigns.current_user)

    wallets =
      Enum.map(wallets, fn wallet ->
        Wallet.fill_provider_attrs(wallet)
      end)

    {
      :noreply,
      socket
      |> assign(wallets: wallets)
      |> assign(loading_wallets: false)
    }
  end
end
