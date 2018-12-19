defmodule TransactionsWeb.TransactionController do
  use TransactionsWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias TransactionsWeb.Transaction

  def index(conn, _params) do
    transactions = get_user_transactions()
    render conn, "index.html", transactions: File.read("data/less_transactions.json")
    |> handle_json
    |> get_merchant(transactions)
    |> insert_missing_merchants
    |> return_all_records

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

  def handle_json({:ok, body}) do
    {:ok, body} = {:ok, Poison.Parser.parse!(body)}
    body
  end

  @spec get_merchant(any(), {:ok, any()}) :: {MapSet.t(any()), MapSet.t(any())}
  def get_merchant(descriptions, {:ok, body}) do
    {MapSet.intersection(MapSet.new(descriptions), MapSet.new(body)), MapSet.difference(MapSet.new(descriptions), MapSet.new(body))}
  end

  def insert_missing_merchants({existing_merchants, missing_merchants}) do
   updated_records = for %{"description" => description} <- missing_merchants do
      merchant = merchant_resolver(description)
      cond do
        merchant == nil  ->
        changeset = Transaction.changeset(%Transaction{}, %{description: description, merchant: "UNKNOWN"})
        Transactions.Repo.insert(changeset)
        %{description: description, merchant: "UNKNOWN"}

        true ->
          %{description: description, merchant: merchant}
      end

    end
    existing_merchant_descriptions =  for %{"description" => description} <- existing_merchants do description end
    query = from p in Transaction,
        where: p.description in ^existing_merchant_descriptions,
        select: %{description: p.description, merchant: p.merchant}

        stream = Transactions.Repo.stream(query)
        Transactions.Repo.transaction(fn() ->
          updated_records ++ Enum.to_list(stream)
        end)
  end

  def return_all_records({:ok, records}) do
    IO.inspect records

    records
  end

  def merchant_resolver(incoming_description) do
    [head | _ ] = String.split(incoming_description)
    query = from t in Transaction,
      where: like(t.description, ~s(#{head}%)),
      select: %{description: t.description, merchant: t.merchant}

      result =  Transactions.Repo.all(query);
      IO.inspect result
    cond do
      length(result) > 0 ->

       value = Enum.fetch(Enum.filter(result, fn %{description: description} ->
            length(String.split(incoming_description)) == length(String.split(description))
          end), 0)
          case value do
            {:ok, %{merchant: merchant}} ->
              merchant
          :error ->
          end
         true ->
      end

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
