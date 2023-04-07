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
    |> build_grid
  end

  @spec! pick_color(struct()) :: struct()
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @spec! build_grid(struct()) :: list
  def build_grid(%Identicon.Image{hex: hex} = image) do
    hex
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&mirror_row/1)
  end

  @spec! mirror_row(Enum.t()) :: Enum.t()
  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  @spec! hash_input(String.t()) :: struct()
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
