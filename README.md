# Rebase Labs - Medical Exams

## Introduction

Desenvolvido para o Rebase Labs utilizando Ruby com Sinatra, Sidekiq e Redis para o back-end, utilizando Node (Vite) como servidor para o front-end e PostgreSQL para banco de dados.

<p align="center">
  <a href="https://www.ruby-lang.org/">
    <img src="https://img.shields.io/badge/ruby-3.3.4-%23CC0000.svg?style=for-the-badge&logo=ruby&logoColor=white"/>
  </a>
  <a href="https://vitejs.dev/">
    <img src="https://img.shields.io/badge/Vite-10.7-646CFF?style=for-the-badge&logo=Vite&logoColor=white"/>
  </a>
  <a href="https://www.postgresql.org/">
    <img src="https://img.shields.io/badge/PostgreSQL-16.3-316192?style=for-the-badge&logo=postgresql&logoColor=white">
  </a>
</p>

## About the project
This project was developed using the following tools:
- <a href="https://www.ruby-lang.org/pt/">Ruby</a>
- <a href="https://tailwindcss.com/">TailwindCSS</a>
- <a href="https://vitejs.dev/">Vite</a>
- <a href="https://www.postgresql.org/">PostgreSQL</a>
- <a href="https://www.docker.com/">Docker</a>
- <a href="https://sidekiq.org/">Sidekiq</a>

The following Ruby gems are being used:

- <a href="https://github.com/sidekiq/sidekiq">Sidekiq</a>
- <a href="https://github.com/rubocop/rubocop">Rubocop</a>
- <a href="https://github.com/rspec/rspec-core">RSpec</a>
- <a href="https://github.com/sinatra/sinatra">Sinatra</a>
- <a href="https://github.com/ged/ruby-pg">ruby-pg (Postgres)</a>
- <a href="https://github.com/ruby/csv">CSV</a>
- <a href="https://github.com/puma/puma">Puma</a>
- <a href="https://github.com/rack/rack">Rack</a>

## Requirements

This project requires **Docker** to run. You can check out how to <a href="">install Docker here</a>.

## Installation

1. Clone this repository to your local machine:

```bash
git clone git@github.com:zutin/relabs-medical-exams.git
```

2. Navigate to the project directory:

```bash
cd relabs-medical-exams
```

3. Start the project's Docker containers:

```bash
docker compose up frontend backend
```

4. Access the application at:

```bash
http://localhost:8080
```

## How to run tests/specs

You can run tests by navigating to the project folder:
```bash
cd relabs-medical-exams
```
Use the *RSpec test container* to run all tests:
```bash
docker compose up test
```

You can also run *Rubocop lint container* using the following command:
```bash
docker compose up lint
```

## API Docs

### Endpoints

##### Tests (Exams)
###### 1.1 (GET /tests)
* [Retrieves all exams](#11-get-tests---retrieves-all-exams)
###### 1.2 (GET /test/:token)
* [Retrieves an exam by its token](#12-get-testtoken---retrieves-an-exam-by-its-token)
###### 1.3 (POST /import)
* [Imports data from a CSV file](#13-post-import---imports-data-from-a-csv-file)


### 1. Tests (Exams)
### 1.1 `(GET /tests)` - Retrieves all exams

**HTTP Request**

**Response example**
- 200 OK
```bash
HTTP/1.0 200 OK
Content-Type: application/json
[
    {
        "result_token": "0W9I67",
        "result_date": "2021-07-09",
        "cpf": "048.108.026-04",
        "name": "Juliana dos Reis Filho",
        "email": "mariana_crist@kutch-torp.com",
        "birthday": "1995-07-03",
        "doctor": {
            "crm": "B0002IQM66",
            "crm_state": "SC",
            "name": "Maria Helena Ramalho",
            "email": "rayford@kemmer-kunze.info"
        },
        "tests": [
            {
                "type": "hemácias",
                "limits": "45-52",
                "result": "28"
            },
            {
                "type": "tsh",
                "limits": "25-80",
                "result": "13"
            }
        ]
    },
    {
        "result_token": "AIWH8Y",
        "result_date": "2021-06-29",
        "cpf": "071.488.453-78",
        "name": "Antônio Rebouças",
        "email": "adalberto_grady@feil.org",
        "birthday": "1999-04-11",
        "doctor": {
            "crm": "B0002W2RBG",
            "crm_state": "SP",
            "name": "Dra. Isabelly Rêgo",
            "email": "diann_klein@schinner.org"
        },
        "tests": [
            {
                "type": "ácido úrico",
                "limits": "15-61",
                "result": "43"
            },
            {
                "type": "hdl",
                "limits": "19-75",
                "result": "85"
            }
        ]
    }
]
```
- 500 Internal Server Error
```bash
HTTP/1.0 500 Internal Server Error
Content-Type: application/json
{
    "error": "Error message"
}
```

### 1.2 `(GET /test/:token)` - Retrieves an exam by its token

**HTTP Request**
- Params
```bash
  :token => String
```

**Response example**
- 200 OK
```bash
HTTP/1.0 200 OK
Content-Type: application/json
{
    "result_token": "0W9I67",
    "result_date": "2021-07-09",
    "cpf": "048.108.026-04",
    "name": "Juliana dos Reis Filho",
    "email": "mariana_crist@kutch-torp.com",
    "birthday": "1995-07-03",
    "doctor": {
        "crm": "B0002IQM66",
        "crm_state": "SC",
        "name": "Maria Helena Ramalho",
        "email": "rayford@kemmer-kunze.info"
    },
    "tests": [
        {
            "type": "tsh",
            "limits": "25-80",
            "result": "13"
        },
        {
            "type": "hemácias",
            "limits": "45-52",
            "result": "28"
        }
    ]
}
```
- 404 Not Found
```bash
HTTP/1.0 404 Not Found
Content-Type: text/html;charset=utf-8
```
- 500 Internal Server Error
```bash
HTTP/1.0 500 Internal Server Error
Content-Type: application/json
{
    "error": "Error message"
}
```

### 1.3 `(POST /import)` - Imports data from a CSV file

**HTTP Request**
- Params
```bash
  :file => .csv file
```

**Response example**
- 200 OK
```bash
HTTP/1.0 200 OK
Content-Type: text/html;charset=utf-8
```

- 400 Bad Request
```bash
HTTP/1.0 400 Bad Request
Content-Type: text/html;charset=utf-8
```

- 500 Internal Server Error
```bash
HTTP/1.0 500 Internal Server Error
Content-Type: application/json
{
    "error": "Error message"
}
```