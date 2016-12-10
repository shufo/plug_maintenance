defmodule PlugMaintenance.Monitor do

  @env "MAINTENANCE"
  @file "maintenance"

  def check(_conn, _opts) do
    cond do
      has_environment_value?   -> true
      maintenance_file_exists? -> true
      true -> false
    end
  end

  defp has_environment_value? do
    System.get_env(@env) == "true"
  end

  defp maintenance_file_exists? do
    File.exists?("maintenance")
  end
end
