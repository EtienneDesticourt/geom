defmodule Geom.NavigationMesh do
  @moduledoc """
  """
  alias Geom.NavigationMesh
  alias Geom.Vector
  alias Geom.Face

  defstruct faces: %MapSet{}, vertices: %{}


  def find_many(%NavigationMesh{faces: faces}, vertices) do

  end

  def get_adjacent_vertices(%NavigationMesh{faces: _faces, vertices: vertices} = _nav_mesh, vertex) do
    adjacent_faces = Map.get(vertices, vertex)
    adjacent_vertices = Enum.map(adjacent_faces, fn(%Face{v1: v1, v2: v2, v3: v3}) -> List.delete([v1, v2, v3], vertex) end)
    List.flatten(adjacent_vertices)
  end
end
