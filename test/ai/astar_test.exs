defmodule Geom.Ai.AstarTest do
  use ExUnit.Case
  alias Geom.Ai.Astar
  alias Geom.Shape.Vector2D
  alias Geom.Shape.Face
  alias Geom.Shape.NavigationMesh, as: NavMesh
  alias Geom.Shape.Path

  setup do
    v1 = %Vector2D{x: 1, y: 1}
    v2 = %Vector2D{x: 4, y: 1}
    v3 = %Vector2D{x: 3, y: 3}
    face1 = %Face{v1: v1, v2: v2, v3: v3}

    v4 = %Vector2D{x: 5, y: 3}
    face2 = %Face{v1: v2, v2: v3, v3: v4}

    v5 = %Vector2D{x: 4, y: 5}
    face3 = %Face{v1: v3, v2: v4, v3: v5}

    v6 = %Vector2D{x: 5, y: 0}
    face4 = %Face{v1: v2, v2: v4, v3: v6}

    v7 = %Vector2D{x: 8, y: 6}
    face5 = %Face{v1: v4, v2: v5, v3: v7}

    face6 = %Face{v1: v6, v2: v4, v3: v7}

    v8 = %Vector2D{x: 9, y: 0}
    face7 = %Face{v1: v6, v2: v7, v3: v8}


    faces = MapSet.new([face1, face2, face3, face4, face5, face6, face7])
    vertices = %{v1 => MapSet.new([face1]),
                 v2 => MapSet.new([face1, face2, face4]),
                 v3 => MapSet.new([face1, face2, face3]),
                 v4 => MapSet.new([face2, face3, face4, face5, face6]),
                 v5 => MapSet.new([face3, face5]),
                 v6 => MapSet.new([face4, face6, face7]),
                 v7 => MapSet.new([face5, face6, face7]),
                 v8 => MapSet.new([face7])}

    {:ok, %{nav_mesh: %NavMesh{faces: faces, vertices: vertices}}}
  end

  test "get_path same face", %{nav_mesh: nav_mesh} do
    v1 = %Vector2D{x: 2.5, y: 2}
    v2 = %Vector2D{x: 3, y: 2}
    assert {:ok, %Path{vertices: [^v1, ^v2]}} = Astar.get_path(nav_mesh, v1, v2)
  end

  test "get_path outside mesh", %{nav_mesh: nav_mesh} do
    v1 = %Vector2D{x: 3, y: 2} #Inside face1
    v2 = %Vector2D{x: 10, y: 3} #outside mesh

    assert {:ok, %Path{vertices: []}} = Astar.get_path(nav_mesh, v1, v2) #goal outside
    assert {:ok, %Path{vertices: []}} = Astar.get_path(nav_mesh, v2, v1) #start outside
    assert {:ok, %Path{vertices: []}} = Astar.get_path(nav_mesh, v2, v2) #both outside
  end

  test "get_path different faces", %{nav_mesh: nav_mesh} do
    v1 = %Vector2D{x: 3, y: 2} #Inside face1
    v2 = %Vector2D{x: 8, y: 4} #Inside face7
    v3 = %Vector2D{x: 3, y: 3}
    v4 = %Vector2D{x: 5, y: 3}
    v5 = %Vector2D{x: 8, y: 6}

    assert {:ok, %Path{vertices: [^v1, ^v3, ^v4, ^v5, ^v2]}} = Astar.get_path(nav_mesh, v1, v2)
  end
end
