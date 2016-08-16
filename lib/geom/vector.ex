defmodule Geom.Vector do
  @moduledoc """
  """
  alias Geom.Vector, as: Vector

  @type t :: tuple

  @callback new(tuple) :: Vector.t

  @callback add(Vector.t, Vector.t) :: Vector.t
  @callback add(Vector.t, float)    :: Vector.t

  @callback sub(Vector.t, Vector.t) :: Vector.t
  @callback sub(Vector.t, float)    :: Vector.t

  @callback mul(Vector.t, float)    :: Vector.t

  @callback div(Vector.t, float)    :: Vector.t

  @callback dot(Vector.t, Vector.t) :: float

  @callback norm(Vector.t) :: float

  @callback unit(Vector.t) :: Vector.t
end
