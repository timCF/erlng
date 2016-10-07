defmodule ErlngTest do
  use ExUnit.Case
  require Logger
  doctest Erlng
  @roulacc Enum.reduce(0..36, %{}, &(Map.put(&2,&1,0)))

  test "the truth" do
    Erlng.uniform() |> Logger.info
    Erlng.uniform(10) |> Logger.info
    Erlng.shuffle(1..10) |> Logger.info
    Erlng.range(1, 10) |> Logger.info
    Enum.reduce(1..1000000, @roulacc, fn(_, acc) -> Map.update!(acc, Erlng.range(0,36), &(&1+1)) end)
    |> Enum.sort(fn({_,v1},{_,v2}) -> v1 < v2 end)
    |> Enum.each(fn({k,v}) -> Logger.info("#{k} => #{v}") end)
    assert true
  end
end
