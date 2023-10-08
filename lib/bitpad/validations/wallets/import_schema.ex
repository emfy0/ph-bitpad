defmodule Bitpad.Validations.Wallets.ImportSchema do
  use Goal

  defparams :import do
    required :name, :string, min: 3, max: 20
    required :wif, :string
  end
end

