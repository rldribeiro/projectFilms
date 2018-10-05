using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageUsers
    {
        public static User Login(string email, string password)
        {
            if (Validations.ValidateEmail(email) && Validations.ValidatePassword(password))
            {
                return CRUD_users.GetUser(email, password);
            }
            return null;
        }

        public static User Get(int id)
        {
            return CRUD_users.GetUser(id);
        }

        public static int Register(string email, string firstName, string lastName, string pass1, string pass2)
        {
            if (Validations.ValidateEmail(email) && Validations.ValidatePassword(pass1) && Validations.ComparePasswords(pass1, pass2) && CRUD_users.GetUser(email) == null)
                return CRUD_users.InsertUser(email, firstName, lastName, pass1);
            return 0;
        }

        public static int Delete(User user)
        {
            if (CRUD_users.GetUser(user.Id) != null)
                return CRUD_users.DeleteUser(user);
            return 0;
        }

        public static int Update(User user)
        {
            if (CRUD_users.GetUser(user.Id) != null)
                return CRUD_users.UpdateUser(user);
            return 0;
        }

        public static int Block(User user)
        {
            if (user.State)
                user.State = false;
            else
                user.State = true;
            return Update(user);
        }

        internal static List<Review> GetReviews(int id)
        {
            User u = ManageUsers.Get(id);
            return CRUD_users.GetReviews(u);
        }

        public static List<User> ListUsers(string searchString)
        {
            return CRUD_users.List(searchString);
        }
    }
}