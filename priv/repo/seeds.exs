# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Transactions.Repo.insert!(%Transactions.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TransactionsWeb.Transaction


Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "netflix.com amsterdam", merchant: "NETFLIX"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "amazon eu sarl amazon.co.uk/", merchant: "AMAZON"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "netflix.com 866-716-0414", merchant: "NETFLIX"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "uber eats 6p7n7 help.uber.com", merchant: "UBER EATS"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "google *google g.co/helppay#", merchant: "GOOGLE"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "amazon prime amzn.co.uk/pm", merchant: "AMAZON PRIME"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "dvla vehicle tax", merchant: "DVLA"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "dvla vehicle tax - vis", merchant: "DVLA"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "direct debit payment to dvla-i2den", merchant: "DVLA"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "dvla-ln99abc", merchant: "DVLA"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "sky digital 13524686324522", merchant: "SKY DIGITAL"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "direct debit sky digital 83741234567852 ddr", merchant: "SKY DIGITAL"}))
Transactions.Repo.insert(Transaction.changeset(%Transaction{}, %{description: "sky subscription - sky subscription 38195672157 gb", merchant: "SKY"}))
