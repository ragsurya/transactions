defmodule Transactions.Repo do
  use Ecto.Repo,
    otp_app: :transactions,
    adapter: Ecto.Adapters.Postgres
end
