defmodule Identicon do
  use TypeCheck

  @moduledoc """
  Documentation for `Identicon`.
  """
  @spec! main(String.t()) :: struct()
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
  end

  @spec! filter_odd_squares(struct()) :: struct()
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  @spec! pick_color(struct()) :: struct()
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @spec! build_grid(struct()) :: struct()
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
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
