defmodule SerializerTest do
  use ExUnit.Case
  alias Geom.NavigationMesh, as: NavMesh
  alias Geom.Face
  alias Geom.Vector2D
  alias Utils.Serializer

  @temp_file_path "test/temp/test_file"

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

    on_exit(fn -> File.rm(@temp_file_path) end)

    {:ok, %{nav_mesh: nav_mesh}}
  end

  test "serialize", %{nav_mesh: nav_mesh} do
    expected_data = "[{\"v3\":{\"y\":3,\"x\":3},\"v2\":{\"y\":1,\"x\":4},\"v1\":{\"y\":1,\"x\":1}},{\"v3\":{\"y\":5,\"x\":4},\"v2\":{\"y\":3,\"x\":5},\"v1\":{\"y\":3,\"x\":3}},{\"v3\":{\"y\":3,\"x\":5},\"v2\":{\"y\":3,\"x\":3},\"v1\":{\"y\":1,\"x\":4}},{\"v3\":{\"y\":0,\"x\":5},\"v2\":{\"y\":3,\"x\":5},\"v1\":{\"y\":1,\"x\":4}},{\"v3\":{\"y\":6,\"x\":8},\"v2\":{\"y\":3,\"x\":5},\"v1\":{\"y\":0,\"x\":5}},{\"v3\":{\"y\":0,\"x\":9},\"v2\":{\"y\":6,\"x\":8},\"v1\":{\"y\":0,\"x\":5}},{\"v3\":{\"y\":6,\"x\":8},\"v2\":{\"y\":5,\"x\":4},\"v1\":{\"y\":3,\"x\":5}}]"

    assert :ok = Serializer.serialize(nav_mesh, @temp_file_path)
    assert {:ok, ^expected_data} = File.read(@temp_file_path)
  end

  test "deserialize", %{nav_mesh: %NavMesh{faces: _faces, vertices: _} = nav_mesh} do
    raw_data = "[{\"v3\":{\"y\":3,\"x\":3},\"v2\":{\"y\":1,\"x\":4},\"v1\":{\"y\":1,\"x\":1}},{\"v3\":{\"y\":5,\"x\":4},\"v2\":{\"y\":3,\"x\":5},\"v1\":{\"y\":3,\"x\":3}},{\"v3\":{\"y\":3,\"x\":5},\"v2\":{\"y\":3,\"x\":3},\"v1\":{\"y\":1,\"x\":4}},{\"v3\":{\"y\":0,\"x\":5},\"v2\":{\"y\":3,\"x\":5},\"v1\":{\"y\":1,\"x\":4}},{\"v3\":{\"y\":6,\"x\":8},\"v2\":{\"y\":3,\"x\":5},\"v1\":{\"y\":0,\"x\":5}},{\"v3\":{\"y\":0,\"x\":9},\"v2\":{\"y\":6,\"x\":8},\"v1\":{\"y\":0,\"x\":5}},{\"v3\":{\"y\":6,\"x\":8},\"v2\":{\"y\":5,\"x\":4},\"v1\":{\"y\":3,\"x\":5}}]"
    File.write(@temp_file_path, raw_data, [:binary])

    assert ^nav_mesh = Serializer.deserialize(%NavMesh{}, @temp_file_path)
  end
end
