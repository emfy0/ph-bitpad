defmodule Bitpad.Validations.Users.CreateSchema do
  use Goal

  defparams :create do
    required :login, :string, min: 3, max: 20
    required :token, :string, min: 7, max: 20
  end
end
