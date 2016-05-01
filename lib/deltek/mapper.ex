defmodule Deltek.Mapper do
  import SweetXml


  @projects_tbl  "PR"
  @project_xpath ~x"//#{@projects_tbl}/ROW"l
  @project_attributes [
    code: ~x"./WBS1/text()",              name: ~x"./Name/text()",
    long_name: ~x"./LongName/text()",     project_manager: ~x"./ProjMgr/text()",
    supervisor: ~x"./Supervisor/text()",  client_id: ~x"./ClientID/text()"
  ]
  def to_map(xml, :projects), do: xml |> xpath(@project_xpath, @project_attributes) |> collect(:multiple)
  def to_map(xml, :project),  do: xml |> xpath(@project_xpath, @project_attributes) |> collect(:single)


  @clients_tbl   "CL"
  @client_xpath ~x"//#{@clients_tbl}/ROW"l
  @client_attributes [
    id: ~x"./ClientID/text()", name: ~x"./Name/text()"
  ]
  def to_map(xml, :clients), do: xml |> xpath(@client_xpath,  @client_attributes) |> collect(:multiple)
  def to_map(xml, :client),  do: xml |> xpath(@client_xpath,  @client_attributes) |> collect(:single)


  @employees_tbl "EM"
  @employee_xpath ~x"//#{@employees_tbl}/ROW"l
  @employee_attributes [
    id: ~x"./Employee/text()", first_name: ~x"./FirstName/text()", last_name: ~x"./LastName/text()"
  ]
  def to_map(xml, :employees), do: xml |> xpath(@employee_xpath,  @employee_attributes) |> collect(:multiple)
  def to_map(xml, :employee),  do: xml |> xpath(@employee_xpath,  @employee_attributes) |> collect(:single)

  # Private implementation
  ########################
  defp collect([], :single), do: nil
  defp collect([first | _rest], :single), do: first
  defp collect([first],         :single), do: first
  defp collect(coll, :multiple), do: coll
end
