using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageRoles
    {
        public static Role GetRoles(int id)
        {
            return CRUD_films.SelectRole(id);
        }

        public static bool SetPerson(Role role)
        {
            if (CRUD_films.SelectRole(role.Id) == null)
                return CRUD_films.InsertRole(role);
            else
                return CRUD_films.UpdateRole(role);
        }

        public static bool RemoveRole(int id)
        {
            return CRUD_films.DeleteRole(id);
        }

        public static List<Role> List()
        {
            return CRUD_films.ListRoles();
        }
    }
}