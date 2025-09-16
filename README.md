# SimpleBankingSystem-SpringBoot

## API Endpoints(BASE-API: /api/v1)

* GET /accounts - Gets all accounts
* GET /accounts/{name} - Gets one account by name
* POST /accounts - Creates one account
* DELETE /accounts/{name} - Deletes an account by name
* POST /accounts/{name}/deposit - Puts money into account
* POST /accounts/{name}/withdraw - Gets money from account
* POST /accounts/{name}/transfer - Sends money to another existing account

## Entities

* Account: -id, -name, -balance

## Setup

docker run --name simpleBankingBankingSystem -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_DB=simpleBankingSystem -p 5432:5432 -d postgres
