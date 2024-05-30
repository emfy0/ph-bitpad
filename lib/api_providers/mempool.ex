defmodule ApiProviders.Mempool do
  @url "https://mempool.space/signet/api"

  require Logger

  def addr_balance(address) do
    url = @url <> "/address/#{address}"
    case HTTPoison.get(url) do
      {:ok, %{body: json_body}} ->
        body = Jason.decode!(json_body)

        chain_stats = body["chain_stats"]
        mempool_stats = body["mempool_stats"]

        chain_stats["funded_txo_sum"] - chain_stats["spent_txo_sum"] +
          mempool_stats["funded_txo_sum"] - mempool_stats["spent_txo_sum"]
      {:error, _} ->
        0
    end
  end

  def addr_transactions_hashed_ids(address) do
    url = @url <> "/address/#{address}/txs"
    case HTTPoison.get(url) do
      {:ok, %{body: json_body}} ->
        body = Jason.decode!(json_body)

        body
        |> Enum.map(fn tx -> tx["txid"] end)
      {:error, _} ->
        []
    end
  end

  def utxo_ids_by_addr(address) do
    url = @url <> "/address/#{address}/utxo"
    case HTTPoison.get(url) do
      {:ok, %{body: json_body}} ->
        body = Jason.decode!(json_body)

        body
        |> Enum.map(fn tx -> tx["txid"] end)
      {:error, _} ->
        []
    end
  end

  def transaction_by_id(txid) do
    url = @url <> "/tx/#{txid}"
    case HTTPoison.get(url) do
      {:ok, %{body: json_body}} ->
        body = Jason.decode!(json_body)

        body
      {:error, _} ->
        nil
    end
  end

  def broadcast_transaction(hex) do
    url = @url <> "/tx"

    case HTTPoison.post(url, hex) do
      {:ok, %{body: body}} ->
        body
      {:error, _} ->
        false
    end
  end

  def recommended_fee do
    url = @url <> "/v1/fees/recommended"

    case HTTPoison.get(url) do
      {:ok, %{body: json_body}} ->
        Logger.info(json_body)
        body = Jason.decode!(json_body)

        body["fastestFee"]
      {:error, _} ->
        nil
    end
  end
end
