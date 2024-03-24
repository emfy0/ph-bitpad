defmodule Bitpad.Validations.Wallets.BroadcastTransactionSchema do
  use Datacaster.Contract

  define_schema(:broadcast) do
    recipient_address = check("invalid address", fn address ->
      case BitcoinLib.Address.destructure(address) do
        {status, _, _, network} ->
          status == :ok && network == :testnet     
        {:error, _} ->
          false
      end
    end)

    volume = check("insufficient funds", fn [volume, fee_rate] ->
      wallet = context.wallet
      wallet.balance >= round(volume + fee_rate * wallet.next_transaction_bytes)
    end)

    hash_schema(
      recipient_address: non_empty_string(),
      volume: to_integer() > check("must be greater than 0", &(&1 > 0)),
      fee_rate: to_float() > check("must be between 0.5 and 2", &(&1 > 0.5 and &1 < 2)),
      broadcast: to_boolean()
    ) > transform_to_hash(
      recipient_address: pick(:recipient_address) > recipient_address,
      volume: pick([:volume, :fee_rate]) > volume > pick(0),
      fee_rate: pick(:fee_rate),
      broadcast: pick(:broadcast)
    )
  end
end
