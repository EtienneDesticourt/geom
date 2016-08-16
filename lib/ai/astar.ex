defmodule Ai.Astar do
  @moduledoc """
  """
  alias Geom.Vector2D, as: Vector
  alias Geom.Face
  alias Geom.NavigationMesh, as: NavMesh
  alias Geom.Path

  @spec find_path(NavMesh.t, Vector.t, Vector.t) :: Path.t
  def find_path(nav_mesh, start, goal) do
    extreme_faces = find_extreme_faces(nav_mesh, start, goal)
    case extreme_faces do
      {single_face, single_face} ->
        %Path{}
        |> Path.add(start)
        |> Path.add(goal)

      {%Face{} = _face1, %Face{} = _face2} ->
        find_path_recursion([], [], start, nav_mesh, start, goal)

      _ -> Path.empty()
    end
  end

  defp find_path_recursion(open, closed, parent_vertex, nav_mesh, start, goal) do
    closed = closed ++ parent_vertex
    open = List.delete(open, parent_vertex)
    open = open ++ NavMesh.get_adjacent_vertices(nav_mesh, parent_vertex)
    best_vertex = Enum.min_by(open, fn(v) -> calc_f_score(v, start, goal) end)
    find_path_recursion(open, closed, best_vertex, nav_mesh, start, goal)
    #TODO: Add recursion end
  end

  defp calc_f_score(vertex, start, goal) do
    g = Vector.norm(Vector.sub(vertex, start))
    h = Vector.norm(Vector.sub(goal, vertex))
    g + h
  end


  #TODO: remove spec if not useful for private functions
  #TODO: Fix the placeholder logic below
  @spec find_extreme_faces(NavMesh.t, Vector.t, Vector.t) :: Face.t
  defp find_extreme_faces(%NavMesh{faces: faces} = _nav_mesh, start, goal) do
    start_face = nil
    end_face = nil
    faces
    |> Enum.map(fn(face) ->
      if Face.contains?(face, start),
      do: start_face = face
      if Face.contains?(face, goal),
      do: end_face = face
      end)
    {start_face, end_face}

  end
end
