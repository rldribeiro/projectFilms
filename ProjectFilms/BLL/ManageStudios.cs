using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageStudios
    {
        public static Studio GetStudio(int id)
        {
            return CRUD_films.SelectStudio(id);
        }

        public static int SetStudio(Studio studio)
        {
            if (studio.Name != null || studio.Name != "")
            {
                if (studio.Id == -1)
                    return CRUD_films.InsertStudio(studio.Name);
                else
                    return CRUD_films.UpdateStudio(studio);
            }
            return 0;
        }

        public static int RemoveStudio(int id)
        {
            return CRUD_films.DeleteStudio(id);
        }

        public static List<Studio> GetStudios()
        {
            return CRUD_films.SelectStudios();
        }

        public static List<Studio> GetStudios(int filmId)
        {
            return CRUD_films.SelectStudios(filmId);
        }

        internal static void SetFilmStudios(int filmId, List<int> studiosId)
        {
            // VERIFICAR SE TODOS OS ESTÚDIOS EXISTEM | REMOVE OS QUE NÃO EXISTIREM
            foreach (int s in studiosId)
            {
                if (CRUD_films.SelectStudio(s) == null)
                {
                    studiosId.Remove(s);
                }
            }
            //VERIFICAR SE O FILME EXISTE:
            if (ManageFilms.GetFilm(filmId) != null)
            {
                CRUD_films.SetFilmStudios(filmId, studiosId);
            }
        }
    }
}