defmodule Bitpad.Validations.Wallets.GenerateSchema do
  use Datacaster.Contract

  define_schema(:generate) do
    hash_schema(
      name: non_empty_string() > check("length must be between 3 and 20", &(String.length(&1) in 3..20))
    )
  end
end
