defmodule Deltek do
  use Application
  alias Deltek.Query
  alias Deltek.Requester
  alias Deltek.Template

  @templates_dir "lib/deltek/templates"
  @projects_xml Path.join(@templates_dir, "get_projects_by_query.xml.eex")
  @clients_xml Path.join(@templates_dir, "get_clients_by_query.xml.eex")
  @employees_xml Path.join(@templates_dir, "get_employees_by_query.xml.eex")

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Deltek.Template, [@clients_xml,   :clients],   id: :clients_template),
      worker(Deltek.Template, [@projects_xml,  :projects],  id: :projects_template),
      worker(Deltek.Template, [@employees_xml, :employees], id: :employees_template),

      worker(Deltek.Template, [@clients_xml,   :client],   id: :client_template),
      worker(Deltek.Template, [@projects_xml,  :project],  id: :project_template),
      worker(Deltek.Template, [@employees_xml, :employee], id: :employee_template),
    ]

    opts = [strategy: :one_for_one, name: Deltek.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Public implementation
  #######################
  def projects(limit \\ 10, offset \\ 0),  do: request(:projects,  "GetProjectsByQuery",  [limit, offset])
  def clients(limit \\ 10, offset \\ 0),   do: request(:clients,   "GetClientsByQuery",   [limit, offset])
  def employees(limit \\ 10, offset \\ 0), do: request(:employees, "GetEmployeesByQuery", [limit, offset])

  def project(code: code),  do: request(:project,  "GetProjectsByQuery", [[code: code]])
  def project(name: name),  do: request(:project,  "GetProjectsByQuery", [[name: name]])

  def client(id: id),       do: request(:client,   "GetClientsByQuery", [[id: id]])
  def client(name: name),   do: request(:client,   "GetClientsByQuery", [[name: name]])

  def employee(id: id),     do: request(:employee, "GetEmployeesByQuery", [[id: id]])
  def employee(name: name), do: request(:employee, "GetEmployeesByQuery", [[name: name]])

  # Private implementation
  ########################
  defp request(model, action, args) do
    request = apply(Query, :build, [model | args])
    |> create_request(model)

    {:ok, requester} = Requester.start_link(action, model)
    Requester.request(requester, request)
  end

  defp create_request(query, model) do
    :deltek
    |> Application.get_all_env
    |> Keyword.merge([record_detail: "Primary", query: query])
    |> Template.eval(model)
  end
end
