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

  test "env part should be mapped to erlang str" do
    config = Config.new(%{cmd: "env", env: %{marco: "polo"}})
    assert config.env == [{'marco', 'polo'}]
  end

  test "config should get a 14 chars name" do
    config = Config.new(%{cmd: "ls /tmp"})
    assert String.length(config.name) == 14
  end
end
