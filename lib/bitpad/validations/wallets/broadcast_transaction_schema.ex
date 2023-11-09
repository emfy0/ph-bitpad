defmodule Bitpad.Validations.Wallets.BroadcastTransactionSchema do
  use Goal

  defparams :broadcast do
    required :recipient_address, :string
    required :volume, :integer, min: 1
    required :fee_rate, :float, min: 0.5, max: 2
    required :broadcast, :boolean
  end
end
