defmodule Swiss.MixProject do
  use Mix.Project

  @source_url "https://github.com/myskoach/swiss"
  @version "3.10.0"

  def project do
    [
      app: :swiss,
      elixir: "~> 1.10",
      version: @version,
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      description: "Swiss is a bundle of extensions to the standard lib.",
      licenses: ["Apache-2.0"],
      maintainers: ["João Ferreira"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp deps do
    [
      {:ecto, ">= 3.0.0", optional: true},
      {:plug, ">= 1.11.0", optional: true},
      {:phoenix, ">= 1.4.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      homepage_url: @source_url,
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
