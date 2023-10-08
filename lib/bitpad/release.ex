defmodule Bitpad.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :bitpad

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def setup do
    load_app()

    Ecto.Adapters.SQLite3.storage_up(Bitpad.Repo.config())
    migrate()
  end

  def reset do
    load_app()

    Ecto.Adapters.SQLite3.storage_down(Bitpad.Repo.config())
    setup()
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
