defmodule Geom.Shape.Face do
  @moduledoc """
  The face of a polygon represented by its 3 vertices.
  """

  alias Geom.Shape.Face
  alias Geom.Shape.Vector

  @type t :: %Face{v1: Vector.t, v2: Vector.t, v3: Vector.t}

  @derive [Poison.Encoder]
  defstruct v1: nil, v2: nil, v3: nil

  @doc "Returns true if the vector is one of the face's vertices, false otherwise."
  @spec is_own_vertex?(Face.t, Vector.t) :: boolean
  def is_own_vertex?(%Face{v1: v1, v2: v2, v3: v3}, v0),
  do: v0 == v1 or v0 == v2 or v0 == v3

  @doc "Returns true if the vector is inside the face, false otherwise."
  @spec contains?(Face.t, Vector.t) :: boolean
  def contains?(%Face{v1: v1, v2: v2, v3: v3} = face, v0) do
    if is_own_vertex?(face, v0) do
      true
    else
      # Compute vectors
      vec1 = Vector.sub(v3, v1)
      vec2 = Vector.sub(v2, v1)
      vec3 = Vector.sub(v0, v1)

      # Compute dot products
      dot00 = Vector.dot(vec1, vec1)
      dot01 = Vector.dot(vec1, vec2)
      dot02 = Vector.dot(vec1, vec3)
      dot11 = Vector.dot(vec2, vec2)
      dot12 = Vector.dot(vec2, vec3)

      # Compute barycentric coordinates
      invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
      u = (dot11 * dot02 - dot01 * dot12) * invDenom
      v = (dot00 * dot12 - dot01 * dot02) * invDenom

      # Check if point is in triangle
      (u >= 0) && (v >= 0) && (u + v < 1)
    end
  end
end
