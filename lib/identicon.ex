defmodule Identicon do
  use TypeCheck

  @moduledoc """
  Provides methods for generating and saving an `Identicon` similar to the github one.
  """

  @doc """
  Returns the final image when used
  """
  @spec! main(String.t()) :: :ok
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Saves the image under this path `./generated_images`
  """
  @spec! save_image(any(), String.t()) :: :ok
  def save_image(image, input) do
    File.write("./generated_images/#{input}.png", image)
  end

  @doc """
  Draws the image using the `:egd` graphic library and then it renders it.
  """
  @spec! draw_image(any()) :: binary()
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Builds the pixel map as a pre-requisite to the drawing process, the result is a
  `struct` of `{start, stop}` points for each `grid element
  """
  @spec! build_pixel_map(struct()) :: struct()
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Filters the odd squares for the grid of positions, leaving only the pair one,
  This is to indicate the colored squares
  """
  @spec! filter_odd_squares(struct()) :: struct()
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Picks the color to use for the image according to the first three elements from the `hex` list.
  """
  @spec! pick_color(struct()) :: struct()
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Builds the grid by chuncking the list of `hex` every 3 elements. Building the grid involves
  mirroring each row as well sa the final image is mirrored accross the `y` axis.
  """
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

  @doc """
  Mirrors a row, the row must have 3 elements for the method to work correctly.
  """
  @spec! mirror_row(Enum.t()) :: Enum.t()
  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  @doc """
  Hashes the input `String` using the `md5` algorithm and returns it as a `list`.
  """
  @spec! hash_input(String.t()) :: struct()
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
