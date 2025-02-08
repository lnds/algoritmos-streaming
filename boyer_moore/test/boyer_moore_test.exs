defmodule BoyerMooreTest do
  use ExUnit.Case
  doctest BoyerMoore

  test "greets the world" do
    assert BoyerMoore.hello() == :world
  end
end
