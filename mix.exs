defmodule BMFont.Mixfile do
    use Mix.Project

    def project do
        [
            app: :bmfont,
            description: "A BMFont file format parser",
            version: "0.0.1",
            elixir: "~> 1.2",
            build_embedded: Mix.env == :prod,
            start_permanent: Mix.env == :prod,
            deps: deps,
            dialyzer: [plt_add_deps: true]
         ]
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
        [
            { :tonic, git: "https://github.com/ScrimpyCat/Tonic" },
            { :earmark, "~> 0.1", only: :dev },
            { :ex_doc, "~> 0.7", only: :dev }
        ]
    end
end