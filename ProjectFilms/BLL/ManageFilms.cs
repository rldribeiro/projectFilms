using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageFilms
    {
        public static Film GetFilm(int id)
        {
            return CRUD_films.SelectFilm(id);
        }

        public static Film GetShortFilm(int id)
        {
            return CRUD_films.SelectShortFilm(id);
        }

        public static Film GetFilm(string title)
        {
            return CRUD_films.SelectFilm(title);
        }

        public static int SetFilm(int id, string title, string date, int runtime, string tagline, string synopsis, string imdbcode)
        {
            if (CRUD_films.SelectFilm(id) == null)
            {
                return CRUD_films.InsertFilm(title, date, runtime, tagline, synopsis, imdbcode);
            }
            else
            {
                return CRUD_films.UpdateFilm(id, title, date, runtime, tagline, synopsis, imdbcode);
            }
        }

        public static int RemoveFilm(int id)
        {
            return CRUD_films.DeleteFilm(id);
        }

        public static List<Film> GetFilms(string searchString)
        {
            // Usar "" para uma lista completa dos filmes.
            return CRUD_films.SelectFilms(searchString);
        }

        public static int SetPoster(int filmId, string posterFilename)
        {
            return CRUD_films.SetPoster(filmId, posterFilename);
        }

        public static List<Film> GetTop5Films()
        {
            return CRUD_films.SelectTop5Films();
        }
    }
}