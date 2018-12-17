defmodule TransactionsWeb.TransactionApiController do
  use TransactionsWeb, :controller
  alias TransactionsWeb.Transaction
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    transactions = get_user_transactions()
    File.read("data/less_transactions.json")
    |> handle_json
    |> get_merchant(transactions)
    |> insert_missing_merchants

    json conn, get_updated_records() |> process_updated_records
  end

  def get_user_transactions do
    query = from p in Transaction,
     select: %{description: p.description}
      #Transactions.Repo.all(query)
      stream = Transactions.Repo.stream(query)
      Transactions.Repo.transaction(fn() ->
        Enum.to_list(stream)
      end)
  end

  def process_updated_records(records) do
    {:ok, items} = records
    items
  end
  def get_updated_records() do
    query = from p in Transaction,
     select: %{description: p.description, merchant: p.merchant }
      stream = Transactions.Repo.stream(query)
      Transactions.Repo.transaction(fn() ->
        Enum.to_list(stream)
      end)
  end



  def handle_json({:ok, body}) do
    {:ok, body} = {:ok, Poison.Parser.parse!(body)}
    for %{"description" => description} <- body do
     %{description: description}
    end
  end

  def get_merchant(descriptions, {:ok, body}) do
    tr_result = for transaction <- body do
      %{description: transaction.description}
    end
    MapSet.difference(MapSet.new(descriptions), MapSet.new(tr_result))


  end

  def insert_missing_merchants(missing_merchants) do
    for res <- missing_merchants do
      changeset = Transaction.changeset(%Transaction{}, %{description: res.description, merchant: "UNKNOWN"})
      Transactions.Repo.insert(changeset)
     end
  end

end

