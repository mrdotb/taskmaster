defmodule Taskmaster.Config do
  @enforce_keys [:cmd]

  defstruct [
    :name,
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
    env: [],
    workingdir: "/tmp",
    umask: "022"
  }

  @doc """
  Transform env from a map to a list of tuples in erlang string.
  """
  defp parse(:env , %{env: env} = args) do
    mapped_env = Enum.map(env, fn {key, value} ->
      k   = :erlang.atom_to_list(key)
      val = :binary.bin_to_list(value)
      {k, val}
    end)
    Map.put(args, :env, mapped_env)
  end

  defp parse(:cmd, %{cmd: ""}), do: :error

  @doc """
  Split the cmd line string into List.
  """
  defp parse(:cmd, %{cmd: cmd} = args) do
    cmd_list = String.split(cmd, " ")
    Map.put(args, :cmd, cmd_list)
  end

  defp parse(_key, args), do: args

  @doc """
  Apply all parse function to map.
  """
  defp parse(args) do
    keys = Map.keys(args)

    Enum.reduce_while(keys, args, fn key, acc ->
      case parse(key, acc) do
        :error -> {:halt, :error}
        parsed -> {:cont, parsed}
      end
    end)
  end

  @doc """
  Generate a random 14 chars name for our future process.
  """
  defp add_name(args) do
    name = :crypto.strong_rand_bytes(10)
    |> Base.url_encode64(padding: false)

    Map.put(args, :name, name)
  end

  def new(args) when map_size(args) == 0, do: :error

  @doc """
  Create a %Config{} struct
  """
  def new(args) do
    case parse(args) do
      :error ->
        :error

      args ->
        config =
          Map.merge(@default_values, args)
          |> add_name
        struct(Taskmaster.Config, config)
    end
  end
end
