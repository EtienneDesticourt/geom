defmodule Ai.Astar do
  @moduledoc """
  A* implementation for a navigation mesh.
  """

  alias Geom.Face
  alias Geom.NavigationMesh, as: NavMesh
  alias Geom.Path
  alias Geom.Vector

  @doc "Returns a path from the start vector to the goal vector along the nav mesh if it exists."
  @spec get_path(NavMesh.t, Vector.t, Vector.t) :: Path.t
  def get_path(nav_mesh, start, goal) do
    extreme_faces = find_extreme_faces(nav_mesh, start, goal)
    case extreme_faces do
      {%Face{} = single_face, %Face{} = single_face} ->
        %Path{vertices: [start, goal]}

      {%Face{} = start_face, %Face{} = goal_face} ->
        find_path(start, goal, start_face, goal_face, nav_mesh)

      _ ->
        Path.empty
    end
  end

  @spec find_path(Vector.t, Vector.t, Face.t, Face.t, NavMesh.t) :: Path.t
  defp find_path(start, goal, %Face{v1: v1, v2: v2, v3: v3}, goal_face, nav_mesh) do
    closed_set = MapSet.new |> MapSet.put(start)
    nav_mesh_start = Enum.min_by([v1, v2, v3], fn(v) -> calc_f_score(v, start, goal) end)
    open_set = MapSet.put(MapSet.new, nav_mesh_start)
    parents = %{nav_mesh_start => start}
    g_score = %{nav_mesh_start => 0}
    f_score = %{nav_mesh_start => calc_f_score(start, start, goal)}

    find_path_recursion(open_set, closed_set, g_score, f_score, parents, goal, goal_face, nav_mesh)
  end

  @spec find_path_recursion(MapSet.t, MapSet.t, Map, Map, Map, Vector.t, Face.t, NavMesh.t) :: Path.t
  defp find_path_recursion(open_set, closed_set, g_score, f_score, parents, goal, goal_face, nav_mesh) do
    #We get the vertex with the best score from the open set
    current = Enum.min_by(open_set, fn(v) -> Map.fetch!(f_score, v) end)

    #If it's in the goal face we can stop otherwise we check its neighbors
    if Face.contains?(goal_face, current) do
      retrace_steps(parents, current, goal, %Path{})
    else
      #Set vertex as evaluated
      open_set   = MapSet.delete(open_set, current)
      closed_set = MapSet.put(closed_set, current)

      #Calculate score for its neighbors
      {:ok, neighbor_vertices} = NavMesh.get_adjacent_vertices(nav_mesh, current)
      {open_set, g_score, f_score, parents} = evaluate_neighbors(neighbor_vertices, current, goal, open_set, closed_set, g_score, f_score, parents)

      #Return empty path if we've evaluated everything, otherwise continue recursion
      if MapSet.size(open_set) == 0 do
        %Path{}
      else
        find_path_recursion(open_set, closed_set, g_score, f_score, parents, goal, goal_face, nav_mesh)        
      end
    end
  end

  defp evaluate_neighbors(neighbors, current, goal, open_set, closed_set, g_score, f_score, parents) do
    Enum.reduce(neighbors, 
      {open_set, g_score, f_score, parents},
      fn(v, {open_set, g_score, f_score, parents}) ->
        evaluate_neighbor(v, current, goal, open_set, closed_set, g_score, f_score, parents)
      end)
  end

  @spec evaluate_neighbor(Vector.t, Vector.t, Vector.t, MapSet.t, MapSet.t, Map, Map, Map) :: {MapSet.t, Map, Map, Map}
  defp evaluate_neighbor(neighbor, parent, goal, open_set, closed_set, g_score, f_score, parents) do
    original_values = {open_set, g_score, f_score, parents}

    if MapSet.member?(closed_set, neighbor) do
      original_values
    else
      new_g_score = Map.fetch!(g_score, parent) + Vector.norm(Vector.sub(neighbor, parent))
      in_open_set? = MapSet.member?(open_set, neighbor)
      worst_g_score? = new_g_score >= Map.fetch(g_score, neighbor)
      cond do
        in_open_set? and worst_g_score? ->
          original_values

        not in_open_set? ->
          open_set = open_set |> MapSet.put(neighbor)
          {parents, g_score, f_score} = update_neighbor(neighbor, goal, parent, parents,new_g_score, g_score, f_score)
          {open_set, g_score, f_score, parents}

        :else ->
          {parents, g_score, f_score} = update_neighbor(neighbor, goal, parent, parents,new_g_score, g_score, f_score)
          {open_set, g_score, f_score, parents}        
      end
    end
  end

  defp update_neighbor(neighbor, goal, parent, parents, new_g_score, g_score, f_score) do
    parents = Map.put(parents, neighbor, parent)
    g_score = Map.put(g_score, neighbor, new_g_score)
    f_score = Map.put(f_score, neighbor, new_g_score + Vector.dist(neighbor, goal))
    {parents, g_score, f_score}    
  end

  @spec retrace_steps(%{}, Vector.t, Vector.t, Path.t) :: Path.t
  defp retrace_steps(parents, last_step, goal, path \\ %Path{}) do
    path = Path.add(path, last_step)
    if Map.has_key?(parents, last_step) do
      parent = Map.fetch!(parents, last_step)
      retrace_steps(parents, parent, goal, path)
    else
      path = case Path.first(path) do
        ^goal-> path

        _ -> Path.insert_first(path, goal)
      end
      Path.reverse(path)
    end
  end

  @spec find_extreme_faces(NavMesh.t, Vector.t, Vector.t) :: Face.t
  defp find_extreme_faces(%NavMesh{faces: faces} = nav_mesh, start, goal) do
    start_face = NavMesh.find_containing_face(nav_mesh, start)
    goal_face  = NavMesh.find_containing_face(nav_mesh, goal)
    {start_face, goal_face}
  end

  @spec calc_f_score(Vector.t, Vector.t, Vector.t) :: float
  defp calc_f_score(vertex, start, goal) do
    g = Vector.norm(Vector.sub(vertex, start))
    h = Vector.norm(Vector.sub(goal, vertex))
    g + h
  end
end
