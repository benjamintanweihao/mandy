defmodule Mandy.Mixfile do
  use Mix.Project

  def project do
    [app: :mandy,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:complex, git: "https://github.com/fishcakez/complex.git"}
    ]
  end
end
