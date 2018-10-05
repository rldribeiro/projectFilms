using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using ProjectFilms.Entities;
using ProjectFilms.DAL;
using System.Text.RegularExpressions;

namespace ProjectFilms.BLL
{
	public static class Validations
	{
		public static bool ValidateEmail(string email)
		{
			try
			{
				MailAddress mailAddress = new MailAddress(email);
				return true;
			}
			catch (FormatException)
			{
				return false;
			}
		}

		public static bool ValidatePassword(string password)
		{
			return (password.Length > 0 && password.Length <= 20);
		}

		public static bool ComparePasswords(string pass1, string pass2)
		{
			return (pass1 == pass2);
		}

        public static bool isValidYear(Film film)
        {
            return (film.ReleaseDate.Year < 1895 && film.ReleaseDate.Year <= DateTime.Now.Year);
        }

        public static bool isValidMonth(Film film)
        {
            return (film.ReleaseDate.Month <= 1 && film.ReleaseDate.Month <= 12);
        }

        public static bool isValidDay(Film film)
        {
            return (film.ReleaseDate.Day <= 1 && film.ReleaseDate.Month <= 31);
        }

        //public static bool isValidYear(Review review)
        //{
        //    return (review.TimeStamp = DateTime.Now.ToString("yyyy-MM-dd");
        //}

        public static bool isValidFName(User user) /*(string fname)*/
        {
            return (user.FirstName.Length > 0 && user.FirstName.Length <= 100);
        }

        public static bool isValidLName(User user)/*(string lname)*/
        {
            return (user.LastName.Length > 0 && user.LastName.Length <= 100);
        }

        public static bool isValidTitle(Film film)/*(string title)*/
        {
            return (film.Title.Length > 0 && film.Title.Length <= 200);
        }

        public static bool isValidRunTime(Film film)/*(int runtime)*/
        {
            return (Regex.IsMatch(film.RunTime.ToString(), @"^[0 - 9]{ 1,3}$"));

        }

        public static bool isValidSynopsis(Film film)/*(string synopsis)*/
        {
            return (film.Synopsis.Length > 0 && film.Synopsis.Length <= 1000);
        }

        public static bool isValidReviewComment(Review review)/*(string reviewComment)*/
        {
            return (review.ReviewComment.Length > 0 && review.ReviewComment.Length <= 2000);
        }

        public static bool isValidRating(Review review)
        {
            return (Regex.IsMatch(review.Rating.ToString(), @"^[0-5]{1,1}$"));
        }

        public static bool isValidTagLine(Film film)/*(string tagLine)*/
        {
            return (film.TagLine.Length > 0 && film.TagLine.Length <= 300);
        }


        public static bool isValidImdbCode(Film film)
        {
            return (Regex.IsMatch(film.ImdbCode, @"^[tT]{ 2}[0-9]{7}$"));
        }

    }
}