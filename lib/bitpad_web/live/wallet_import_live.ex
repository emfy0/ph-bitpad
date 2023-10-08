defmodule BitpadWeb.WalletImportLive do
  use BitpadWeb, :live_view

  def mount(_params, session, socket) do
    form = to_form(%{}, as: "wallet")
    {
      :ok,
      assign(socket, form: form, user_token: session["user_token"]),
      temporary_assigns: [form: form]
    }
  end

  def handle_event("import", %{"wallet" => wallet_params}, socket) do
    case Bitpad.Transactions.Wallets.Import.call(
      socket.assigns.current_user, socket.assigns.user_token, wallet_params
    ) do
      {:ok, _} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Wallet imported successfully")
          |> push_navigate(to: Helpers.user_me_path(socket, :show))
        }

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, form: to_form(changeset, as: "wallet"))}
    end
  end
end
