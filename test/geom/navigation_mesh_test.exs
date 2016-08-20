defmodule NavigationMeshTest do
  use ExUnit.Case
  alias Geom.NavigationMesh, as: NavMesh
  alias Geom.Face
  alias Geom.Vector2D

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

    nav_mesh = %NavMesh{faces: faces, vertices: vertices}

    {:ok, %{nav_mesh: nav_mesh, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5, v6: v6, v7: v7, face2: face2, face3: face3}}
  end

  test "get adjacent vertices success", %{nav_mesh: nav_mesh, v3: v3, v4: v4, v5: v5, v7: v7} do
    assert {:ok, [^v3, ^v4, ^v5, ^v7]} = NavMesh.get_adjacent_vertices(nav_mesh, v5)
  end

  test "get adjacent vertices failure vertex not in nav mesh", %{nav_mesh: nav_mesh} do
    message = NavMesh.error_vertex_not_in_mesh
    assert {:error, ^message} = NavMesh.get_adjacent_vertices(nav_mesh, %Vector2D{x: 22, y: 13})
  end

  test "find connected faces success", %{nav_mesh: nav_mesh, v3: v3, v4: v4, face2: face2, face3: face3} do
    assert {:ok, face_set} = NavMesh.find_connected_faces(nav_mesh, {v3, v4})
    assert MapSet.member?(face_set, face2)
    assert MapSet.member?(face_set, face3)
  end

  test "find connected faces not an edge", %{nav_mesh: nav_mesh, v1: v1, v5: v5} do
    assert {:ok, face_set} = NavMesh.find_connected_faces(nav_mesh, {v1, v5})
    assert MapSet.size(face_set) == 0
  end

  test "find connected faces vertex not part of nav mesh", %{nav_mesh: nav_mesh, v1: v1} do
    message = NavMesh.error_vertex_not_in_mesh
    assert {:error, ^message} = NavMesh.find_connected_faces(nav_mesh, {v1, %Vector2D{x: 23, y: 4}})
  end
end
