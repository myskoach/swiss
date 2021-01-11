defmodule Swiss.Phoenix.ControllerTest do
  use ExUnit.Case, async: true

  import Plug.Conn, only: [get_resp_header: 2, put_req_header: 3]

  alias Swiss.Phoenix.Controller

  describe "redirect_back/3" do
    setup do
      conn = Plug.Test.conn(:get, "/some/path")
      {:ok, conn: conn}
    end

    test "redirects back to the referer", %{conn: conn} do
      new_conn =
        conn
        |> Map.put(:host, "www.google.com")
        |> put_req_header("referer", "www.google.com/maple/party")
        |> Controller.redirect_back()

      assert new_conn.status == 302
      assert ["/maple/party"] = get_resp_header(new_conn, "location")
      assert new_conn.state == :sent
      assert new_conn.resp_body =~ ~r/redirected/
    end

    test "redirects to fallback if the referer's host doesn't match the given host", %{conn: conn} do
      new_conn =
        conn
        |> Map.put(:host, "www.bananas.com")
        |> put_req_header("referer", "www.google.com/maple/party")
        |> Controller.redirect_back()

      assert new_conn.status == 302
      assert ["/"] = get_resp_header(new_conn, "location")
    end

    test "redirects to fallback if there is no referrer", %{conn: conn} do
      new_conn =
        conn
        |> Map.put(:host, "www.google.com")
        |> Controller.redirect_back()

      assert new_conn.status == 302
      assert ["/"] = get_resp_header(new_conn, "location")
    end

    test "fallback can be customized", %{conn: conn} do
      new_conn =
        conn
        |> Map.put(:host, "www.google.com")
        |> Controller.redirect_back("/somewhere-else")

      assert new_conn.status == 302
      assert ["/somewhere-else"] = get_resp_header(new_conn, "location")
    end
  end

  describe "render_no_content/1" do
    setup do
      conn = Plug.Test.conn(:get, "/some/path")
      {:ok, conn: conn}
    end

    test "returns 204 no content", %{conn: conn} do
      new_conn = Controller.render_no_content(conn)

      assert new_conn.status == 204
      assert new_conn.resp_body == ""
    end
  end
end
