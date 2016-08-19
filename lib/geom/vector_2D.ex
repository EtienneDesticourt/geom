defmodule Geom.Vector2D do
  @moduledoc """
  A 2D implementation of the vector protocol.
  """
  alias Geom.Vector

  @type t :: Vector.t

  defstruct x: 0, y: 0
end

defimpl Geom.Vector, for: Geom.Vector2D do
  alias Geom.Vector
  alias Geom.Vector2D

  def add(%Vector2D{x: x1, y: y1}, %Vector2D{x: x2, y: y2}),
  do: %Vector2D{x: x1 + x2, y: y1 + y2}

  def add(%Vector2D{x: x, y: y}, scalar) when is_number(scalar),
  do: %Vector2D{x: x + scalar, y: y + scalar}

  def sub(%Vector2D{x: x1, y: y1}, %Vector2D{x: x2, y: y2}),
  do: %Vector2D{x: x1 - x2, y: y1 - y2}

  def sub(%Vector2D{x: x, y: y}, scalar) when is_number(scalar),
  do: %Vector2D{x: x - scalar, y: y - scalar}

  def mul(%Vector2D{x: x, y: y}, scalar) when is_number(scalar),
  do: %Vector2D{x: x * scalar, y: y * scalar}

  def div(%Vector2D{} = _vector, 0),
  do: nil

  def div(%Vector2D{x: x, y: y}, scalar) when is_number(scalar),
  do: %Vector2D{x: x / scalar, y: y / scalar}

  def dot(%Vector2D{x: x1, y: y1}, %Vector2D{x: x2, y: y2}),
  do: x1 * x2 + y1 * y2

  def norm(%Vector2D{x: x, y: y}),
  do: :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))

  def unit(%Vector2D{} = vector),
  do: Vector.div(vector, Vector.norm(vector))
end
