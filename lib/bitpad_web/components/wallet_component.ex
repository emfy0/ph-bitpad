defmodule BitpadWeb.WalletComponent do
  use BitpadWeb, :live_component

  def mount(socket) do
    {:ok, socket |> assign(:open, %{})}
  end

  def handle_event("open", %{ "wallet_id" => wallet_id }, socket) do
    open = socket.assigns[:open]

   {
     :noreply,
     socket
     |> assign(
       :open,
       open |> Map.put(wallet_id, eval_true_false(open[wallet_id]))
     )
    }
  end

  defp eval_true_false(value) do
    case value do
      nil -> true
      false -> true
      _ -> false
    end
  end

  def render(assigns) do
    ~H"""
    <div id={@id} >
      <div :for={wallet <- @wallets}>
        <details open={@open[wallet.hashed_id]}>
          <summary style="text-align: center" phx-click="open" phx-target={@myself} phx-value-wallet_id={wallet.hashed_id}>
            <%= wallet.name %>
          </summary>

          <div class="grid" style="justify-items: center;">
            <hgroup style="margin-top: 2.5rem">
              <h5 class="standart_color">
                <%= :io_lib.format("~.8f",[wallet.balance / 100_000_000]) %> BTC
              </h5>
              <h6 class="rate">
                <%= wallet.usd_balance %> USD
              </h6>
            </hgroup>

            <small style="margin-top: 3.5rem; margin-bottom: 1rem;">
              <strong>
                <%= wallet.address %>
              </strong>
            </small>

            <div style="margin-top: 1rem;">
              <a
                href="#"
                role="button"
                class="secondary"
                phx-click={
                  JS.push("broadcast-transaction-modal", value: %{wallet_hashed_id: wallet.hashed_id, next_transaction_bytes: wallet.next_transaction_bytes})
                  |> show_modal("broadcast-transaction")
                }
              >
                Make a pay
              </a>

              <.link href={~p"/users/me"} class="contrast outline" role="button" style="margin-top: 1rem;" method="delete">X</.link>
            </div>
          </div>

          <div>
            <details open={@open["#{wallet.hashed_id}_tx"]}>
              <summary style="margin-top: 1rem; text-align: center" phx-click="open" phx-target={@myself} phx-value-wallet_id={"#{wallet.hashed_id}_tx"}>
                Last wallet transactions
              </summary>

              <table>
                <head>
                  <tr>
                    <th scope="col">
                      Transaction ID
                    </th>
                  </tr>
                </head>

                <tr :for={transaction <- wallet.transactions}>
                  <td>
                    <a
                      href={"https://mempool.space/testnet/tx/#{transaction}"}
                      class="contrast"
                      target="_blank"
                    >
                      <%= transaction %>
                    </a>
                  </td>
                </tr>
              </table>
            </details>
          </div>
        </details>
      </div>
    </div>
    """
  end
end

