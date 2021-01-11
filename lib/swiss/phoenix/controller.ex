defmodule Swiss.Phoenix.Controller do
  @moduledoc """
  Helper functions for Phoenix controllers.
  """

  import Plug.Conn, only: [put_status: 2]
  import Phoenix.Controller, only: [redirect: 2, text: 2]

  @doc """
  Redirects back to the referer, or to `fallback` when missing.

  Does not redirect back to an external host.
  """
  @spec redirect_back(Plug.Conn.t(), String.t()) :: Plug.Conn.t()
  def redirect_back(conn, fallback \\ "/") when is_binary(fallback) do
    redirect(conn, to: extract_referer(conn) || fallback)
  end

  @doc "Returns 204 No Content."
  @spec render_no_content(Plug.Conn.t()) :: Plug.Conn.t()
  def render_no_content(conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  defp extract_referer(conn) do
    {_, referer} = List.keyfind(conn.req_headers, "referer", 0, {"referer", ""})
    no_host = String.replace_prefix(referer, conn.host, "")

    # No match on the host, don't know referer path
    if referer == no_host do
      nil
    else
      no_host
    end
  end
end
