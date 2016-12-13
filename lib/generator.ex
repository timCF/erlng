defmodule Erlng.Generator do
	use GenServer
	require Logger
	@seed_limit 10
	@algorithms [:exsplus, :exs64, :exs1024]
	@algorithms_len length(@algorithms)

	#
	#	public
	#

	def start_link, do: :gen_server.start_link({ :local, :erlng_seed_server }, __MODULE__, [], [])
	def init([]), do: {:ok, 0}

	def handle_call(cmd, from, 0) do
		_ = seed()
		handle_call(cmd, from, (:rand.uniform(@seed_limit) * 2))
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
		_ = Enum.at(@algorithms, (:rand.uniform(@algorithms_len) - 1)) |> :rand.seed({a,b,c})
	end

	defp shuffle_code(el, {acc,set}) do
		num = :rand.uniform
		case MapSet.member?(set, num) do
			false -> {[{num,el}|acc], MapSet.put(set,num)}
			true -> shuffle_code(el, {acc,set})
		end
	end
end
