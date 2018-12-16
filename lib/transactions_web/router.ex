defmodule TransactionsWeb.Router do
  use TransactionsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TransactionsWeb do
    pipe_through :browser

    get "/", TransactionController, :index
    get "/transactions", TransactionController, :create
    post "/transactions/new", TransactionController, :new

    resources "/", TransactionController

  end

  # Other scopes may use custom stacks.
  # scope "/api", TransactionsWeb do
  #   pipe_through :api
  # end
end
