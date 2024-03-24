defmodule Bitpad.Operations.Wallets.BroadcastTransaction do
  alias ApiProviders.Mempool
  alias BitcoinLib.Transaction

  import Bitpad.Operations.Wallets.Encryptor

  def call(
    wallet,
    user_token,
   %{
      "recipient_address" => recipient_address,
      "volume" => volume,
      "fee_rate" => fee_rate,
      "broadcast" => broadcast
    }
  ) do
  
    {:ok, private_key_wif} = decrypt(user_token, wallet.encrypted_private_key)
    private_key = BitcoinLib.Key.PrivateKey.from_wif(private_key_wif)

    {:ok, tx} = build_transaction(wallet, private_key, volume, fee_rate, recipient_address)

    if broadcast do
      {:ok, {:broadcasted, Mempool.broadcast_transaction(tx)}} # tx_id here
    else
      {:ok, {:print, tx}}
    end
  end

  defp build_transaction(wallet, private_key, volume, fee_rate, recipient_address) do
    %Transaction.Spec{}

    utxo_ids = Mempool.utxo_ids_by_addr(wallet.address)

    utxos =
      Task.async_stream(utxo_ids, fn utxo_id ->
        Mempool.transaction_by_id(utxo_id)
      end)
      |> Stream.map(fn {_, tx} -> tx end)
      |> Enum.uniq_by(fn tx -> tx["txid"] end)

    change_output_sctipt = create_output_sctipt_from_address(wallet.address)
    recipient_output_sctipt = create_output_sctipt_from_address(recipient_address)

    unsigned_transaction = %Transaction.Spec{}
    |> build_inputs(utxos, wallet.address)
    |> Transaction.Spec.add_output(
      change_output_sctipt,
      wallet.balance - round(volume + fee_rate * wallet.next_transaction_bytes)
    )
    |> Transaction.Spec.add_output(
      recipient_output_sctipt,
      volume
    )

    unsigned_transaction
    |> Transaction.Spec.sign_and_encode(
      [private_key]
      |> List.duplicate(length(unsigned_transaction.inputs))
      |> List.flatten
    )
  end

  defp create_output_sctipt_from_address(address) do
    {:ok, public_key_hash, type, _} = BitcoinLib.Address.destructure(address)

    case type do
      :p2pkh ->
        BitcoinLib.Script.Types.P2pkh.create(public_key_hash)
      :p2sh ->
        BitcoinLib.Script.Types.P2sh.create(public_key_hash)
      :p2wpkh ->
        BitcoinLib.Script.Types.P2wpkh.create(public_key_hash)
    end
  end

  defp build_inputs(tx_spec, utxos, current_wallet_addr) do
    Enum.reduce(utxos, tx_spec, fn utxo, acc ->
      build_inputs_from_output(acc, utxo, current_wallet_addr)
    end)
  end

  defp build_inputs_from_output(tx_spec, utxo, current_wallet_addr) do
    utxo["vout"]
    |> Enum.with_index
    |> Enum.reduce(tx_spec, fn {output, index}, acc ->
      if output["scriptpubkey_address"] == current_wallet_addr do
        acc
        |> Transaction.Spec.add_input!(
          txid: utxo["txid"],
          vout: index,
          redeem_script: output["scriptpubkey"]
        )
      else
        acc
      end
    end)
  end
end
