using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using ProjectFilms.Entities;
using ProjectFilms.BLL;

namespace ProjectFilms.WebServices
{
    /// <summary>
    /// Summary description for FilmsServices
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class FilmsServices : System.Web.Services.WebService
    {
        #region FILMS

        [WebMethod]
        public List<Film> SearchFilms(string searchString)
        {
            return ManageFilms.GetFilms(searchString);
        }

        [WebMethod]
        public List<Film> ListFilms()
        {
            return ManageFilms.GetFilms("");
        }

        [WebMethod]
        public Film GetFilm(int filmId)
        {
            return ManageFilms.GetFilm(filmId);
        }

        [WebMethod]
        public Film GetShortFilm(int filmId)
        {
            return ManageFilms.GetShortFilm(filmId);
        }

        [WebMethod]
        public void DeleteFilm(int filmId)
        {
            ManageFilms.RemoveFilm(filmId);
        }

        [WebMethod]
        public int SaveFilm(int filmId, string title, string date, int runtime, string tagline, string synopsis, string imdbcode)
        {
            return ManageFilms.SetFilm(filmId, title, date, runtime, tagline, synopsis, imdbcode);
        }

        #endregion

        #region PEOPLE

        [WebMethod]
        public List<Role> ListRoles()
        {
            return ManageRoles.List();
        }

        [WebMethod]
        public List<Crew> ListFilmCrew(int filmId)
        {
            return ManageCrew.GetCrew(filmId);
        }

        [WebMethod]
        public void SaveFilmCrew(int filmId, List<string> crew)
        {
            ManageCrew.SetCrew(filmId, crew);
        }

        [WebMethod]
        public List<Crew> ListPeople(string searchString)
        {
            return ManageCrew.GetCrew(searchString);
        }

        [WebMethod]
        public void RemovePerson(int personId)
        {
            ManageCrew.RemovePerson(personId);
        }

        [WebMethod]
        public void AlterPerson(Person person)
        {
            ManageCrew.SetPerson(person);
        }

        #endregion

        #region DETAILS

        // ESTÚDIOS

        [WebMethod]
        public void SaveFilmStudios(int filmId, List<int> studiosId)
        {
            ManageStudios.SetFilmStudios(filmId, studiosId);
        }

        [WebMethod]
        public List<Studio> ListStudios()
        {
            return ManageStudios.GetStudios();
        }

        [WebMethod]
        public List<Studio> ListFilmStudios(int filmId)
        {
            return ManageStudios.GetStudios(filmId);
        }

        [WebMethod]
        public int NewStudio(string name)
        {
            if (name != "" || name != null)
            {
                Studio s = new Studio() { Id = -1, Name = name };
                return ManageStudios.SetStudio(s);
            }
            return 0;
        }

        [WebMethod]
        public int ModifyStudio(int id, string name)
        {
            Studio s = new Studio() { Id = id, Name = name };
            return ManageStudios.SetStudio(s);
        }

        [WebMethod]
        public int DeleteStudio(int id)
        {
            return ManageStudios.RemoveStudio(id);
        }

        // GÉNEROS

        [WebMethod]
        public void SaveFilmGenres(int filmId, List<int> genresId)
        {
            ManageGenres.SetFilmGenres(filmId, genresId);
        }

        [WebMethod]
        public List<Genre> ListGenres()
        {
            return ManageGenres.GetGenres();
        }

        [WebMethod]
        public List<Genre> ListFilmGenres(int filmId)
        {
            return ManageGenres.GetGenres(filmId);
        }

        [WebMethod]
        public int NewGenre(string name)
        {
            if (name != "" || name != null)
            {
                Genre g = new Genre() { Id = -1, Name = name };
                return ManageGenres.SetGenre(g);
            }
            return 0;
        }

        [WebMethod]
        public int AlterGenre(int id, string name)
        {
            if (name != "" || name != null)
            {
                Genre g = new Genre() { Id = id, Name = name };
                return ManageGenres.SetGenre(g);
            }
            return 0;
        }

        [WebMethod]
        public int DeleteGenre(int id)
        {
            return ManageGenres.RemoveGenre(id);
        }

        // PAÍSES

        [WebMethod]
        public List<Country> ListCountries()
        {
            return ManageCountries.GetCountries();
        }

        [WebMethod]
        public List<Country> ListFilmCountries(int filmId)
        {
            return ManageCountries.GetCountries(filmId);
        }

        [WebMethod]
        public void SaveFilmCountries(int filmId, List<string> countriesId)
        {
            ManageCountries.SetFilmCountries(filmId, countriesId);
        }

        #endregion

    }
}
