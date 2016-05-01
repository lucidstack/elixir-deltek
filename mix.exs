defmodule Deltek.Mixfile do
  use Mix.Project

  def project do
    [app: :deltek,
     version: "0.0.1",
     elixir: "~> 1.2",
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

  defp deps do
    [{:sweet_xml, "~> 0.6.1"},
     {:html_entities, "~> 0.3.0"}]
  end
end
