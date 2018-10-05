using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProjectFilms.Entities;
using ProjectFilms.DAL;

namespace ProjectFilms.BLL
{
    public class ManageReviews
    {
        public static Review GetReview(int id)
        {
            return CRUD_films.SelectReview(id);
        }

        public static bool SetReview(Review review)
        {
            if (CRUD_films.SelectReview(review.Id) == null)
                return CRUD_films.InsertReview(review);
            else
                return CRUD_films.UpdateReview(review);
        }

        public static int RemoveReview(int id)
        {
            return CRUD_films.DeleteReview(id);
        }

        public static List<Review> GetReviews(int filmId)
        {
            return CRUD_films.SelectReviews(filmId);
        }

        public static Double AverageRating(Film film)
        {
            return CRUD_films.AverageRating(film);
        }

        public static List<Review> GetReviewsFromUser(int userId)
        {
            return CRUD_films.SelectReviewsFromUser(userId);
        }
    }
}