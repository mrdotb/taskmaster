defmodule Taskmaster.Process do
  alias Taskmaster.Config, as: Config

  def find_executable(prog) do
    System.find_executable(prog)
  end

  def start(%Config{} = config) do
    Port.open({:spawn_executable, find_executable("tail")}, [:binary, args: ["-f", "/dev/null"]])
  end
end
