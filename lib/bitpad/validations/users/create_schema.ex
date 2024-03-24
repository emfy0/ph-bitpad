defmodule Bitpad.Validations.Users.CreateSchema do
  use Datacaster.Contract
 
   define_schema(:create) do
     hash_schema(
       login: non_empty_string() > check("length must be between 3 and 20", &(String.length(&1) in 3..20)),
       token: non_empty_string() > check("length must be between 7 and 20", &(String.length(&1) in 7..20))
     )
   end
end
