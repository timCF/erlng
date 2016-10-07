defmodule ErlngTest do
  use ExUnit.Case
  doctest Erlng

  test "the truth" do
    Erlng.uniform() |> IO.inspect
    Erlng.uniform(10) |> IO.inspect
    Erlng.shuffle(1..10) |> IO.inspect
    Erlng.range(1, 10) |> IO.inspect
    assert true
  end
end
