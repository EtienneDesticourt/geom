defprotocol Geom.Shape.Vector do
  @moduledoc """
  A protocol with the functions to be implemented by the vectors of different dimensions.
  """

  @type t :: tuple

  @doc "Returns a vector with the coordinates of the two given vector summed 2 by 2, or the scalar added to each coord."
  def add(vector1, vector_or_scalar)

  @doc "Returns a vector with the coordinates of the two given vector subtracted 2 by 2, or the scalar subtracted from each coord."
  def sub(vector1, vector_or_scalar)

  @doc "Returns a vector with the coordinates of the given vector multiplied by the given scalar."
  def mul(vector, scalar)

  @doc "Returns a vector with the coordinates of the given vector divided by the given scalar."
  def div(vector, scalar)

  @doc "Returns the dot product of the two given vectors."
  def dot(vector1, vector2)

  @doc "Returns the length of the given vector."
  def norm(vector)

  @doc "Returns a vector of length one with the same direction as the given vector."
  def unit(vector)

  @doc "Returns the distance between two vectors."
  def dist(vector1, vector2)

  @doc "Returns whether two vectors are equal within an epsilon error value."
  def equal(vector1, vector2, epsilon)
end
