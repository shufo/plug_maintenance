defmodule PlugMaintenanceTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest PlugMaintenance

  @default_opts Maintenance.init([])

  defmodule PlugMaintenance.Test.Monitor do
    def check(conn, _opts) do
      fetch_query_params(conn).params["force_maintenance"] == "true"
    end
  end

  defmodule PlugMaintenance.Test.View.Maintenance do
    import Plug.Conn

    require EEx
    EEx.function_from_file :defp, :template_html, "test/templates/maintenance.html.eex", []

    def render(conn, _opts) do
      conn
      |> send_resp(:service_unavailable, template_html)
      |> halt
    end
  end


  @expected_resp "{\"errors\":[{\"title\":\"Service Unavailable\",\"detail\":\"Service is now under maintenance now. Please check it after a while.\"}]}"
  test "Service unavailable with default checker and monitor" do
    # Set environment value
    System.put_env("MAINTENANCE", "true")
    # Create a test connection
    conn = conn(:get, "/")

    conn = Maintenance.call(conn, @default_opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body == @expected_resp
    # cleanup
    System.delete_env("MAINTENANCE")

    # Maintenance with static file
    File.touch("maintenance")
    # Create a test connection
    conn = conn(:get, "/")

    conn = Maintenance.call(conn, @default_opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body == @expected_resp
    # cleanup
    File.rm("maintenance")

  end

  @expected_resp "Sorry for the inconvenience"
  test "Service unavailable with custom checker and monitor" do
    # Create a test connection
    conn = conn(:get, "/?force_maintenance=true")

    opts = Maintenance.init([monitor: {PlugMaintenance.Test.Monitor, :check, []}, renderer: {PlugMaintenance.Test.View.Maintenance, :render, []}])
    conn = Maintenance.call(conn, opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 503
    assert conn.resp_body =~ @expected_resp

    # Create a test connection
    conn = conn(:get, "/?force_maintenance=false")

    opts = Maintenance.init([monitor: {PlugMaintenance.Test.Monitor, :check, []}, renderer: {PlugMaintenance.Test.View.Maintenance, :render, []}])
    conn = Maintenance.call(conn, opts)

    # Assert the response and status
    assert conn.state == :unset
    assert conn.status == nil
    assert conn.resp_body == nil
  end
end
