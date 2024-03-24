defmodule Bitpad.Validations.Wallets.ImportSchema do
  use Datacaster.Contract

  define_schema(:import) do
    hash_schema(
      name: non_empty_string() > check("length must be between 3 and 20", &(String.length(&1) in 3..20)),
      wif: non_empty_string()
    )
  end
end

