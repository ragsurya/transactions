# Transactions

A small app built on Elixir & Phoenix framework that displays the transactions of a user.

### User Story:
As a user, when looking at my transactions, I would like to know which merchant it belongs to so I can understand my spending.
### Acceptance Criteria:
- A description is matched to a merchant if merchant exists in database.
- If merchant does not exist, a new merchant is created with a name of "unknown" and the transaction assigned to the new merchant.

## App overview

There are 2 versions of this app

1. The MVC app which serves the UI to see the list of transactions
    - This also has an admin screen to create a transaction and immediately see it added on the list of transactions (path: <<hostname>>/transactions)
2. The API part - built as a microservice which serves the transactions in json format (path: <<hostname>>/api/transactions)

## Architecture

Below is the architectural respresentation of the application. The blue portion is the API part of the application while the red is the MVC part of the application.

> A pre configured json data with transaction description is read form the app and all the descriptions are compared to the rows in DB to get the merchant name. if no matching record exists in DB for the corresponding description, a new record is created with merchant name `UNKNOWN`. 

![image](https://user-images.githubusercontent.com/32263069/50113614-5f324700-023a-11e9-9e93-0a90f2e8ed69.png)

## Installation

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Database setup

To get set up with a local postgres db (on a mac):

  * `brew services start postgresql`
  * `initdb /usr/local/var/postgres`
  * `mix ecto.create`
  * `mix ecto.gen.migration add_transactions` ( this step might not be needed if you clone the repo since there will already be a migration file. if so, skip this step)
  * `mix ecto.migrate`

Once DB is setup, and migration command is run, a database will be created. If you encounter errors setting up db, it is worth checking if the `username` in `config\dev.exs` file is reflecting your mac profile name.  


Few URLs to help with ( can be found in router.ex)

1. See the transactions on the UI - http://localhost:4000/
2. Create a new transaction from the UI - http://localhost:4000/transaction
3. API version of the app - http://localhost:4000/api/transaction

## Scalability

This app is built on Elixir which runs on the BEAM VM. Since it is naturally designed for high concurrency, fault tolerance and low latency I have taken advantage of these great features to build this app. Some key things to call out are the usage of `Repo.stream`. The same can be done with Ecto query itself but the advantage of using stream is it uses lazy loading; avoids fetching everything at once and instead fetches data in iterative cycles, performing operations on each record along the way. 

Here is a small load test that was done on the api using a tool called `wrk`. 
**Environment**: Macbook Pro development machine (multiple other process running)
Cores: 8
RAM: 16GB

**Configuration**
threads: 24
open connections: 100
total time: 100 seconds

![image](https://user-images.githubusercontent.com/32263069/50113493-f9de5600-0239-11e9-8e27-40aa61d96cb6.png)

## Application screenshots

![image](https://user-images.githubusercontent.com/32263069/50113893-1e86fd80-023b-11e9-8cbb-831f3a5f8722.png)
![image](https://user-images.githubusercontent.com/32263069/50113924-38284500-023b-11e9-8a09-fe536ed8b7d8.png)
![image](https://user-images.githubusercontent.com/32263069/50113946-41b1ad00-023b-11e9-88d2-49587643eeb0.png)

