# README

## About 
This is a Rails API which let you create a Client which has Invoices. It returns JSON and has no views. The clients can have a name and many invoices, and the invoices have an amount, file and status which can be updated. There is a route to get the current fees owed by a client.

This project was built with the following versions:
* Rails 6.0.6.1
* Ruby 2.7.0
* 3.24.0

## How to run
* Clone the repo to your local machine
* Save the provided Google Cloud credentials file in `/config/secrets`
* `cd` into `client_invoices`
* run `rails s` to start the server
* The server will run on `localhost:3000`

## How to use
`GET /clients` gets all created clients  

`POST /clients` will create a new client. Suppy the `name` as `form-data`  

`GET /clients/{client_name}` gets a specific client  

`POST /clients/{client_name}/invoices` creates a new invoice. Supply the `invoice_amount` and a file as `form-data`. The file is saved to a Google Cloud bucket.  

`GET /clients/{client_name}/invoices` gets all the invoices for a client  

`GET /clients/{client_name}/invoices/{invoice_number}` gets a specific invoice by `invoice_number` (here, a `uuid`), which is returned on create or can be looked up with the previous `GET`  

`PUT /clients/{client_name}/invoices/{invoice_number}` lets you change the `status` and/or `invoice_amount` (unless in `rejected` or `closed`)  

`GET /clients/{client_name}/summary` returns the dollar amount of fees owed by that client. It's based on the number of days the invoices have been in `purchased` status.

`DELETE /clients/{client_name}` deletes a client and all its invoices. The files in cloud storage are removed.

`DELETE /clients/{client_name}/invoices/{invoice_number}` deletes an invoice from a client by `invoice_number`  
Any other route returns a `404` or `401`.

## Additional info
Because of time constraints and strictly limiting the scope to the design doc, there are many things that could be improved on. A major one is adding authentication to be able to access resources. Right now, anybody can create a Client and Invoices; you might want two different credentials for those functions, depending on the exact use case.  

The tests are minimal but cover the status transitions and some other important functions. An improvement would be to add some end-to-end tests that would include things like the file upload.

Something else that wasn't included is checks on the file size and type. Right now those aren't limited and that would need to be built for anything more than a demonstration.

For the Postman `POST` requests a file will need to be supplied.

The commented lines which Rails generates were mostly left in for now. 
