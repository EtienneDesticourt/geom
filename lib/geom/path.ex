defmodule Geom.Path do
  alias Geom.Path

  defstruct vertices: []

  def empty(),
  do: %Path{}

  def add(%Path{vertices: vertices}, vertex),
  do: %Path{vertices: [vertex | vertices]}
end
