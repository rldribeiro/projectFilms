using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProjectFilms.Entities;
using ProjectFilms.BLL;
using ProjectFilms.WebServices;

namespace ProjectFilms
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            writeUser();
            Master.writeUserHeader();

            if (!Page.IsPostBack)
            {
                GenerateListFilms("", 6);
                listTitle.InnerText = "Latest Films";
                Master.showPanel(Page, "panelShowFilms");
                searchFilms.Visible = true;
            }
            else
            {
                GenerateListFilms(txtSearch.Text);
                listTitle.InnerText = "What are you looking for?";
            }


        }

        protected void writeUser()
        {
            User currentUser = (User)Session["User"];
            if (currentUser != null)
            {
                userInfoEmail.Text = currentUser.Email;
                userInfoFirstName.Text = currentUser.FirstName;
                userInfoLastName.Text = currentUser.LastName;
            }
        }

        protected void lnkRegister_Click(object sender, EventArgs e)
        {
            Master.showPanel(Page, "panelRegister");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string email = registerEmail.Text;
            string firstName = registerFirstName.Text;
            string lastName = registerLastName.Text;
            string pass1 = registerPassword1.Text;
            string pass2 = registerPassword2.Text;

            UsersService service = new UsersService();
            if (service.Register(email, firstName, lastName, pass1, pass2) == 1)
            {
                Master.clearFields(Page);
                Master.showPanel(Page, "panelLogin");
                Master.FindControl("warning").Visible = true;
                ((Label)Master.FindControl("warning")).Text = "Registration was successfull. You can now login.";
            }
            else
            {
                Master.FindControl("warning").Visible = true;
                ((Label)Master.FindControl("warning")).Text = "There was a problem with your registration. Please try again later.";
            }

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = loginEmail.Text;
            string pass = loginPassword.Text;

            if (email != "" && pass != "")
            {
                UsersService service = new UsersService() { };
                try
                {
                    Session["User"] = service.Login(email, pass);
                }
                catch (Exception err)
                {
                    Master.FindControl("warning").Visible = true;
                    ((Label)Master.FindControl("warning")).Text = err.Message;
                }

                User CurrentUser = (User)Session["User"];

                Master.writeUserHeader();

                if (CurrentUser != null && CurrentUser.IsAdmin)
                {
                    Master.clearFields(Page);
                    Response.Redirect("Administration.aspx");
                }
                else if (CurrentUser != null && CurrentUser.State == false)
                {
                    Master.FindControl("warning").Visible = true;
                    ((Label)Master.FindControl("warning")).Text = "Oops... You account has been LOCKED! Please contact admin@motafilms.org and apologize!";
                    Session["User"] = null;
                    CurrentUser = null;
                }
                else if (CurrentUser != null)
                {
                    Master.clearFields(Page);
                    Response.Redirect("Default.aspx");
                }
                else
                {
                    Master.FindControl("warning").Visible = true;
                    ((Label)Master.FindControl("warning")).Text = "The login credentials don't match a record in our database. Please check email and password!";
                }
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session["User"] = null;
            Master.writeUserHeader();
            Master.showPanel(Page, "panelFilms");
        }

        private void ShowFilm(int id)
        {
            Film film = BLL.ManageFilms.GetFilm(id);
            string posterUrl = "/assets/images/ip/" + film.ImgPoster + ".jpg";

            Session["ShowFilm"] = id;

            populateGdvReviews();

            lbTitle.Text = film.Title;
            lbReleaseDate.Text = film.ReleaseDate.ToString("d"); //https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
            lbRunTime.Text = film.RunTime.ToString();
            lbImgPoster.ImageUrl = posterUrl;
            lkImdbCode.Text = film.ImdbCode;
            lkImdbCode.NavigateUrl = "https://www.imdb.com/title/" + film.ImdbCode;
            lbTagLine.Text = film.TagLine;
            lbSynopsis.Text = film.Synopsis;

            lbStudio.Text = String.Join(", ", film.Studios.Select(element => element.Name));
            lbGenre.Text = String.Join(", ", film.Genres.Select(element => element.Name));
            lbCountry.Text = String.Join(", ", film.Countries.Select(element => element.Name));
            lbLanguage.Text = String.Join(", ", film.Languages.Select(element => element.Name));
            lbDirector.Text = String.Join(", ", film.Crew.Where(element => element.Role.Name == "director").Select(element => element.Name));
            lbWriter.Text = String.Join(", ", film.Crew.Where(element => element.Role.Name == "writer").Select(element => element.Name));
            lbActors.Text = String.Join(", ", film.Crew.Where(element => element.Role.Name == "actor").Select(element => element.Name));

            if (film.Reviews.Count > 0)
            {
                lbRating.Text = ManageReviews.AverageRating(film).ToString();
                //lbRating.Text = film.Reviews.Average<Review>(element => element.Rating).ToString();
            }
            else
            {
                lbRating.Text = "0";
            }

            //foreach (Review review in film.Reviews)
            //{
            //    if (film.Reviews.IndexOf(review) > 0)
            //    {
            //        lbReviewTimeStamp.Text = review.TimeStamp.ToString();
            //        lbReviewName.Text = review.User.FirstName + review.User.LastName;
            //        lbReview.Text = review.ReviewComment;
            //    }
            //    else
            //        lbReview.Text = review.ReviewComment;
            //}

            //foreach (Studio studio in film.Studios)
            //{
            //    if (film.Studios.IndexOf(studio) != film.Studios.Count - 1)
            //        lbStudio.Text += studio.Name + ", ";
            //    else
            //        lbStudio.Text += studio.Name;   
            //}

            //foreach (Genre genre in film.Genres)
            //{
            //    if (film.Genres.IndexOf(genre) != film.Genres.Count - 1)
            //        lbGenre.Text += genre.Name + ", ";
            //    else
            //        lbGenre.Text += genre.Name;
            //}

            //foreach (Country country in film.Countries)
            //{
            //    if (film.Countries.IndexOf(country) != film.Genres.Count - 1)
            //        lbCountry.Text += country.Name + ", ";
            //    else
            //        lbCountry.Text += country.Name;
            //}

            //foreach (Language language in film.Languages)
            //{
            //    if (film.Languages.IndexOf(language) != film.Languages.Count - 1)
            //        lbLanguage.Text += language.Name + ", ";
            //    else
            //        lbLanguage.Text += language.Name;
            //}

            //foreach (Crew crew in film.Crew.Where(element=>element.Role.Name == "director"))
            //{
            //    if (film.Crew.IndexOf(crew) > 0)
            //        lbDirector.Text += "," + crew.Name;
            //    else
            //        lbDirector.Text += crew.Name;
            //}

            //foreach (Crew crew in film.Crew.Where(element=>element.Role.Name == "writer"))
            //{
            //    if (film.Crew.IndexOf(crew) > 0)
            //        lbWriter.Text += "," + crew.Name;
            //    else
            //        lbWriter.Text += crew.Name;
            //}

            //foreach (Crew crew in film.Crew.Where(element=>element.Role.Name == "actor"))
            //{
            //    if (film.Crew.IndexOf(crew) > 0)
            //        lbActors.Text += "," + crew.Name;
            //    else
            //        lbActors.Text += crew.Name;
            //}
        }

        protected void ibMoviePoster_Click(object sender, ImageClickEventArgs e)
        {
            Master.showPanel(Page, "panelFilm");

            if (Session["User"] != null)
            {
                ShowComments.Visible = true;
            }
            ImageButton b = (ImageButton)sender;
            int filmID = Convert.ToInt32(b.CommandArgument);
            ShowFilm(filmID);
        }

        protected void lvComments_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            Review review = new Review();

            if (Session["User"] != null)
            {
                review.User = (User)Session["User"];
            }
            review.TimeStamp = DateTime.Now;
            review.ReviewComment = txtReviewComment.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "alert('Comment Posted Successfully.');window.location='default.aspx';", true);
            txtReviewComment.Text = "";
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            //Review review = ManageReviews.GetReview((int)Session["ShowFilm"]);
            //List<Review> reviews = ManageReviews.SetReview(review);

            Review review = new Review();

            if (Session["ShowFilm"] != null)
            {
                review.Film = new Film() { Id = (int)Session["ShowFilm"] };
            }

            if (Session["User"] != null)
            {
                //review.User = new User() { Email = "janedoe@motafilms.org", FirstName = "Jane", LastName = "Doe" };
                review.User = (User)Session["User"];
            }
            review.ReviewComment = txtReviewComment.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "alert('Comment Posted Successfully.');window.location='default.aspx';", true);
            review.Rating = this.StarRating.CurrentRating;
            review.TimeStamp = DateTime.Now;

            BLL.ManageReviews.SetReview(review);
        }

        protected void btnStarRating_Click(object sender, EventArgs e)
        {
            ////Review review = new Review();

            ////if (Session["ShowFilm"] != null)
            ////{
            ////    review.Film = new Film() { Id = (int)Session["ShowFilm"] };
            ////}

            ////if (Session["User"] != null)
            ////{
            ////    //review.User = new User() { Email = "janedoe@motafilms.org", FirstName = "Jane", LastName = "Doe", Id = 2 };
            ////    review.User = (User)Session["User"];
            ////}

            //lblStarRating.Text = StarRating.CurrentRating.ToString();
            //int currentRating = this.StarRating.CurrentRating;
            //switch (this.StarRating.CurrentRating)
            //{
            //    case 1:
            //        currentRating = 1;
            //        break;
            //    case 2:
            //        currentRating = 2;
            //        break;
            //    case 3:
            //        currentRating = 3;
            //        break;
            //    case 4:
            //        currentRating = 4;
            //        break;
            //    case 5:
            //        currentRating = 5;
            //        break;
            //}
            //review.Rating = currentRating;
            //review.ReviewComment = "";
            lblStarRating.Text = "Your Rate: <b>" + this.StarRating.CurrentRating + "</b>.";
            //review.TimeStamp = DateTime.Now;
            //BLL.ManageReviews.SetReview(review);
            this.UpdatePanelStarRating.Update();
        }

        protected void populateGdvReviews()
        {
            gdvReviews.AutoGenerateColumns = false;
            try
            {
                List<Review> reviews = ManageReviews.GetReviews((int)Session["ShowFilm"]);

                gdvReviews.DataSource = reviews;
                gdvReviews.DataBind();
            }
            catch
            {
                gdvReviews.DataSource = null;
                gdvReviews.DataBind();
            }
        }

        private void GenerateListFilms(string searchString, int maxNum = 0)
        {
            // Quando nenhum valor é definido para maxNum, ele assume 0 e lista todos os filmes que o método devolver.
            int count = 0;

            List<Film> films = ManageFilms.GetFilms(searchString);
            if (films != null)
            {
                foreach (Film film in films)
                {
                    ImageButton poster = new ImageButton();
                    poster.ImageUrl = "/assets/images/ip/" + film.ImgPoster + ".jpg";
                    poster.CssClass = "col-sm-2 col-md-2 col-lg-2 img-responsive movie-beta__link img-search";
                    poster.ID = "Poster_" + film.Id;
                    poster.CommandArgument = film.Id.ToString();
                    poster.Click += ibMoviePoster_Click;

                    this.panelShowFilms.Controls.Add(poster);
                    count++;
                    if (count == maxNum)
                        break;
                }
            }
        }
    }
}