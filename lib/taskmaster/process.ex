defmodule Taskmaster.Process do
  alias Taskmaster.Config, as: Config

  @doc """
  Empty the env
  """
  def clean_env() do
    :os.getenv()
    |> Enum.map(&(:string.split(&1, '=')))
    |> Enum.map(&List.first(&1))
    |> Enum.each(&(:os.unsetenv(&1)))
  end

  @doc """
  Will require a nif
  https://andrealeopardi.com/posts/using-c-from-elixir-with-nifs/
  https://github.com/msantos/perc
  """
  def set_umask(umask) do
  end
  def kill(signal) do
  end

  def find_executable(cmd) do
    cmd
    |> List.first()
    |> System.find_executable()
  end

  @doc """
  Build opts for open_port function
  https://erldocs.com/current/erts/erlang.html?i=0&search=open%20port#open_port/2
  """
  def build_opts(
    %Config{cmd: cmd, workingdir: workingdir, env: env} = config
  ) do
    args = List.pop_at(cmd, 0) |> elem(1)
    [:binary, args: args, cd: workingdir, env: env]
  end

  def start(%Config{cmd: cmd} = config) do
    exe = find_executable(cmd)
    |> IO.inspect()
    opts = build_opts(config)
    |> IO.inspect()
    Port.open({:spawn_executable, exe}, opts)
  end
end
