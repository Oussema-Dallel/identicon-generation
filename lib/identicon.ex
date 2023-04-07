defmodule Identicon do
  use TypeCheck

  @moduledoc """
  Documentation for `Identicon`.
  """
  @spec! main(String.t()) :: list
  def main(input) do
    input
    |> hash_input
  end

  @spec! hash_input(String.t()) :: list
  def(hash_input(input)) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
  end
end
