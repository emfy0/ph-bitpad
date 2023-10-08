defmodule BitpadWeb.ModalComponent do
  use BitpadWeb, :live_component

  def mount(socket) do
    {:ok, socket |> assign(:oppened, false)}
  end

  def update(%{id: id, oppened: oppened, outside: outside} = _params, socket) when not is_nil(outside) do
    if id == socket.assigns.id do
      {:ok, socket |> assign(:oppened, oppened)}
    else
      {:ok, socket}
    end
  end

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  def handle_event("components-open-modal", _params, socket) do
   {
     :noreply,
     socket
     |> assign(:oppened, true)
    }
  end

  def handle_event("components-close-modal", _params, socket) do
   {
     :noreply,
     socket
     |> assign(:oppened, false)
    }
  end

  def render(assigns) do
    ~H"""
    <dialog
      id={@id}
      open={if @oppened, do: "true", else: "false"}
    >
      <article>
        <header>
          <strong>
            <%= @title %>
          </strong>

          <a
            href="#close"
            aria-label="Close"
            class="close"
            phx-click={hide_modal(@id)}
          >
          </a>
        </header>

        <%= render_slot(@inner_block) %>
      </article>
    </dialog>
    """
  end
end
