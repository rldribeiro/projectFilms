using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace ProjectFilms.DAL
{
    public class Connection
    {
        public static SqlConnection GoSql()
        {
            try
            {
                string connectionString = @"Data Source=LR-ITECH-W10P;Initial Catalog=ProjectoFilmes;Integrated Security=True;";
                //string connectionString = @"Data Source=DESKTOP-O32Q2UQ\SQLEXPRESS;Initial Catalog=ProjectoFilmes;Integrated Security=True;";
                //string connectionString = @"Data Source=DIANA\SQLEXPRESS;Initial Catalog=ProjectoFilmes;Integrated Security=True;";

                SqlConnection conn = new SqlConnection(connectionString);
                if (conn.State != ConnectionState.Open)
                    conn.Open();
                return conn;
            }
            catch
            {
                return null;
            }
        }
    }
}