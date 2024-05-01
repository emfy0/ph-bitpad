defmodule BitpadWeb.Router do
  use BitpadWeb, :router

  import BitpadWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BitpadWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BitpadWeb do
    pipe_through :browser

    get "/", Redirect, to: "/users/me"

    scope "/telegram-web-app" do
      get "/", Redirect, to: "/users/me", telegram_web_app: true
    end

    scope "/telegram" do
      get "/oauth_redirect", TelegramController, :oauth
    end

    scope "/auth" do
      live_session :not_authenticated,
        on_mount: [
          {BitpadWeb.UserAuth, :ensure_not_authenticated},
          {__MODULE__, :hide_navbar}
        ]
      do
        live "/sign_in", SessionSignInLive, :new
        live "/sign_up", SessionSignUpLive, :new
      end

      post "/sign_in", SessionController, :create
      delete "/sign_out", SessionController, :delete
    end

    live_session :ensure_current_user,
      on_mount: [
        {BitpadWeb.UserAuth, :ensure_current_user},
        {BitpadWeb.UserAuth, :mount_telegram_web_app},
      ]
    do
      scope "/users" do
        live "/me", UserMeLive, :show
      end

      scope "/wallets" do
        live "/generate", WalletGenerateLive, :show
        live "/import", WalletImportLive, :show
      end
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bitpad, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BitpadWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def on_mount(:hide_navbar, _params,  _session, socket) do
    {:cont, Phoenix.Component.assign(socket, :hide_navbar, true)}
  end
end
