defmodule TransactionsWeb.TransactionApiControllerTest do
  use ExUnit.Case, async: true
  alias TransactionsWeb.Transaction
  doctest TransactionsWeb.TransactionApiController
  import Ecto.Query
  use Plug.Test

  @opts TransactionsWeb.Router.init([])

  setup do
    Mix.Tasks.Ecto.Migrate.run(["--all", "Transactions.Repo"])

    on_exit fn ->
      Mix.Tasks.Ecto.Rollback.run(["--all", "Transactions.Repo"])
    end
  end
  # ...
  # Our new test
  test "create transaction" do

    trans = %Transaction{
      description: "netflix monthly subscription",
      merchant: "NETFLIX",
      value: "10"
    }
    Transactions.Repo.insert(trans)
    query = from t in Transaction,
            select: t
    assert length(Transactions.Repo.all(query)) == 1
  end

  test "/api/transactions" do
    conn = conn(:get, "/api/transactions")

    conn = TransactionsWeb.Router.call(conn, @opts)

    assert conn.state == :sent

    assert String.contains?(conn.resp_body, "[{\"description\":\"Uber Eats\",\"merchant\":\"UNKNOWN\"},{\"description\":\"amazon eu sarl amazon.co.uk/\",\"merchant\":\"UNKNOWN\"},{\"description\":\"amazon prime amzn.co.uk/pm\",\"merchant\":\"UNKNOWN\"},{\"description\":\"direct debit payment to dvla-i2den\",\"merchant\":\"UNKNOWN\"},{\"description\":\"direct debit sky digital 83741234567852 ddr\",\"merchant\":\"UNKNOWN\"},{\"description\":\"dvla vehicle tax\",\"merchant\":\"UNKNOWN\"},{\"description\":\"dvla vehicle tax - vis\",\"merchant\":\"UNKNOWN\"},{\"description\":\"dvla-ln99abc\",\"merchant\":\"UNKNOWN\"},{\"description\":\"google *google g.co/helppay#\",\"merchant\":\"UNKNOWN\"},{\"description\":\"netflix.com 866-716-0414\",\"merchant\":\"UNKNOWN\"},{\"description\":\"netflix.com amsterdam\",\"merchant\":\"UNKNOWN\"},{\"description\":\"sainsbury's sprmrkts lt london\",\"merchant\":\"UNKNOWN\"},{\"description\":\"sky digital 13524686324522\",\"merchant\":\"UNKNOWN\"},{\"description\":\"sky subscription - sky subscription 38195672157 gb\",\"merchant\":\"UNKNOWN\"},{\"description\":\"uber eats 6p7n7 help.uber.com\",\"merchant\":\"UNKNOWN\"},{\"description\":\"uber eats j5jgo help.uber.com\",\"merchant\":\"UNKNOWN\"},{\"description\":\"uber help.uber.com\",\"merchant\":\"UNKNOWN\"}]")

  end
end
