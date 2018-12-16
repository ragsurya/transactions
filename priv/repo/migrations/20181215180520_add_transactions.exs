defmodule Transactions.Repo.Migrations.AddTransactions do
  use Ecto.Migration

    def change do
      create table(:transactions) do
        add :description, :string
        add :merchant, :string
        add :value, :string
    end

  end
end
