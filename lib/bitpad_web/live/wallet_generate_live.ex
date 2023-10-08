defmodule BitpadWeb.WalletGenerateLive do
  use BitpadWeb, :live_view

  def mount(_params, session, socket) do
    form = to_form(%{}, as: "wallet")
    {
      :ok,
      assign(socket, form: form, user_token: session["user_token"]),
      temporary_assigns: [form: form]
    }
  end

  def handle_event("generate", %{"wallet" => wallet_params}, socket) do
    case Bitpad.Transactions.Wallets.Generate.call(
      socket.assigns.current_user, socket.assigns.user_token, wallet_params
    ) do
      {:ok, {wallet, wif}} ->
        {
          :noreply,
          socket
          |> assign(:new_wallet_wif, wif)
          |> assign(:new_wallet, wallet)
        }

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "wallet"))}
    end
  end
end
