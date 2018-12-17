defmodule TransactionsWeb.TransactionController do
  use TransactionsWeb, :controller
  alias TransactionsWeb.Transaction

  def index(conn, _params) do
    transactions = Transactions.Repo.all(Transaction)
    content = File.read("data/less_transactions.json")
    |> handle_json
    |> get_merchant(transactions)
    |> insert_missing_merchants
    render conn, "index.html", transactions: transactions
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
    for %{"description" => description} <- body do
     %{description: description}
    end
  end

  def get_merchant(descriptions, transactions) do
    tr_result = for transaction <- transactions do
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
