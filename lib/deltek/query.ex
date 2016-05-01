defmodule Deltek.Query do
  @projects_tbl  "PR"
  @clients_tbl   "CL"
  @employees_tbl "EM"

  def build(:projects,  limit, offset), do: collection(@projects_tbl, limit, offset, "WBS1")
  def build(:clients,   limit, offset), do: collection(@clients_tbl,  limit, offset, "name")
  def build(:employees, limit, offset), do: collection(@employees_tbl, limit, offset, "LastName")

  def build(:project, code: code),  do: @projects_tbl  |> where("WBS1 = '#{code}'")
  def build(:project, name: name),  do: @projects_tbl  |> where("Name LIKE '%#{name}%'")

  def build(:client, id: id),       do: @clients_tbl   |> where("ClientID = '#{id}'")
  def build(:client, name: name),   do: @clients_tbl   |> where("name LIKE '%#{name}%'")

  def build(:employee, id: id),     do: @employees_tbl |> where("employee = '#{id}'")
  def build(:employee, name: name), do:
    @employees_tbl |> where("FirstName LIKE '%#{name}%' OR LastName LIKE '%#{name}%'")

  # Private implementation
  ########################
  defp collection(table, limit, offset, order_by), do:
    """
      SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (ORDER BY #{order_by}) as row FROM #{table}
      ) #{table} WHERE row > #{offset} AND row <= #{limit + offset}
    """

  defp where(table_name, where_clause), do:
    "SELECT * FROM #{table_name} WHERE #{where_clause}"
end
