defmodule PlugMaintenance.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_maintenance,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps()]
  end

  defp description do
    """
    An Elixir plug returns a service unavailable response during maintenance.
    """
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
    [{:cowboy, "~> 1.1.2"},
     {:plug, "~> 1.0"},
     {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package do
    [name: :plug_maintenance,
     files: ["lib", "config", "mix.exs", "README*"],
     maintainers: ["Shuhei Hayashibara"],
     licenses: ["MIT"],
     links: %{GitHub: "https://github.com/shufo/plug_maintenance"}]
  end
end
