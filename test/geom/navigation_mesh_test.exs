defmodule NavigationMeshTest do
  use ExUnit.Case
  alias Geom.NavigationMesh, as: NavMesh
  alias Geom.Face
  alias Geom.Vector2D

  test "get adjacent vertices" do
    v1 = %Vector2D{x: 1, y: 2}
    v2 = %Vector2D{x: 3, y: 4}
    v3 = %Vector2D{x: 5, y: 6}
    v4 = %Vector2D{x: 7, y: 8}
    v5 = %Vector2D{x: 9, y: 10}
    v6 = %Vector2D{x: 11, y: 12}
    v7 = %Vector2D{x: 13, y: 14}
    v8 = %Vector2D{x: 15, y: 16}
    v9 = %Vector2D{x: 17, y: 18}


    face1 = %Face{v1: v1, v2: v2, v3: v3}
    face2 = %Face{v1: v1, v2: v5, v3: v6}
    face3 = %Face{v1: v7, v2: v5, v3: v9}

    faces = MapSet.new([face1, face2, face3])
    vertices = %{v1 => [face1, face2],
                 v2 => [face1],
                 v3 => [face1],
                 v4 => [],
                 v5 => [face2, face3],
                 v6 => [face2],
                 v7 => [face3],
                 v8 => [],
                 v9 => [face3]}

    nav_mesh = %NavMesh{faces: faces, vertices: vertices}


    assert [^v2, ^v3, ^v5, ^v6] = NavMesh.get_adjacent_vertices(nav_mesh, v1)
  end


end
