defmodule Geom.Path do
  @moduledoc """
  A pretty useless wrapper for List for now.
  """

  alias Geom.Path

  defstruct vertices: []

  def empty(),
  do: %Path{}

  def first(%Path{vertices: vertices}),
  do: List.first(vertices)

  def add(%Path{vertices: vertices}, vertex),
  do: %Path{vertices: vertices |> List.insert_at(-1, vertex)}

  def insert_first(%Path{vertices: vertices}, vertex),
  do: %Path{vertices: vertices |> List.insert_at(0, vertex)}

  def reverse(%Path{vertices: vertices}),
  do: %Path{vertices: vertices |> Enum.reverse}
end
