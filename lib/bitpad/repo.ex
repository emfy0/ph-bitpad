defmodule Bitpad.Repo do
  use Ecto.Repo,
    otp_app: :bitpad,
    adapter: Ecto.Adapters.SQLite3
end
