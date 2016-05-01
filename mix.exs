defmodule Deltek.Mixfile do
  use Mix.Project
  @version "0.0.1"

  def project do
    [app: :deltek,
     version: @version,
     elixir: "~> 1.2",
     description: "An Elixir wrapper for the SOAP Deltek API",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [
      applications: [:logger, :sweet_xml],
      mod: {Deltek, []}
    ]
  end

  defp package do
    [maintainers: ["Andrea Rossi"],
     files: ["lib", "mix.exs", "README.md", "LICENSE"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/lucidstack/elixir-deltek"}]
  end

  defp deps do
    [{:sweet_xml, "~> 0.6.1"},
     {:html_entities, "~> 0.3.0"}]
  end
end
