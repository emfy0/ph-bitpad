defmodule BitpadWeb.SessionController do
  use BitpadWeb, :controller

  alias BitpadWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.clear_current_user()
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: ~p"/auth/sign_in")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"login" => login, "token" => token} = user_params

    case Bitpad.Transactions.Users.SignIn.call(login, token) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.set_current_user(login, token)
        |> redirect(to: ~p"/users/me")
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: ~p"/auth/sign_in")
    end
  end
end
