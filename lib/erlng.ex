defmodule Erlng do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Erlng.Generator, []),
    # Starts a worker by calling: Erlng.Worker.start_link(arg1, arg2, arg3)
    # worker(Erlng.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Erlng.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def uniform(), do: GenServer.call(:erlng_seed_server, :uniform)
  def uniform(max) when (is_integer(max) and (max > 0)), do: GenServer.call(:erlng_seed_server, {:uniform, max})
  def shuffle(lst), do: GenServer.call(:erlng_seed_server, {:shuffle, lst})

  def range(int, int) when is_integer(int), do: int
  def range(start, stop) when is_integer(stop) and is_integer(start) and (stop > start) do
    offset = (start - 1)
    uniform(stop - offset) + offset
  end

end
