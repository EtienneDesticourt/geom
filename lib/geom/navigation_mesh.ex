defmodule Geom.NavigationMesh do
  @moduledoc """
  A face-vertex representation of a navigation mesh.
  """

  alias Geom.NavigationMesh
  alias Geom.Vector
  alias Geom.Face

  @type t :: %__MODULE__{faces: [Face.t], vertices: %{Vector.t => Face.t}}

  defstruct faces: %MapSet{}, vertices: %{}

  @error_vertex_not_in_mesh "Vertex not present in navigation mesh vertices."
  def error_vertex_not_in_mesh, do: @error_vertex_not_in_mesh

  @doc "Returns a list of the vertices connected by an edge to the given vertex if it's part of the mesh."
  @spec get_adjacent_vertices(NavigationMesh.t, Vector.t) :: {atom, [Vector.t] | String.t}
  def get_adjacent_vertices(%NavigationMesh{faces: _faces, vertices: vertices} = _nav_mesh, vertex) do
    if Map.has_key?(vertices, vertex) do
      adjacent_faces = Map.get(vertices, vertex)
      adjacent_vertices = Enum.flat_map(adjacent_faces, fn(%Face{v1: v1, v2: v2, v3: v3}) -> List.delete([v1, v2, v3], vertex) end)
      {:ok, adjacent_vertices}
    else
      {:error, @error_vertex_not_in_mesh}
    end
  end
end
