defmodule PlugMaintenance.View.Maintenance do
  import Plug.Conn

  @resp_body "{\"errors\":[{\"title\":\"Service Unavailable\",\"detail\":\"Service is now under maintenance now. Please check it after a while.\"}]}"

  def render(conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:service_unavailable, @resp_body)
    |> halt
  end
end
