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
      {%Face{} = single_face, %Face{} = single_face} ->
        %Path{}
        |> Path.add(start)
        |> Path.add(goal)

      {%Face{} = _face1, %Face{} = _face2} ->
        find_path_recursion([], [], start, nav_mesh, start, goal)

      _ -> Path.empty()
    end
  end

  defp find_path(start, goal, nav_mesh) do
    closed_set = []
    open_set = [start]
    paths = %{}
    parent_vertex = nil
    gscore = %{start => 0}
    fscore = %{start => calc_f_score(start, start, goal)}


    

    



  end

  defp evaluate_best_open_vertex(vertex, open_set, closed_set, g_score, f_score, paths, goal, goal_face) do
    current = Enum.min_by(open_set, fn(v) -> Map.fetch!(f_score, v) end)
    if Face.contains?(goal_face, current) do
      
    else
      open_set   = MapSet.remove(open_set, current)
      closed_set = MapSet.put(closed_set, current)
      
      neighbor_vertices = NavMesh.get_adjacent_vertices(nav_mesh, current_vertex)
      {open_set, g_score, f_score, paths} = Enum.reduce(neighbor_vertices,  
            {open_set, g_score, f_score, paths},
            fn(v, {open_set, g_score, f_score, paths}) -> 
              find_best_neighbor(v, current_vertex, open_set, closed_set, g_score, f_score, paths, goal) 
            end)
    end


  end

  defp find_best_neighbor(neighbor, parent, open_set, closed_set, g_score, f_score, paths, goal) do
    unless MapSet.member?(closed_set, neighbor) do
      new_g_score = Map.fetch(g_score, parent) + Vector2D.norm(Vector2D.sub(neighbor, parent))

      in_open_set? = MapSet.member?(open_set, neighbor)
      unless in_open_set? do
        open_set = MapSet.put(open_set, neighbor)
      end

      unless not in_open_set? and new_g_score >= Map.fetch(g_score, neighbor) do
        paths = %{paths | neighbor => parent}
        g_score = %{g_score | neighbor => new_g_score}
        f_score = %{f_score | neighbor => new_g_score + Vector2D.norm(Vector2D.sub(neighbor, goal))
      end
    end
    {open_set, g_score, f_score, paths}
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
