defmodule Geom.NavigationMesh do
  @moduledoc """
  """
  alias Geom.NavigationMesh
  alias Geom.Vector
  alias Geom.Face

  @error_vertex_not_in_mesh "Vertex not present in navigation mesh vertices."
  def error_vertex_not_in_mesh, do: @error_vertex_not_in_mesh

  defstruct faces: %MapSet{}, vertices: %{}

  def find_closest_vertex(%NavigationMesh{faces: faces, vertices: vertices}, vertex) do

  end

  def get_adjacent_vertices(%NavigationMesh{faces: _faces, vertices: vertices} = _nav_mesh, vertex) do
    if Map.has_key?(vertices, vertex) do
      adjacent_faces = Map.get(vertices, vertex)
      adjacent_vertices = Enum.map(adjacent_faces, fn(%Face{v1: v1, v2: v2, v3: v3}) -> List.delete([v1, v2, v3], vertex) end)
      {:ok, List.flatten(adjacent_vertices)}
    else
      {:error, @error_vertex_not_in_mesh}
    end
  end
end
