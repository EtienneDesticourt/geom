defprotocol Geom.Vector do
  @moduledoc """
  """
  alias Geom.Vector2D

  @type t :: tuple

  @doc "Returns a vector with the coordinates of the two given vector summed 2 by 2, or the scalar added to each coord."
  def add(vector1, vector_or_scalar)

  def sub(vector1, vector_or_scalar)

  def mul(vector1, scalar)

  def div(vector1, scalar)

  def dot(vector1, vector2)

  def norm(vector1)

  def unit(vector1)
end
