defmodule TransactionsWeb.Transaction do
  use TransactionsWeb, :model

  schema "transactions" do
    field :description, :string
    field :merchant, :string
    field :value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :merchant, :value])
    |> validate_required([:description])
  end

end
