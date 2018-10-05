using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageGenres
    {
        public static Genre GetGenre(int id)
        {
            return CRUD_films.SelectGenre(id);
        }

        public static int SetGenre(Genre genre)
        {
            if (CRUD_films.SelectGenre(genre.Id) == null)
                return CRUD_films.InsertGenre(genre);
            else
                return CRUD_films.UpdateGenre(genre);
        }

        public static int RemoveGenre(int id)
        {
            return CRUD_films.DeleteGenre(id);
        }

        public static List<Genre> GetGenres(int filmId)
        {
            return CRUD_films.SelectGenres(filmId);
        }

        public static List<Genre> GetGenres()
        {
            return CRUD_films.SelectGenres();
        }

        internal static void SetFilmGenres(int filmId, List<int> genresId)
        {
            // VERIFICAR SE TODOS OS ESTÚDIOS EXISTEM | REMOVE OS QUE NÃO EXISTIREM
            for (int i = 0; i < genresId.Count; i++)
            {
                if (CRUD_films.SelectGenres(genresId[i]) == null)
                {
                    genresId.RemoveAt(i);
                }
            }
            //VERIFICAR SE O FILME EXISTE:
            if (ManageFilms.GetFilm(filmId) != null)
            {
                CRUD_films.SetFilmGenres(filmId, genresId);
            }
        }
    }
}