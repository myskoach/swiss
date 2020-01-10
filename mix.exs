defmodule Swiss.MixProject do
  use Mix.Project

  def project do
    [
      app: :swiss,
      description: "Swiss is a bundle of extensions to the standard lib.",
      version: "1.4.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      homepage_url: "https://github.com/myskoach/swiss",
      source_url: "https://github.com/myskoach/swiss"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    %{
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/myskoach/swiss"
      }
    }
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev, runtime: false}]
  end
end
