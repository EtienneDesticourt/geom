defmodule Ai.Astar do
  @moduledoc """
  """
  alias Geom.Vector, as: Vector
  alias Geom.Face
  alias Geom.NavigationMesh, as: NavMesh
  alias Geom.Path

  @spec get_path(NavMesh.t, Vector.t, Vector.t) :: Path.t
  def get_path(nav_mesh, start, goal) do
    extreme_faces = find_extreme_faces(nav_mesh, start, goal)
    case extreme_faces do
      {%Face{} = single_face, %Face{} = single_face} ->
        %Path{}
        |> Path.add(start)
        |> Path.add(goal)

      {%Face{} = _start_face, %Face{} = goal_face} ->
        find_path(start, goal, goal_face, nav_mesh)

      _ ->
        Path.empty()
    end
  end

  defp find_path(start, goal, goal_face, nav_mesh) do
    closed_set = MapSet.new
    open_set = MapSet.put(MapSet.new, start)
    parents = %{}
    parent_vertex = nil
    g_score = %{start => 0}
    f_score = %{start => calc_f_score(start, start, goal)}

    build_path(open_set, closed_set, g_score, f_score, parents, goal, goal_face, nav_mesh)
  end

  defp build_path(open_set, closed_set, g_score, f_score, parents, goal, goal_face, nav_mesh) do
    current = Enum.min_by(open_set, fn(v) -> Map.fetch!(f_score, v) end)
    IO.inspect current
    if Face.contains?(goal_face, current) do
      retrace_steps(parents,current, goal, %Path{})
    else
      open_set   = MapSet.delete(open_set, current)
      closed_set = MapSet.put(closed_set, current)

      neighbor_vertices = NavMesh.get_adjacent_vertices(nav_mesh, current)
      {open_set, g_score, f_score, parents} = Enum.reduce(neighbor_vertices,
            {open_set, g_score, f_score, parents},
            fn(v, {open_set, g_score, f_score, parents}) ->
              find_best_neighbor(v, current, open_set, closed_set, g_score, f_score, parents, goal)
            end)

      unless MapSet.size(open_set) == 0 do
        build_path(open_set, closed_set, g_score, f_score, parents, goal, goal_face, nav_mesh)
      else
        %Path{}
      end
    end
  end

  defp find_best_neighbor(neighbor, parent, goal, open_set, closed_set, g_score, f_score, paths) do
    unless MapSet.member?(closed_set, neighbor) do
      new_g_score = Map.fetch(g_score, parent) + Vector.norm(Vector.sub(neighbor, parent))

      in_open_set? = MapSet.member?(open_set, neighbor)
      unless in_open_set? do
        open_set = MapSet.put(open_set, neighbor)
      end

      unless not in_open_set? and new_g_score >= Map.fetch(g_score, neighbor) do
        paths = %{paths | neighbor => parent}
        g_score = %{g_score | neighbor => new_g_score}
        f_score = %{f_score | neighbor => new_g_score + Vector.norm(Vector.sub(neighbor, goal))}
      end
    end
    {open_set, g_score, f_score, paths}
  end

  defp retrace_steps(parents, last_step, goal, %Path{} = path) do
    path = Path.add(path, last_step)
    if Map.has_key?(parents, last_step) do
      parent = Map.fetch!(parents, last_step)
      retrace_steps(parents, parent, goal, path)
    else
      case last_step do
        ^goal -> path

        _ -> Path.add(path, goal)
      end
    end
  end

  defp calc_f_score(vertex, start, goal) do
    g = Vector.norm(Vector.sub(vertex, start))
    h = Vector.norm(Vector.sub(goal, vertex))
    g + h
  end

  @spec find_extreme_faces(NavMesh.t, Vector.t, Vector.t) :: Face.t
  defp find_extreme_faces(%NavMesh{faces: faces} = _nav_mesh, start, goal) do
    Enum.reduce(faces, {nil, nil},
      fn(face, {start_face, end_face}) ->
        if Face.contains?(face, start),
        do: start_face = face
        if Face.contains?(face, goal),
        do: end_face = face
        {start_face, end_face}
      end)
  end
end
