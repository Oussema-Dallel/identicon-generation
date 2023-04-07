defmodule Identicon do
  use TypeCheck

  @moduledoc """
  Documentation for `Identicon`.
  """
  @spec! main(String.t()) :: list
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  @spec! pick_color(struct()) :: list
  def pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    [r, g, b]
  end

  @spec! hash_input(String.t()) :: struct()
  def(hash_input(input)) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
