defmodule Identicon do
  use TypeCheck

  @moduledoc """
  Documentation for `Identicon`.
  """
  @spec! main(String.t()) :: struct()
  def main(input) do
    input
    |> hash_input
  end

  @spec! hash_input(String.t()) :: struct()
  def(hash_input(input)) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
