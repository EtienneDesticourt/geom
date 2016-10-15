defmodule Geom.Utils.Serializer do
    alias Geom.Shape.NavigationMesh
    alias Geom.Shape.Face
    alias Geom.Shape.Vector2D

    def serialize(%NavigationMesh{faces: faces, vertices: _}, file_path) do
        {:ok, file} = File.open(file_path, [:write])
        IO.binwrite(file, Poison.encode!(faces))
        File.close(file)
    end

    def deserialize(%NavigationMesh{} = nav_mesh, file_path) do
        {:ok, data} = File.read(file_path)
        faces = Poison.decode!(data, as: [%Face{v1: %Vector2D{}, v2: %Vector2D{}, v3: %Vector2D{}}])
        faces = MapSet.new(faces)
        vertices = faces |> Enum.flat_map(fn(%Face{v1: v1, v2: v2, v3: v3}) -> [v1, v2, v3] end)
                         |> Enum.uniq
                         |> Enum.reduce(%{}, fn(v, acc) -> Map.put(acc, v, find_faces_for_vertex(faces, v) |> MapSet.new) end)
        %NavigationMesh{nav_mesh | faces: faces, vertices: vertices}
    end

    defp find_faces_for_vertex(faces, vertex),
    do: Enum.filter(faces, fn(f) -> Face.is_own_vertex?(f, vertex) end)
end
