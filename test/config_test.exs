defmodule ConfigTest do
  use ExUnit.Case
  alias Taskmaster.Config, as: Config

  test "cmd is mandatory" do
    assert Config.new(%{}) == :error
  end

  test "cmd is not empty" do
    assert Config.new(%{cmd: ""}) == :error
  end

  test "cmd part should splitted" do
    config = Config.new(%{cmd: "ls /tmp"})
    assert config.cmd == ["ls", "/tmp"]
  end
end
