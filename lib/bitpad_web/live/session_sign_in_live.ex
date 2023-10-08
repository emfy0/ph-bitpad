defmodule BitpadWeb.SessionSignInLive do
  use BitpadWeb, :live_view

  def mount(_params, _session, socket) do
    login = live_flash(socket.assigns.flash, :login)
    form = to_form(%{"login" => login}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
