defmodule Taskmaster.Config do
  @enforce_keys [:cmd]

  defstruct [
    :cmd,
    :numprocs,
    :autostart,
    :autorestart,
    :exitcodes,
    :starttime,
    :startretries,
    :stopsignal,
    :stoptime,
    :stdout,
    :stderr,
    :env,
    :workingdir,
    :umask
  ]

  @default_values %{
    numprocs: 1,
    autostart: true,
    autorestart: "unexpected",
    exitcodes: ["SIGKILL"],
    starttime: 30 * 1000,
    startretries: 1,
    stopsignal: "SIGINT",
    stoptime: 15 * 1000,
    stdout: "/dev/null",
    stderr: "/dev/null",
    env: %{},
    workingdir: "/tmp",
    umask: "022"
  }

  defp parse(:cmd, %{cmd: ""}), do: :error
  defp parse(:cmd, %{cmd: cmd} = args) do
    cmd_list = String.split(cmd, " ")
    Map.put(args, :cmd, cmd_list)
  end
  defp parse(_key, args), do: args

  defp parse(args) do
    keys = Map.keys(args)
    Enum.reduce_while(keys, args, fn key, acc ->
      case parse(key, acc) do
        :error -> {:halt, :error}
        parsed -> {:cont, parsed}
      end
    end)
  end

  def new(args) when map_size(args) == 0, do: :error
  def new(args) do
    case parse(args) do
      :error -> :error
      args ->
        config = Map.merge(args, @default_values)
        struct(Taskmaster.Config, config)
    end
  end
end
