defmodule BitpadWeb.SessionSignUpLive do
  use BitpadWeb, :live_view

  def mount(_params, _session, socket) do
    form = to_form(%{}, as: "user")
    {:ok, assign(socket, form: form, trigger_submit: false), temporary_assigns: [form: form]}
  end

  def handle_event("generate_token", _, socket) do
    form =
      socket.assigns.form
      |> Utils.Map.deep_merge(%{ params: %{ "token" => SecureRandom.hex(10) } })

    {
      :noreply,
      assign(socket, form: form)
    }
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    case Bitpad.Validations.Users.CreateSchema.validate(:create, user_params) do
      {:ok, _} ->
        {:noreply, assign(socket, form: to_form(user_params, as: "user"))}
  
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "user"))}
    end
  end

  def handle_event("submit", %{"user" => user_params}, socket) do
    case Bitpad.Transactions.Users.SignUp.call(user_params) do
      {:ok, _user} ->
        {
          :noreply,
          socket |> assign(trigger_submit: true) |> assign(form: to_form(user_params, as: "user"))
        }
  
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "user"))}
    end
  end
end
