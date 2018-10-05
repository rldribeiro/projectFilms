using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProjectFilms;
using ProjectFilms.Entities;
using ProjectFilms.BLL;
using ProjectFilms.WebServices;
using System.Web.Services;
using System.IO;

namespace ProjectFilms
{
    public partial class Administration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                User CurrentUser = (User)Session["User"];
                if (!CurrentUser.IsAdmin)
                    Response.Redirect("Default.aspx");
            }
            catch
            {
                Response.Redirect("Default.aspx");
            }

            if (!Page.IsPostBack)
            {
                populateDdlFilms();
                Master.writeUserHeader();
                Master.showPanel(Page, "panelFilms");
            }
            else
            {
            }
        }

        protected void lnkFilms_Click(object sender, EventArgs e)
        {
            Master.showPanel(Page, "panelFilms");
        }

        protected void lnkUsers_Click(object sender, EventArgs e)
        {
            Master.showPanel(Page, "panelUsers");
        }

        protected void lnkCrew_Click(object sender, EventArgs e)
        {
            Master.showPanel(Page, "panelCrew");
        }

        protected void lnkStudios_Click(object sender, EventArgs e)
        {
            Master.showPanel(Page, "panelStudios");
        }

        protected void lnkGenres_Click(object sender, EventArgs e)
        {
            Master.showPanel(Page, "panelGenres");
        }

        protected void populateDdlFilms()
        {
            ddlFilms.DataSource = ManageFilms.GetFilms("");
            ddlFilms.DataTextField = "Title";
            ddlFilms.DataValueField = "Id";
            ddlFilms.DataBind();
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (FileUploadControl.HasFile)
            {
                try
                {
                    // guarda o ficheiro
                    string guid = Guid.NewGuid().ToString();
                    string filename = guid;
                    FileUploadControl.SaveAs(Server.MapPath("~/assets/images/ip/") + filename + ".jpg");
                    StatusLabel.Text = "Upload status: File uploaded!";

                    // actualiza o filme
                    ManageFilms.SetPoster(Convert.ToInt32(ddlFilms.SelectedValue), filename);

                    Master.showPanel(Page, "panelFilms");
                    populateDdlFilms();
                }
                catch (Exception ex)
                {
                    StatusLabel.Text = "Upload status: The file could not be uploaded. The following error occured: " + ex.Message;
                }
            }
        }
    }
}