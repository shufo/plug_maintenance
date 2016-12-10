defmodule Maintenance do
  @default_monitor  {PlugMaintenance.Monitor, :check, []}
  @default_renderer {PlugMaintenance.View.Maintenance, :render, []}

  def init(opts), do: opts

  def call(conn, opts) do
    {module, fun, args} = opts[:monitor] || @default_monitor

    cond do
      apply(module, fun, [conn, args]) -> service_unavailable(conn, opts)
      true -> conn
    end
  end

  defp service_unavailable(conn, opts) do
    {module, fun, args} = opts[:renderer] || @default_renderer
    apply(module, fun, [conn, args])
  end
end
