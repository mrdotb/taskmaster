defmodule ProcessTest do
  use ExUnit.Case
  alias Taskmaster.Process , as: Process

  test "clean env should clean" do
    Process.clean_env()
    env = :os.getenv()
    assert env = []
  end
end
