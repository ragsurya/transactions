defmodule TransactionsWeb.TransactionController do
  use TransactionsWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias TransactionsWeb.Transaction

  def index(conn, _params) do
    transactions = get_user_transactions()
    File.read("data/less_transactions.json")
    |> handle_json
    |> get_merchant(transactions)
    |> insert_missing_merchants

    render conn, "index.html", transactions: get_updated_records() |> process_updated_records
  end

  def get_user_transactions do
    query = from p in Transaction,
     select: %{"description" => p.description}
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
     select: %{description: p.description, merchant: p.merchant, value: p.value }
      stream = Transactions.Repo.stream(query)
      Transactions.Repo.transaction(fn() ->
        Enum.to_list(stream)
      end)
  end


  def create(conn, _params) do
    changeset = Transaction.changeset(%Transaction{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def new(conn, %{"transaction" => transaction}) do
    changeset = Transaction.changeset(%Transaction{}, transaction)

    case Transactions.Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Transaction created")
        |> redirect(to: Routes.transaction_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def delete(conn, %{"id" => transaction_id}) do
    Transactions.Repo.get!(Transaction, transaction_id)
    |> Transactions.Repo.delete!

    conn
    |> put_flash(:info, "Topic deleted")
    |> redirect(to: Routes.transaction_path(conn, :index))
  end

  def handle_json({:ok, body}) do
    {:ok, body} = {:ok, Poison.Parser.parse!(body)}
    body
  end

  def get_merchant(descriptions, {:ok, body}) do
   MapSet.difference(MapSet.new(descriptions), MapSet.new(body))
  end

  def insert_missing_merchants(missing_merchants) do
    changeset = for %{"description" => description} <- missing_merchants do
      %{description: description, merchant: "UNKNOWN", value: "10"}
    end
    Transactions.Repo.insert_all(Transaction, changeset)
  end


end
