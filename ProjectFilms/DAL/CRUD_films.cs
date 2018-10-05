using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using System.Data.SqlClient;
using System.Data;

namespace ProjectFilms.DAL
{
    public static class CRUD_films
    {
        #region DETALHES DO FILME

        public static Film SelectFilm(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT id, title, release_date, runtime, img_poster, tag_line, synopsis, imdb_code 
                                        FROM Films 
										WHERE id like @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Film selected = new Film();

                        selected.Id = reader.GetInt32(0);
                        selected.Title = reader.GetString(1);
                        selected.ReleaseDate = reader.GetDateTime(2);
                        selected.ReleaseDateString = selected.ReleaseDate.ToString("yyyy-MM-dd");
                        selected.RunTime = reader.GetInt32(3);
                        selected.ImgPoster = reader.GetString(4);

                        selected.TagLine = reader.GetString(5);
                        selected.Synopsis = reader.GetString(6);
                        selected.ImdbCode = reader.GetString(7);

                        selected.Countries = CRUD_films.SelectCountries(selected.Id);
                        selected.Crew = CRUD_films.SelectCrew(selected.Id);
                        selected.Genres = CRUD_films.SelectGenres(selected.Id);
                        selected.Languages = CRUD_films.SelectLanguages(selected.Id);
                        selected.Reviews = CRUD_films.SelectReviews(selected.Id);
                        selected.Studios = CRUD_films.SelectStudios(selected.Id);

                        return selected;
                    }
                }
            }
            return null;
        }

        public static Film SelectShortFilm(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT id, title, release_date, runtime, img_poster, tag_line, synopsis, imdb_code 
                                        FROM Films 
										WHERE id like @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Film selected = new Film();

                        selected.Id = reader.GetInt32(0);
                        selected.Title = reader.GetString(1);
                        selected.ReleaseDate = reader.GetDateTime(2);
                        selected.ReleaseDateString = selected.ReleaseDate.ToString("yyyy-MM-dd");
                        selected.RunTime = reader.GetInt32(3);
                        selected.ImgPoster = reader.GetString(4);

                        selected.TagLine = reader.GetString(5);
                        selected.Synopsis = reader.GetString(6);
                        selected.ImdbCode = reader.GetString(7);

                        return selected;
                    }
                }
            }
            return null;
        }

        public static Film SelectFilm(string title)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT id, release_date, runtime, img_poster, tag_line, synopsis, imdb_code 
                                        FROM Films 
										WHERE title like @title";
                command.Parameters.AddWithValue("@title", title);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Film selected = new Film();
                        selected.Id = reader.GetInt32(0);
                        selected.Title = title;
                        selected.ReleaseDate = reader.GetDateTime(1); //DateTime(reader.GetString(2));
                        selected.RunTime = reader.GetInt32(2);
                        selected.ImgPoster = reader.GetString(3);

                        selected.TagLine = reader.GetString(5);
                        selected.Synopsis = reader.GetString(6); ;
                        selected.ImdbCode = reader.GetString(7);
                        return selected;
                    }
                }
            }
            return null;
        }

        public static int MaxId()
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT MAX(id) FROM Films";
                return (int)command.ExecuteScalar();
            }

        }

        public static int InsertFilm(string title, string date, int runtime, string tagline, string synopsis, string imdbcode)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"INSERT INTO Films(title, release_date, runtime, synopsis, tag_line, imdb_code) 
										VALUES (@title, @release_date, @runtime, @synopsis, @tag_line, @imdb_code)";
                command.Parameters.AddWithValue("@title", title);
                command.Parameters.AddWithValue("@release_date", date);
                command.Parameters.AddWithValue("@runtime", runtime);
                command.Parameters.AddWithValue("@synopsis", synopsis);
                command.Parameters.AddWithValue("@tag_line", tagline);
                command.Parameters.AddWithValue("@imdb_code", imdbcode);

                try
                {
                    if (command.ExecuteNonQuery() != 0)
                    {
                        // DEVOLVE O ID DO FILME ACABADO DE INSERIR
                        return MaxId();
                    }
                }
                catch
                {
                    return 0;
                }
            }
            return 0;
        }

        public static int UpdateFilm(int id, string title, string date, int runtime, string tagline, string synopsis, string imdbcode)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"UPDATE Films
									   SET title = @title,
											release_date = @release_date,
											runtime = @runtime,
											synopsis = @synopsis,
											tag_line = @tag_line,
											imdb_code = @imdb_code											
									   WHERE Id = @id";

                command.Parameters.AddWithValue("@id", id);
                command.Parameters.AddWithValue("@title", title);
                command.Parameters.AddWithValue("@release_date", date);
                command.Parameters.AddWithValue("@runtime", runtime);
                command.Parameters.AddWithValue("@synopsis", synopsis);
                command.Parameters.AddWithValue("@tag_line", tagline);
                command.Parameters.AddWithValue("@imdb_code", imdbcode);

                try
                {
                    if (command.ExecuteNonQuery() != 0)
                    {
                        return id;
                    }
                }
                catch
                {
                    return 0;
                }
            }
            return 0;
        }

        public static int DeleteFilm(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                try
                {
                    SqlCommand command = conn.CreateCommand();
                    command.CommandText = @"DELETE FROM FilmCrew WHERE film_id = @id
										DELETE FROM FilmCountries WHERE film_id = @id
										DELETE FROM FilmGenres WHERE film_id = @id
										DELETE FROM FilmLanguages WHERE film_id = @id
										DELETE FROM Reviews WHERE film_id = @id
										DELETE FROM FilmStudios WHERE film_id = @id;
										DELETE FROM Films WHERE ID = @id";
                    command.Parameters.AddWithValue("@id", id);


                    return command.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    return ex.ErrorCode;
                }
            }

        }

        public static List<Film> SelectFilms(string searchString)
        {
            List<Film> filmList = new List<Film>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT DISTINCT(Films.id), Films.title, Films.release_date, Films.runtime, Films.img_poster, Films.tag_line, Films.synopsis, Films.imdb_code 
                                        FROM Films, People, FilmCrew
                                        WHERE
                                        Films.title like '%" + searchString + @"%'
                                        OR
                                        People.name like '%" + searchString + @"%'
                                        AND
                                        FilmCrew.film_id = Films.Id
                                        AND
                                        FilmCrew.person_id = People.id";

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Film selected = new Film();

                        selected.Id = reader.GetInt32(0);
                        selected.Title = reader.GetString(1);
                        selected.ReleaseDate = (DateTime)reader[2];
                        selected.ReleaseDateString = selected.ReleaseDate.ToShortDateString();
                        selected.RunTime = reader.GetInt32(3);
                        selected.ImgPoster = !reader.IsDBNull(4) ? reader.GetString(4) : "";

                        selected.TagLine = reader.GetString(5);
                        selected.Synopsis = reader.GetString(6);
                        selected.ImdbCode = !reader.IsDBNull(7) ? reader.GetString(7) : "";
                        selected.Crew = CRUD_films.SelectCrew(selected.Id);

                        filmList.Add(selected);
                    }
                }
                return filmList;
            }

        }

        public static List<Film> SelectTop5Films()
        {

            List<Film> filmList = new List<Film>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT TOP 6 id, title, release_date, runtime, img_poster, tag_line, synopsis, imdb_code 
                                        FROM Films
                                        ORDER BY release_date DESC";
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Film selected = new Film();
                        selected.Id = reader.GetInt32(0);
                        selected.Title = reader.GetString(1);
                        selected.ReleaseDate = reader.GetDateTime(2);
                        selected.RunTime = reader.GetInt32(3);
                        selected.ImgPoster = !reader.IsDBNull(4) ? reader.GetString(4) : "";
                        selected.TagLine = reader.GetString(5);
                        selected.Synopsis = reader.GetString(6);
                        selected.ImdbCode = !reader.IsDBNull(7) ? reader.GetString(7) : "";

                        filmList.Add(selected);
                    }
                }
                return filmList;
            }
        }

        public static List<Film> SelectFilms()
        {
            List<Film> filmList = new List<Film>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT id, title, release_date, runtime, img_poster, tag_line, synopsis, imdb_code 
                                        FROM Films";

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Film selected = new Film();

                        selected.Id = reader.GetInt32(0);
                        selected.Title = reader.GetString(1);
                        selected.ReleaseDate = reader.GetDateTime(2);
                        selected.RunTime = reader.GetInt32(3);
                        selected.ImgPoster = !reader.IsDBNull(4) ? reader.GetString(4) : "";
                        selected.TagLine = reader.GetString(5);
                        selected.Synopsis = reader.GetString(6);
                        selected.ImdbCode = !reader.IsDBNull(7) ? reader.GetString(7) : "";

                        selected.Countries = CRUD_films.SelectCountries(selected.Id);
                        selected.Crew = CRUD_films.SelectCrew(selected.Id);
                        selected.Genres = CRUD_films.SelectGenres(selected.Id);
                        selected.Languages = CRUD_films.SelectLanguages(selected.Id);
                        selected.Reviews = CRUD_films.SelectReviews(selected.Id);
                        selected.Studios = CRUD_films.SelectStudios(selected.Id);

                        filmList.Add(selected);
                    }
                }
                return filmList;
            }
        }

        public static List<Film> SelectFilms(Review Rating)
        {
            List<Film> filmList = new List<Film>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT Films.*, Reviews.rating
                                        FROM Films 
                                        INNER JOIN Reviews ON Films.id = Reviews.film_id 
                                        WHERE Reviews.rating LIKE @Rating";
                command.Parameters.AddWithValue("@Rating", Rating);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {

                    while (reader.Read())
                    {
                        Film selected = new Film();
                        selected.Id = reader.GetInt32(0);
                        selected.Title = reader.GetString(1);
                        selected.ReleaseDate = reader.GetDateTime(2);
                        selected.RunTime = reader.GetInt32(3);
                        selected.ImgPoster = reader.GetString(4);

                        selected.TagLine = reader.GetString(5);
                        selected.Synopsis = reader.GetString(6);
                        selected.ImdbCode = reader.GetString(7);

                        filmList.Add(selected);
                    }
                }
                return filmList;
            }
        }

        #endregion

        #region ELEMENTOS DO FILME

        public static int SetFilmStudios(int filmId, List<int> studiosId)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();

                // PRIMIRO APAGA TODOS OS ESTÚDIOS
                command.CommandText = @"DELETE FROM FilmStudios WHERE film_id = @filmId";

                // DEPOIS ADICIONA UM A UM
                foreach (int s in studiosId)
                {
                    command.CommandText += "INSERT INTO FilmStudios VALUES (@filmId, " + s + ");";
                }
                command.Parameters.AddWithValue("@filmId", filmId);

                try
                {
                    return command.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    return ex.ErrorCode;
                }
            }
        }

        public static int SetFilmGenres(int filmId, List<int> genresId)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                // PRIMIRO APAGA TODOS OS GÉNEROS
                command.CommandText = @"DELETE FROM FilmGenres WHERE film_id = @filmId;";
                // DEPOIS ADICIONA UM A UM
                foreach (int s in genresId)
                {
                    command.CommandText += "INSERT INTO FilmGenres VALUES (@filmId, " + s + ");";
                }
                command.Parameters.AddWithValue("@filmId", filmId);

                try
                {
                    return command.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    return ex.ErrorCode;
                }
            }
        }

        public static int SetFilmCrew(int filmId, List<Crew> crew)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                // PRIMEIRO APAGA A CREW ANTERIOR
                command.CommandText = @"DELETE FROM FilmCrew WHERE film_id = @filmId;";
                // DEPOIS ADICIONA UM A UM
                foreach (Crew c in crew)
                {
                    command.CommandText += "INSERT INTO FilmCrew (film_id, person_id, role_id) VALUES (@filmID, " + c.Id + "," + c.Role.Id + ");";
                }
                command.Parameters.AddWithValue("@filmId", filmId);
                try
                {
                    return command.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    return ex.ErrorCode;
                }
            }
        }

        public static List<Crew> SelectCrew(int id)
        {
            List<Crew> crewList = new List<Crew>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT	People.name, People.photo, People.gender, Roles.id, Roles.role_name, People.Id
										FROM	People, FilmCrew, Roles
										WHERE	FilmCrew.person_id = People.id
										AND		FilmCrew.role_id = Roles.id
										AND		film_id = @id
										ORDER BY Roles.id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Crew selected = new Crew();

                        selected.Name = reader.GetString(0);
                        selected.Photo = !reader.IsDBNull(1) ? reader.GetString(1) : "";
                        selected.Gender = !reader.IsDBNull(2) ? reader.GetString(2) : "";
                        selected.Role = new Role() { Id = reader.GetInt32(3), Name = reader.GetString(4) };
                        selected.Id = reader.GetInt32(5);
                        crewList.Add(selected);
                    }
                }
                return crewList;
            }
        }

        public static List<Crew> SelectCrew(string searchString)
        {
            List<Crew> crewList = new List<Crew>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT	    id, name, gender 
										FROM	    People
                                        WHERE       name like '%" + searchString + @"%'
                                        ORDER BY    name";
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Crew selected = new Crew();

                        selected.Id = reader.GetInt32(0);
                        selected.Name = reader.GetString(1);
                        selected.Gender = !reader.IsDBNull(2) ? reader.GetString(2) : "";
                        crewList.Add(selected);
                    }
                }
                return crewList;
            }
        }

        public static int SetPoster(int filmId, string posterFilename)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"UPDATE Films
                                        SET img_poster = @filename
                                        WHERE id = @filmId";
                command.Parameters.AddWithValue("@filename", posterFilename);
                command.Parameters.AddWithValue("@filmId", filmId);
                return command.ExecuteNonQuery();
            }
        }
        #endregion

        #region PAÍSES

        public static Country SelectCountry(string IsoCode)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT DISTINCT iso_code, country_name
                                    FROM Countries
                                    WHERE iso_code = @isoCode";
                command.Parameters.AddWithValue("@isoCode", IsoCode);

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        return new Country()
                        {
                            IsoCode = reader.GetString(0),
                            Name = reader.GetString(1),
                        };
                    }
                }
            }
            return null;
        }

        public static List<Country> SelectCountries(int id)
        {

            using (SqlConnection conn = Connection.GoSql())
            {
                List<Country> countriesList = new List<Country>();
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT Countries.country_name, Countries.iso_code
                                        FROM Films 
                                        INNER JOIN FilmCountries ON Films.id = FilmCountries.film_id 
                                        INNER JOIN Countries ON FilmCountries.country_id = Countries.iso_code
                                        WHERE Films.id LIKE @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Country selected = new Country();
                        selected.Name = reader.GetString(0);
                        selected.IsoCode = reader.GetString(1);
                        countriesList.Add(selected);
                    }
                }
                return countriesList;
            }
        }

        public static List<Country> SelectCountries()
        {

            List<Country> countriesList = new List<Country>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT *
                                        FROM Countries";
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Country selected = new Country();
                        selected.Name = reader.GetString(1);
                        selected.IsoCode = reader.GetString(0);
                        countriesList.Add(selected);
                    }
                }
                return countriesList;
            }
        }

        public static int SetFilmCountries(int filmId, List<string> countriesId)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                // PRIMIRO APAGA TODOS OS ESTÚDIOS
                command.CommandText = @"DELETE FROM FilmCountries WHERE film_id = @filmId;";
                // DEPOIS ADICIONA UM A UM
                foreach (string c in countriesId)
                {
                    command.CommandText += "INSERT INTO FilmCountries VALUES (@filmId, '" + c + "');";
                }
                command.Parameters.AddWithValue("@filmId", filmId);

                try
                {
                    return command.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    return ex.ErrorCode;
                }
            }
        }


        #endregion

        #region PESSOAS

        public static Person SelectPerson(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT id, name
                                        FROM People   
										WHERE id like @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Person selected = new Person();
                        selected.Id = reader.GetInt32(0);
                        selected.Name = reader.GetString(1);
                        return selected;
                    }
                }
            }
            return null;
        }

        public static Person SelectPerson(string name)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT id, name
                                        FROM People  
										WHERE name like @name";
                command.Parameters.AddWithValue("@name", name);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Person selected = new Person();
                        selected.Id = reader.GetInt32(0);
                        selected.Name = reader.GetString(1);
                        return selected;
                    }
                }
            }
            return null;
        }

        public static int InsertPerson(Person person)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"INSERT INTO People(name) 
										VALUES (@name)";
                command.Parameters.AddWithValue("@name", person.Name);

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

        public static int UpdatePerson(Person person)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();

                command.CommandText = @"UPDATE People
									   SET name = @name, gender = @gender
									   WHERE id = @id";
                command.Parameters.AddWithValue("@id", person.Id);
                command.Parameters.AddWithValue("@name", person.Name);
                command.Parameters.AddWithValue("@gender", person.Gender);

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

        public static int DeletePerson(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"DELETE FROM People WHERE id = @id";
                command.Parameters.AddWithValue("@id", id);

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

        #region FUNÇÕES

        public static Role SelectRole(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT DISTINCT role_name
                                    FROM Roles
                                    WHERE id = @id";
                command.Parameters.AddWithValue("@id", id);

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        return new Role()
                        {
                            Name = reader.GetString(0)
                        };
                    }
                }
            }
            return null;
        }

        public static bool InsertRole(Role role)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"INSERT INTO Roles(role_name) 
										VALUES (@role_name)";
                command.Parameters.AddWithValue("@role_name", role.Name);

                try
                {
                    return command.ExecuteNonQuery() == 0 ? false : true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public static bool UpdateRole(Role role)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"UPDATE Roles
									   SET role_name = @role_name
									   WHERE id = @id";

                command.Parameters.AddWithValue("@role_name", role.Name);

                try
                {
                    if (command.ExecuteNonQuery() == 0)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                catch
                {
                    return false;
                }
            }
        }

        public static bool DeleteRole(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"DELETE FROM Roles WHERE id = @id";

                try
                {
                    if (command.ExecuteNonQuery() == 0)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                catch
                {
                    return false;
                }
            }
        }

        public static List<Role> ListRoles()
        {

            List<Role> roles = new List<Role>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT *
                                        FROM Roles
                                        ORDER BY id";
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Role role = new Role();
                        role.Id = reader.GetInt32(0);
                        role.Name = reader.GetString(1);
                        roles.Add(role);
                    }
                }
                return roles;
            }
        }

        #endregion

        #region IDIOMAS

        public static Language SelectLanguage(string IsoCode)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT DISTINCT language_name
                                    FROM Languages
                                    WHERE iso_code = @iso_code";
                command.Parameters.AddWithValue("@iso_code", IsoCode);

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        return new Language()
                        {
                            Name = reader.GetString(0)
                        };
                    }
                }
            }
            return null;
        }

        public static List<Language> SelectLanguages(int id)
        {

            List<Language> languageList = new List<Language>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT Languages.language_name, Languages.iso_code
                                        FROM Films 
                                        INNER JOIN FilmLanguages ON Films.id = FilmLanguages.film_id 
                                        INNER JOIN Languages ON FilmLanguages.language_id = Languages.iso_code
                                        WHERE Films.id LIKE @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Language selected = new Language();
                        selected.Name = reader.GetString(0);
                        selected.IsoCode = reader.GetString(1);
                        languageList.Add(selected);
                    }
                }
                return languageList;
            }
        }

        #endregion

        #region ESTÚDIOS

        public static Studio SelectStudio(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT DISTINCT studio_name
                                    FROM Studios
                                    WHERE id = @id";
                command.Parameters.AddWithValue("@id", id);

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        return new Studio()
                        {
                            Name = reader.GetString(0)
                        };
                    }
                }
            }
            return null;
        }

        public static Studio SelectStudio(string name)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT *
                                    FROM Studios
                                    WHERE studio_name like @name";
                command.Parameters.AddWithValue("@name", name);

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        return new Studio()
                        {
                            Id = reader.GetInt32(0),
                            Name = reader.GetString(1)
                        };
                    }
                }
            }
            return null;
        }

        public static int InsertStudio(string name)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"INSERT INTO Studios (studio_name) 
										VALUES (@studio_name)";
                command.Parameters.AddWithValue("@studio_name", name);

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

        public static int UpdateStudio(Studio studio)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();

                command.CommandText = @"UPDATE Studios
									   SET studio_name = @studio_name
									   WHERE id = @id";
                command.Parameters.AddWithValue("@id", studio.Id);
                command.Parameters.AddWithValue("@studio_name", studio.Name);

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

        public static int DeleteStudio(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"DELETE FROM Studios WHERE id = @id";
                command.Parameters.AddWithValue("@id", id);

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

        public static List<Studio> SelectStudios(int id)
        {
            List<Studio> studioList = new List<Studio>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT Studios.id, Studios.studio_name
                                        FROM Films 
                                        INNER JOIN FilmStudios ON Films.id = FilmStudios.film_id
                                        INNER JOIN Studios ON FilmStudios.studio_id = Studios.id
                                        WHERE Films.id LIKE @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Studio selected = new Studio();
                        selected.Id = reader.GetInt32(0);
                        selected.Name = reader.GetString(1);
                        studioList.Add(selected);
                    }
                }
                return studioList;
            }
        }

        public static List<Studio> SelectStudios()
        {
            List<Studio> studioList = new List<Studio>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT *
                                        FROM Studios
                                        ORDER BY studio_name";
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Studio selected = new Studio();
                        selected.Id = reader.GetInt32(0);
                        selected.Name = reader.GetString(1);
                        studioList.Add(selected);
                    }
                }
                return studioList;
            }
        }

        #endregion

        #region GÉNEROS

        public static Genre SelectGenre(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT DISTINCT genre_name
                                    FROM Genres
                                    WHERE id = @id";
                command.Parameters.AddWithValue("@id", id);

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        return new Genre()
                        {
                            Name = reader.GetString(0)
                        };
                    }
                }
            }
            return null;
        }

        public static int InsertGenre(Genre genre)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"INSERT INTO Genres (genre_name) 
										VALUES (@genre_name)";
                command.Parameters.AddWithValue("@genre_name", genre.Name);

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

        public static int UpdateGenre(Genre genre)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();

                command.CommandText = @"UPDATE Genres
									   SET genre_name = @genre_name
									   WHERE id = @id";

                command.Parameters.AddWithValue("@genre_name", genre.Name);
                command.Parameters.AddWithValue("@id", genre.Id);

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

        public static int DeleteGenre(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"DELETE FROM Genres WHERE id = @id";
                command.Parameters.AddWithValue("@id", id);

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

        public static List<Genre> SelectGenres(int id)
        {

            List<Genre> genreList = new List<Genre>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT Genres.id, Genres.genre_name
                                        FROM Films 
                                        INNER JOIN FilmGenres ON Films.id = FilmGenres.film_id 
                                        INNER JOIN Genres ON FilmGenres.genre_id = Genres.id
                                        WHERE Films.id LIKE @id
                                        ORDER BY genre_name";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Genre selected = new Genre();
                        selected.Id = reader.GetInt32(0);
                        selected.Name = reader.GetString(1);
                        genreList.Add(selected);
                    }
                }
                return genreList;
            }
        }

        public static List<Genre> SelectGenres()
        {
            List<Genre> genreList = new List<Genre>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT *
                                        FROM Genres
                                        ORDER BY genre_name";

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Genre selected = new Genre();
                        selected.Id = reader.GetInt32(0);
                        selected.Name = reader.GetString(1);
                        genreList.Add(selected);
                    }
                }
                return genreList;
            }
        }

        #endregion

        #region COMENTÁRIOS

        public static Review SelectReview(int id)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT film_id, user_id, review, rating, time_stamp
                                        FROM Reviews    
										WHERE id like @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Review selected = new Review();
                        selected.Film.Id = reader.GetInt32(0);
                        selected.User.Id = reader.GetInt32(1);
                        selected.ReviewComment = reader.GetString(2);
                        selected.Rating = reader.GetInt32(3);
                        selected.TimeStamp = reader.GetDateTime(4);
                        return selected;
                    }
                }
            }
            return null;
        }

        public static bool InsertReview(Review review)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"INSERT INTO Reviews(review, rating, time_stamp, film_id, user_id) 
										VALUES (@review, @rating, @time_stamp)";
                command.Parameters.AddWithValue("@review", review.ReviewComment);
                command.Parameters.AddWithValue("@rating", review.Rating);
                command.Parameters.AddWithValue("@time_stamp", review.TimeStamp);
                command.Parameters.AddWithValue("@film_id", review.Film.Id);
                command.Parameters.AddWithValue("@user_id", review.User.Id);


                try
                {
                    return command.ExecuteNonQuery() == 0 ? false : true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public static bool UpdateReview(Review review)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();

                command.CommandText = @"UPDATE Reviews
									   SET review = @review,
                                           rating = @rating,
                                           time_stamp = @time_stamp,
                                           film_id = @film_id,
                                           user_id = @user_id,
									   WHERE id = @id";
                command.Parameters.AddWithValue("@review", review.ReviewComment);
                command.Parameters.AddWithValue("@rating", review.Rating);
                command.Parameters.AddWithValue("@time_stamp", review.TimeStamp);
                command.Parameters.AddWithValue("@film_id", review.Film.Id);
                command.Parameters.AddWithValue("@user_id", review.User.Id);

                try
                {
                    if (command.ExecuteNonQuery() == 0)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                catch
                {
                    return false;
                }
            }
        }

        public static int DeleteReview(int commentId)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"DELETE FROM Reviews WHERE id = @id";
                command.Parameters.AddWithValue("@id", commentId);

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

        public static List<Review> SelectReviews(int id)
        {

            List<Review> reviewList = new List<Review>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT Users.first_name, Users.last_name, Reviews.review, Reviews.time_stamp, Reviews.id, Films.title, Reviews.rating
                                        FROM Films 
                                        INNER JOIN Reviews ON Films.id = Reviews.film_id 
                                        INNER JOIN Users ON Reviews.user_id = Users.id
                                        WHERE Films.id LIKE @id";
                command.Parameters.AddWithValue("@id", id);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Review selected = new Review();
                        selected.User = new User() { FirstName = reader.GetString(0), LastName = reader.GetString(1) };
                        selected.ReviewComment = reader.GetString(2);
                        selected.TimeStamp = reader.GetDateTime(3);
                        selected.Id = reader.GetInt32(4);
                        selected.Film = new Film() { Title = reader.GetString(5) };
                        selected.Rating = reader.GetInt32(6);
                        reviewList.Add(selected);
                    }
                }
                return reviewList;
            }
        }

        public static List<Review> SelectReviewsFromUser(int userId)
        {
            List<Review> reviewList = new List<Review>();
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT Users.first_name, Users.last_name, Reviews.review, Reviews.time_stamp, Reviews.id, Films.title, Reviews.rating
                                        FROM Films
                                        INNER JOIN Reviews ON Films.id = Reviews.film_id 
                                        INNER JOIN Users ON Reviews.user_id = Users.id
                                        WHERE Users.id LIKE @id";
                command.Parameters.AddWithValue("@id", userId);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        Review selected = new Review();
                        selected.User = new User() { FirstName = reader.GetString(0), LastName = reader.GetString(1) };
                        selected.ReviewComment = reader.GetString(2);
                        selected.TimeStamp = reader.GetDateTime(3);
                        selected.TimeStampString = selected.TimeStamp.ToString();
                        selected.Id = reader.GetInt32(4);
                        selected.Film = new Film() { Title = reader.GetString(5) };
                        selected.Rating = reader.GetInt32(6);

                        reviewList.Add(selected);
                    }
                }
                return reviewList;
            }
        }

        public static double AverageRating(Film film)
        {
            using (SqlConnection conn = Connection.GoSql())
            {
                SqlCommand command = conn.CreateCommand();
                command.CommandText = @"SELECT ROUND(AVG(CAST(rating as FLOAT)), 2) 
                                        FROM Reviews
                                        WHERE Reviews.film_id = @film_id";
                command.Parameters.AddWithValue("@film_id", film.Id);

                object avgobj = command.ExecuteScalar();

                Double avg = Convert.ToDouble(avgobj);
                return avg;
            }
        }

        #endregion

    }
}