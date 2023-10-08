defmodule Bitpad.Validations.Wallets.GenerateSchema do
  use Goal

  defparams :generate do
    required :name, :string, min: 3, max: 20
  end
end
