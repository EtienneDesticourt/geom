defprotocol Geom.Vector do
  @moduledoc """
  """
  alias Geom.Vector2D

  @type t :: tuple

  def add(vector1, vector_or_scalar)

  def sub(vector1, vector_or_scalar)

  def mul(vector1, scalar)

  def div(vector1, scalar)

  def dot(vector1, vector2)

  def norm(vector1)

  def unit(vector1)
end
