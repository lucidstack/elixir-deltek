# elixir-deltek
A wrapper around the Deltek SOAP API. Requires `curl`.

## Requirements

Be sure to have `curl` installed. That's pretty much it! 👍🏻

## Installation

Add a line to your deps in `mix.exs`:
```
  def deps do
    [{:deltek, "~> 0.0.1"}]
  end
```

and `:deltek` in your applications:
```
  def application do
    [applications: [:logger, :deltek]]
  end
```

Configure `deltek` in your app's `config.exs`:
```
config :deltek,
  wsdl: "http://yourhost.com/Vision/VisionWS.asmx?wsdl",
  username: "yourusername",
  password: "yourpassword",
  database_name: "yourdatabase"
```

## Usage

The `elixir-deltek` wrapper has three main entry points: `clients`, `projects`,
and `employees`.

Use the base module `Deltek` to execute calls to the Deltek API:
```
## Projects

# Retrieve a project by its code
Deltek.project(code: "00000.00.E")
# Retrieve a project by its name (uses LIKE %name%)
Deltek.project(name: "My Project")

# Retrieve the first 10 projects
Deltek.projects
# Retrieve 25 projects with no offset
Deltek.projects(25)
# Retrieve 25 projects offset by 50 (useful for pagination)
Deltek.projects(25, 50)

## Employees

# Retrieve an employee by its name (uses LIKE on FirstName or LastName)
Deltek.employee(name: "Gustave")
# Retrieve an employee by its id (usually found in projects details)
Deltek.employee(id: "231")

# Retrieve the first 10 employees
Deltek.employees
# Retrieve 25 employees with no offset
Deltek.employees(25)
# Retrieve 25 employees offset by 50 (useful for pagination)
Deltek.employees(25, 50)

## Clients

# Retrieve a client by name (implemented with %LIKE%)
Deltek.client(name: "Grand Budapest")
# Retrieve a client by its id (usually found in projects details)
Deltek.client(id: "231")

# Retrieve the first 10 clients
Deltek.clients
# Retrieve 25 clients with no offset
Deltek.clients(25)
# Retrieve 25 clients offset by 50 (useful for pagination)
Deltek.clients(25, 50)
```
