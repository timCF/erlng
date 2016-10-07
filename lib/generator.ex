defmodule Erlng.Generator do
	use GenServer
	require Logger
	@seed_limit 10

	#
	#	public
	#

	def start_link, do: :gen_server.start_link({ :local, :erlng_seed_server }, __MODULE__, [], [])
	def init([]), do: {:ok, 0}

	def handle_call(cmd, from, 0) do
		_ = seed()
		handle_call(cmd, from, @seed_limit)
	end
	def handle_call(:uniform, _, count), do: {:reply, :rand.uniform, count-1}
	def handle_call({:uniform, max}, _, count), do: {:reply, :rand.uniform(max), count-1}
	def handle_call({:shuffle, list}, _, count) do
		{list, _} = Enum.reduce(list, {[],MapSet.new}, &shuffle_code/2)
		{
			:reply,
			:lists.keysort(1, list) |> Enum.map(fn({_,v}) -> v end),
			count-1
		}
	end

	#
	#	priv
	#

	defp seed() do
		<<a :: 32, b :: 32, c :: 32>> = :crypto.strong_rand_bytes(12)
		:rand.seed(:exs1024, {a,b,c})
		Logger.info("#{__MODULE__} seed #{a}, #{b}, #{c}")
	end

	defp shuffle_code(el, {acc,set}) do
		num = :rand.uniform
		case MapSet.member?(set, num) do
			false -> {[{num,el}|acc], MapSet.put(set,num)}
			true -> shuffle_code(el, {acc,set})
		end
	end
end
