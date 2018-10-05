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
    /// Summary description for UsersService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class UsersService : System.Web.Services.WebService
    {
        [WebMethod]
        public User Login(string email, string passwd)
        {
            return ManageUsers.Login(email, passwd);
        }

        [WebMethod]
        public int Register(string email, string firstName, string lastName, string pass1, string pass2)
        {
            return ManageUsers.Register(email, firstName, lastName, pass1, pass2);
        }

        [WebMethod]
        public int Block(int id)
        {
            User current = ManageUsers.Get(id);
            if(!current.IsAdmin)
                return ManageUsers.Block(current);
            return 0;
        }

        [WebMethod]
        public List<User> ListUsers(string searchString)
        {
            return ManageUsers.ListUsers(searchString);
        }

        [WebMethod]
        public int ModifyUser(int id, string firstName, string lastName, string email)
        {
            User user = new User() { Id = id, FirstName = firstName, LastName = lastName, Email = email };
            return ManageUsers.Update(user);
        }

        [WebMethod]
        public int CountUserComments(int id)
        {
            List<Review> reviews = ManageUsers.GetReviews(id);
            if (reviews != null)
            {
                int count = reviews.Count();
                return count;
            }
            return 0;
        }

        [WebMethod]
        public int DeleteComment(int commentId)
        {
            return ManageReviews.RemoveReview(commentId);
        }

        [WebMethod]
        public List<Review> ListReviews(int userId)
        {
            return ManageReviews.GetReviewsFromUser(userId);
        }
    }
}
