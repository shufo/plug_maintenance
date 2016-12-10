[![Build Status](https://travis-ci.org/shufo/plug_maintenance.svg?branch=master)](https://travis-ci.org/shufo/plug_maintenance)
[![hex.pm version](https://img.shields.io/hexpm/v/plug_maintenance.svg)](https://hex.pm/packages/plug_maintenance)
[![hex.pm](https://img.shields.io/hexpm/l/plug_maintenance.svg)](https://github.com/shufo/plug_maintenance/blob/master/LICENSE)

# PlugMaintenance

An Elixir plug that returns a service unavailable response during maintenance.

## Installation

1. Add `plug_maintenance` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:plug_maintenance, "~> 0.1.0"}]
  end
  ```

2. Ensure `plug_maintenance` is started before your application:

  ```elixir
  def application do
    [applications: [:plug_maintenance]]
  end
  ```

## Usage

- Add the Maintenance plug to the router.

```elixir
pipeline :api do
  plug :accepts, ["json"]
  plug Maintenance
end
```

```elixir
scope "/" do
  pipe_through :api
  get "/v1/foo/bar, FooController, :bar
end
```

- By default, it checks whether the environment variable `MAINTENANCE` is `true` or whether there is a file named `maintenance` and returns a  service unavailable message with json, but if you want to customize it, please give your module for checking the maintenance status as an option.

```elixir
plug Maintenance, monitor: {MyApp.MaintenanceMonitor, :check, []}, renderer: {MyApp.MaintenanceRenderer, :render, []}
```

Custom monitor can be written like this.

```elixir
defmodule MyApp.MaintenanceMonitor do
  def check(conn, _opts) do
    # Returning true will result in maintenance mode
    # Write the logic for your environment
    Redix.command(~w(GET maintenance)) == {:ok, "true"}
  end
end
```

For Phoenix, renderer can be written like this.

```elixir
defmodule MyApp.MaintenanceRenderer do
  use MyApp.Web, :view
  import Plug.Conn

  def render(conn, _opts) do
    conn
    |> put_status(:service_unavailable)
    |> put_view(__MODULE__)
    |> render("index.html", layout: {MyApp.LayoutView, "maintenance.html"})
    |> halt
  end
end
```


- If you want to limit the range to controller or action, add it to controller as follows.

```elixir
plug Maintenance
```

```elixir
plug Maintenance when action in [:index, :show:, :update]
```

```elixir
plug Maintenance, [monitor: {MyMonitor, :check, []}, renderer: {MyRenderer, :render, []}] when action in [:index, :show:, :update]
```
