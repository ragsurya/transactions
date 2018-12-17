defmodule TransactionsWeb.TransactionControllerTest do
  use ExUnit.Case
  doctest TransactionsWeb.TransactionController

  test "GET /", %{conn: conn} do
    conn = TransactionsWeb.TransactionController.index(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
