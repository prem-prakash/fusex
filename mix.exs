defmodule Fusex.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/prem-prakash/fusex"

  def project do
    [
      app: :fusex,
      name: "Fusex",
      version: @version,
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      elixir: "~> 1.10",
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      description: description(),
      docs: [source_ref: "v#{@version}", main: "readme", extras: ["README.md"]],
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger, :fuse]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:fuse, "~> 2.5"}
    ]
  end

  defp description do
    """
    A simple wrapper around erlang fuse library
    """
  end

  defp package do
    [
      maintainers: ["Prem Prakash"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
