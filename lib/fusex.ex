defmodule Fusex do
  @moduledoc """
  Fusex is a simple wrapper around fuse
   *fuse* is a circuit break erlang lib (https://github.com/jlouis/fuse)
  """

  defmacro __using__(opts) do
    name = Keyword.fetch!(opts, :name)
    # Retry :blown fuses after 120 seconds
    fuse_refresh_miliseconds = Keyword.get(opts, :refresh, 120_000)
    # Allow 1 failure within 10 seconds, then fuse is blown
    max_failures = Keyword.get(opts, :max_failures, 1)
    max_failures_interval = Keyword.get(opts, :max_failures_interval, 10_000)

    options =
      Macro.escape({
        {:standard, max_failures, max_failures_interval},
        {:reset, fuse_refresh_miliseconds}
      })

    :fuse.install(name, {
      {:standard, max_failures, max_failures_interval},
      {:reset, fuse_refresh_miliseconds}
    })

    quote do
      def install, do: :fuse.install(unquote(name), unquote(options))
      def ask(context \\ :sync), do: :fuse.ask(unquote(name), :sync)
      def melt, do: :fuse.melt(unquote(name))
      def disable, do: :fuse.circuit_disable(unquote(name))
      def enable, do: :fuse.circuit_enable(unquote(name))
      def reset, do: :fuse.reset(unquote(name))

      def run(func, context \\ :sync) do
        funs = fn ->
          case func.() do
            {:ok, res} -> {:ok, res}
            {:error, res} -> {:melt, res}
          end
        end

        :fuse.run(unquote(name), funs, context)
      end

      def alive? do
        case :fuse.ask(unquote(name), :sync) do
          :ok -> true
          :blown -> false
          {:error, :not_found} -> raise RuntimeError, "FUSE #{unquote(name)} not installed"
        end
      end
    end
  end
end
