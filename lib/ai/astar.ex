defmodule Ai.Astar do
  @moduledoc """

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
  defp find_path(start, goal, %Face{v1: v1, v2: v2, v3: v3} = start_face, goal_face, nav_mesh) do
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
    current = Enum.min_by(open_set, fn(v) -> Map.fetch!(f_score, v) end)

    if Face.contains?(goal_face, current) do
      retrace_steps(parents, current, goal, %Path{})
    else
      open_set   = MapSet.delete(open_set, current)
      closed_set = MapSet.put(closed_set, current)

      {:ok, neighbor_vertices} = NavMesh.get_adjacent_vertices(nav_mesh, current)
      {open_set, g_score, f_score, parents} = evaluate_neighbors(neighbor_vertices, current, goal, open_set, closed_set, g_score, f_score, parents)

      unless MapSet.size(open_set) == 0 do
        find_path_recursion(open_set, closed_set, g_score, f_score, parents, goal, goal_face, nav_mesh)
      else
        %Path{}
      end
    end
  end

  defp evaluate_neighbors(neighbors, current, goal, open_set, closed_set, g_score, f_score, parents) do
    acc = {open_set, g_score, f_score, parents}
    Enum.reduce(neighbors, acc,
      fn(v, {open_set, g_score, f_score, parents}) ->
        evaluate_neighbor(v, current, goal, open_set, closed_set, g_score, f_score, parents)
      end)
  end

  @spec evaluate_neighbor(Vector.t, Vector.t, Vector.t, MapSet.t, MapSet.t, Map, Map, Map) :: {MapSet.t, Map, Map, Map}
  defp evaluate_neighbor(neighbor, parent, goal, open_set, closed_set, g_score, f_score, parents) do
    unless MapSet.member?(closed_set, neighbor) do
      new_g_score = Map.fetch!(g_score, parent) + Vector.norm(Vector.sub(neighbor, parent))

      in_open_set? = MapSet.member?(open_set, neighbor)
      unless in_open_set? do
        open_set = MapSet.put(open_set, neighbor)
      end

      unless not in_open_set? and new_g_score >= Map.fetch(g_score, neighbor) do
        parents = Map.put(parents, neighbor, parent)
        g_score = Map.put(g_score, neighbor, new_g_score)
        f_score = Map.put(f_score, neighbor, new_g_score + Vector.norm(Vector.sub(neighbor, goal)))
      end
    end
    {open_set, g_score, f_score, parents}
  end

  @spec retrace_steps(%{}, Vector.t, Vector.t, Path.t) :: Path.t
  defp retrace_steps(parents, last_step, goal, %Path{} = path) do
    path = Path.add(path, last_step)
    if Map.has_key?(parents, last_step) do
      parent = Map.fetch!(parents, last_step)
      retrace_steps(parents, parent, goal, path)
    else
      path = case Path.first(path) do
        ^goal -> path

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
