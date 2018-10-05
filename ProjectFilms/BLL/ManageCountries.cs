using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageCountries
    {
        public static Country GetCountry(string IsoCode)
        {
            return CRUD_films.SelectCountry(IsoCode);
        }

        public static List<Country> GetCountries(int filmId)
        {
            return CRUD_films.SelectCountries(filmId);
        }

        public static List<Country> GetCountries()
        {
            return CRUD_films.SelectCountries();
        }

        internal static void SetFilmCountries(int filmId, List<string> countriesId)
        {
            // VERIFICAR SE TODOS OS PaEXISTEM | REMOVE OS QUE NÃO EXISTIREM
            foreach (string c in countriesId)
            {
                if (CRUD_films.SelectCountry(c) == null)
                {
                    countriesId.Remove(c);
                }
            }
            //VERIFICAR SE O FILME EXISTE:
            if (ManageFilms.GetFilm(filmId) != null)
            {
                CRUD_films.SetFilmCountries(filmId, countriesId);
            }
        }
    }
}