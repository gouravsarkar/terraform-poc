data "external" "teradata_ddl" {
  program = ["sh", "-c", "bteq -c Data Source=Teradata Ventage Express;User ID=dbc;Password=dbc; <<EOF\n.EXPORT FILE=ddl_output.json\n.SET RECORDMODE OFF\nSELECT 'SHOW TABLE ' || trim(databasename) || '.' || trim(tablename) || ';' as ddl_statement FROM dbc.tables WHERE tablekind = 'T' AND databasename = '<your_database_name>' ORDER BY tablename;\n.EXPORT RESET\n.EXIT\nEOF"]
}

output "ddl_statements" {
  value = jsondecode(data.external.teradata_ddl.result)["stdout"]
}



