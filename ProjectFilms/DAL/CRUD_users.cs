using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.BLL;
using System.Data.SqlClient;

namespace ProjectFilms.DAL
{
    public static class CRUD_users
    {
        private static List<User> BuildUserList(SqlDataReader reader)
        {
            List<User> returnList = new List<User>();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    User valid = new User();

                    valid.Id = reader.GetInt32(0);
                    valid.FirstName = reader.GetString(1);
                    valid.LastName = reader.GetString(2);
                    valid.Email = reader.GetString(3);
                    valid.State = reader.GetBoolean(5);
                    valid.IsAdmin = reader.GetBoolean(6);

                    returnList.Add(valid);
                }

                return returnList;
            }

            return null;
        }

        #region Ir buscar um utilizador

        public static User GetUser(string email, string password)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT	*
                                        FROM	Users 
										WHERE	email		LIKE @em
										AND		passwd		LIKE @pw";
                command.Parameters.AddWithValue("@em", email);
                command.Parameters.AddWithValue("@pw", password);
                SqlDataReader reader = command.ExecuteReader();

                return BuildUserList(reader)[0];
            }
        }

        public static User GetUser(string email)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT	*
                                        FROM	Users 
										WHERE	email		LIKE @em";
                command.Parameters.AddWithValue("@em", email);

                SqlDataReader reader = command.ExecuteReader();

                return BuildUserList(reader)[0];
            }
        }

        public static User GetUser(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT	*
                                        FROM	Users 
										WHERE	id = @id";
                command.Parameters.AddWithValue("@id", id);

                SqlDataReader reader = command.ExecuteReader();

                return BuildUserList(reader)[0];
            }
        }

        #endregion

        #region INSERT | UPDATE | DELETE

        public static int InsertUser(string email, string firstName, string lastName, string password)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"INSERT INTO Users (email, first_name, last_name, passwd)
										VALUES
										(@em, @fn, @ln, @pass)";
                command.Parameters.AddWithValue("@em", email);
                command.Parameters.AddWithValue("@fn", firstName);
                command.Parameters.AddWithValue("@ln", lastName);
                command.Parameters.AddWithValue("@pass", password);

                try
                {
                    return command.ExecuteNonQuery();
                }
                catch
                {
                    return 0;
                }
            }
        }

        public static int DeleteUser(User user)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"DELETE FROM Users
										WHERE id = @id";
                command.Parameters.AddWithValue("@id", user.Id);

                try
                {
                    return command.ExecuteNonQuery();
                }
                catch
                {
                    return 0;
                }
            }
        }

        public static int UpdateUser(User user)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"UPDATE Users
										SET email = @em, first_name = @fn, last_name = @ln, user_state = @st, is_admin = @admin
										WHERE id = @id";
                command.Parameters.AddWithValue("@id", user.Id);
                command.Parameters.AddWithValue("@em", user.Email);
                command.Parameters.AddWithValue("@fn", user.FirstName);
                command.Parameters.AddWithValue("@ln", user.LastName);
                command.Parameters.AddWithValue("@st", user.State);
                command.Parameters.AddWithValue("@admin", user.IsAdmin);

                try
                {
                    return command.ExecuteNonQuery();
                }
                catch
                {
                    return 0;
                }
            }
        }

        #endregion

        #region Lista de utilizadores

        public static List<User> List(string searchString)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT * FROM Users
                                        WHERE
                                            first_name like '%" + searchString + @"%'
                                        OR
                                            last_name like '%" + searchString + "%'";
                SqlDataReader reader = command.ExecuteReader();

                return BuildUserList(reader);
            }
        }

        #endregion

        #region REVIEWS

        public static List<Review> GetReviews(User user)
        {
            List<Review> returnList = new List<Review>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT * FROM Reviews
                                        WHERE user_id = @id";
                command.Parameters.AddWithValue("@id", user.Id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Review r = new Review() { };
                        r.Id = reader.GetInt32(0);
                        r.Film = ManageFilms.GetFilm(reader.GetInt32(1));
                        r.User = user;
                        r.ReviewComment = reader.GetString(3);
                        r.Rating = reader.GetInt32(4);
                        r.TimeStamp = reader.GetDateTime(5);

                        returnList.Add(r);
                    }

                    return returnList;
                }
            }
            return null;
        }

        #endregion
    }
}