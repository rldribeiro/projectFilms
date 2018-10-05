using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageLanguages
    {
        public static Language GetLanguage(string IsoCode)
        {
            return CRUD_films.SelectLanguage(IsoCode);
        }

        public static List<Language> GetLanguage(Film film)
        {
            return CRUD_films.SelectLanguages(film.Id);
        }
    }
}