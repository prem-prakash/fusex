defmodule FusexTest do
  use ExUnit.Case
  doctest Fusex

  defmodule TestFusex do
    use Fusex, name: "test_fuse", max_failures: 3
  end

  describe "run/2" do
    test "success" do
      # TestFusex.install()
      assert {:ok, _} = TestFusex.run(fn -> {:ok, "result"} end)
      assert TestFusex.alive?()
    end

    test "melt" do
      # TestFusex.install()
      TestFusex.run(fn -> {:error, "result"} end)
      TestFusex.run(fn -> {:error, "result"} end)
      TestFusex.run(fn -> {:error, "result"} end)
      TestFusex.run(fn -> {:error, "result"} end)
      refute TestFusex.alive?()
      TestFusex.reset()
    end
  end
end
