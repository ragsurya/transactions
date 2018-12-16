defmodule TransactionsWeb.TransactionController do
  use TransactionsWeb, :controller
  alias TransactionsWeb.Transaction

  def index(conn, _params) do
    transactions = Transactions.Repo.all(Transaction)
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
end
