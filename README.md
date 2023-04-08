# Identicon

## Description

`Identicon` is a package that generates an image similar to the one github uses. The image is a `250px * 250px`, mirrored accross the `y-axis` and depends solely on the given input `String`.

### Example

Given an input of `"Apple"` you would get this image:

![Image](./generated_images/Apple.png)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:identicon, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/identicon>.
