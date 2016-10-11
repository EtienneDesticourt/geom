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

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:poison, "~> 3.0"}]
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
