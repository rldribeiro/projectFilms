using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProjectFilms.Entities;

namespace ProjectFilms
{
    public partial class Films : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            User currentUser = (User)Session["User"];
            if(currentUser != null)
                btnAdminRedirect.Visible = currentUser.IsAdmin;            
        }

        public void writeUserHeader()
        {
            if (Session["User"] != null)
            {
                User CurrentUser = (User)Session["User"];
                nameOfUser.InnerText = "Nice to see you, " + CurrentUser.FirstName + "!";
            }
            else
            {
                nameOfUser.InnerText = "Login";
            }
        }

        protected void lnkLogin_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                showPanel(Page, "panelLogin");
            else
                showPanel(Page, "panelUser");
        }

        public void showPanel(Control control, string panelId)
        {
            clearFields(Page);
            foreach (Control c in control.Controls)
            {
                if (c is Panel)
                {
                    c.Visible = (c.ID == panelId) ? true : false;
                }
                else
                {
                    showPanel(c, panelId);
                }
            }
        }

        public void clearFields(Control control)
        {
            foreach (Control c in control.Controls)
            {
                if (c is TextBox)
                {
                    TextBox current = (TextBox)c;
                    current.Text = "";
                }
                else
                {
                    clearFields(c);
                }
            }
            warning.Visible = false;
        }

        protected void btnAdminRedirect_Click(object sender, EventArgs e)
        {
            Response.Redirect("Administration.aspx");
        }
    }
}