import Config

config :phoenix, :json_library, Jason
config :logger, :level, :debug
config :logger, :backends, []

config :esbuild, :version, "0.17.18"

if Mix.env() == :dev do
  esbuild = fn args ->
    [
      args: ~w(./js/live_monaco_editor --bundle --loader:.ttf=file --sourcemap) ++ args,
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
    ]
  end

  config :esbuild,
    module: esbuild.(~w(--format=esm --outfile=../priv/static/live_monaco_editor.esm.js)),
    main: esbuild.(~w(--format=cjs --outfile=../priv/static/live_monaco_editor.cjs.js)),
    cdn:
      esbuild.(
        ~w(--format=iife --target=es2016 --global-name=LiveMonacoEditor --outfile=../priv/static/live_monaco_editor.js)
      ),
    cdn_min:
      esbuild.(
        ~w(--format=iife --target=es2016 --global-name=LiveMonacoEditor --minify --outfile=../priv/static/live_monaco_editor.min.js)
      )
end