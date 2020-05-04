defmodule Taskmaster.Process do
  alias Taskmaster.Config, as: Config

  defp find_executable(cmd) do
    List.first(cmd)
    |> System.find_executable()
  end

  @doc """
  Full documentation on
  http://erlang.org/doc/man/erlang.html#open_port-2
  """
  defp build_opts(
    %Config{cmd: cmd, workingdir: workingdir, env: env} = config
  ) do
    args = List.pop_at(cmd, 0) |> elem(1)
    [:binary, args: args, cd: workingdir, env: [{'COOL_ENV', 'cool'}]]
  end

  def start(%Config{cmd: cmd} = config) do
    exe = find_executable(cmd)
    |> IO.inspect()
    opts = build_opts(config)
    |> IO.inspect()
    Port.open({:spawn_executable, exe}, opts)
  end
end
