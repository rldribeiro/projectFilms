using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageCrew
    {
        public static Person GetPerson(int id)
        {
            return CRUD_films.SelectPerson(id);
        }

        public static Person GetPerson(string name)
        {
            return CRUD_films.SelectPerson(name);
        }

        public static int SetPerson(Person person)
        {
            if (CRUD_films.SelectPerson(person.Id) == null)
                return CRUD_films.InsertPerson(person);
            else
                return CRUD_films.UpdatePerson(person);
        }

        public static int RemovePerson(int personId)
        {
            if (GetPerson(personId) != null)
            {
                return CRUD_films.DeletePerson(personId);
            }
            return 0;
        }

        public static List<Crew> GetCrew(Film film)
        {
            return CRUD_films.SelectCrew(film.Id);
        }

        public static List<Crew> GetCrew(string searchString)
        {
            return CRUD_films.SelectCrew(searchString);
        }

        public static List<Crew> GetCrew(int filmId)
        {
            return CRUD_films.SelectCrew(filmId);
        }

        public static int SetCrew(int filmId, List<string> crew)
        {
            List<Crew> final = new List<Crew>();

            foreach (string c in crew)
            {
                Crew current = (new JavaScriptSerializer()).Deserialize<Crew>(c);

                // Verifica se o nome já corresponde a uma pessoa
                if (GetPerson(current.Name) != null)
                {
                    // Se já corresponder, insere directamente na lista final:
                    current.Id = GetPerson(current.Name).Id;
                }
                else
                {
                    // Se não corresponder, cria a nova pessoa primeiro:					
                    SetPerson(new Person() { Id = 0, Name = current.Name });
                    current.Id = GetPerson(current.Name).Id;
                }
                final.Add(current);
            }

            return CRUD_films.SetFilmCrew(filmId, final);
        }
    }
}