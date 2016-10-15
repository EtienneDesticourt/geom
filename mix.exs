defmodule Geom.Mixfile do
  use Mix.Project

  def project do
    [app: :geom,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:poison, "~> 2.0 or ~>3.0"},
     {:ex_doc, ">= 0.0.0", only: :docs}]
  end

  defp description do
    """
    The geom project gives access to a variety of geometric shapes and the algorithms necessary for their manipulation.
    """
  end

  defp package do
    [maintainers: ["Etienne Desticourt"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/EtienneDesticourt/geom"}]
  end
end
