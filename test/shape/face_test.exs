defmodule Geom.Shape.FaceTest do
  use ExUnit.Case
  alias Geom.Shape.Face
  alias Geom.Shape.Vector2D

  test "contains? when vertex in face" do
    face = %Face{v1: %Vector2D{x: 2, y: 2}, v2: %Vector2D{x: 6, y: 3}, v3: %Vector2D{x: 3, y: 4}}

    assert Face.contains?(face, %Vector2D{x: 3, y: 3})
  end

  test "contains? when vertex outside face" do
    face = %Face{v1: %Vector2D{x: 2, y: 2}, v2: %Vector2D{x: 6, y: 3}, v3: %Vector2D{x: 3, y: 4}}

    assert Face.contains?(face, %Vector2D{x: 1, y: 2}) == false
  end
end
