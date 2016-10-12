defmodule Geom.Shape.NavigationMesh do
  @moduledoc """
  A face-vertex representation of a navigation mesh.
  """

  alias Geom.Shape.Face
  alias Geom.Shape.NavigationMesh
  alias Geom.Shape.Vector

  @type t :: %__MODULE__{faces: [Face.t], vertices: %{Vector.t => %{Face.t => boolean}}}

  @derive [Poison.Encoder]
  defstruct faces: %MapSet{}, vertices: %{}

  @error_vertex_not_in_mesh "Vertex not present in navigation mesh vertices."
  def error_vertex_not_in_mesh, do: @error_vertex_not_in_mesh

  @doc "Returns a list of the vertices connected by an edge to the given vertex if it's part of the mesh."
  @spec get_adjacent_vertices(NavigationMesh.t, Vector.t) :: {atom, [Vector.t] | String.t}
  def get_adjacent_vertices(%NavigationMesh{faces: _, vertices: vertices}, vertex) do
    if Map.has_key?(vertices, vertex) do
      {:ok, vertices
            |> Map.get(vertex)
            |> Enum.flat_map(fn(%Face{v1: v1, v2: v2, v3: v3}) -> [v1, v2, v3] end)
            |> Enum.uniq}
    else
      {:error, @error_vertex_not_in_mesh}
    end
  end

  @doc "Returns the face which contains or to which the given vertex belongs."
  @spec find_containing_face(NavigationMesh.t, Vector.t) :: Face.t | nil
  def find_containing_face(%NavigationMesh{faces: faces, vertices: _}, vertex) do
    Enum.find(faces, fn(face) -> Face.contains?(face, vertex) end)
  end

  @doc "Returns the face(s) that are connected to the given edge."
  @spec find_connected_faces(NavigationMesh.t, {Vector.t, Vector.t}) :: [Face.t]
  def find_connected_faces(%NavigationMesh{vertices: vertices}, {vertex1, vertex2} = _edge) do
    vertex1_faces = Map.get(vertices, vertex1)
    vertex2_faces = Map.get(vertices, vertex2)
    if vertex1_faces != nil and vertex2_faces != nil do
      {:ok, MapSet.intersection(vertex1_faces, vertex2_faces)}
    else
      {:error, @error_vertex_not_in_mesh}
    end
  end
end
