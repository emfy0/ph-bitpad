defmodule ApiProviders.Bitfinex do
  @url "https://api.bitfinex.com/v2/calc/fx"

  def exchange_rate_of(cur, to_cur) do
    case HTTPoison.post(
      @url,
      Jason.encode!(%{ccy1: cur, ccy2: to_cur}),
      [{"Content-Type", "application/json"}]
    ) do
      {:ok, %{body: body}} ->
        {result, _} =
          body
          |> String.slice(1..-2//1)
          |> Float.parse()

        result
      {:error, _} ->
        0
    end
  end
end

