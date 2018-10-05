<%@ Page Title="" Language="C#" MasterPageFile="~/Films.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ProjectFilms.Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ MasterType VirtualPath="~/Films.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>Project Films</title>

    <link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="/assets/css/style.css" rel="stylesheet" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Panel ID="searchFilms" class="content" runat="server">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search Films by TITLE, DIRECTOR, ACTOR..."></asp:TextBox>
    </asp:Panel>

    <asp:Panel runat="server" ID="panelRegister" CssClass="content" Visible="false">

        <div class="register-top-grid">
            <h3>Personal Information</h3>
            <div>
                <span>First Name<label>*</label></span>
                <asp:TextBox runat="server" ID="registerFirstName"></asp:TextBox>

            </div>
            <div>
                <span>Last Name<label>*</label></span>
                <asp:TextBox runat="server" ID="registerLastName"></asp:TextBox>
            </div>
            <div>
                <span>Email Address<label>*</label></span>
                <asp:TextBox runat="server" ID="registerEmail"></asp:TextBox>
            </div>
            <div class="clearfix"></div>
            <label class="news-letter">
            </label>
        </div>
        <div class="register-bottom-grid">
            <h3>Login Information</h3>
            <div>
                <span>Password<label>*</label></span>
                <asp:TextBox TextMode="Password" runat="server" ID="registerPassword1"></asp:TextBox>
            </div>
            <div>
                <span>Confirm Password<label>*</label></span>
                <asp:TextBox TextMode="Password" runat="server" ID="registerPassword2"></asp:TextBox>
            </div>
            <div class="clearfix"></div>
        </div>

        <div class="clearfix"></div>

        <div class="register-but">

            <asp:Button runat="server" ID="btnRegister" OnClick="btnRegister_Click" Text="Register" />
            <div class="clearfix"></div>
        </div>
    </asp:Panel>

    <asp:Panel runat="server" ID="panelLogin" CssClass="content" Visible="false">
        <div class="register">
            <div class="row">
                <div class="col-md-6 login-right">
                </div>
                <div class="col-md-6 login-right">
                    <h3>Login to amazing films</h3>
                    <div>
                        <span>Email
							<label>*</label></span>
                        <asp:TextBox runat="server" ID="loginEmail"></asp:TextBox>
                    </div>
                    <div>
                        <span>Password
							<label>*</label></span>
                        <asp:TextBox TextMode="Password" runat="server" ID="loginPassword"></asp:TextBox>
                    </div>
                    <div>
                        <asp:Button runat="server" ID="btnASPLogin" OnClick="btnLogin_Click" Text="LOGIN" />
                    </div>
                    <p>
                        New here?
					<asp:LinkButton runat="server" ID="lnkRegister" OnClick="lnkRegister_Click">Register</asp:LinkButton>!
                    </p>
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="panelUser" runat="server" CssClass="content" Visible="false">
        <h3>This is your page.</h3>
        <h4>
            <asp:Label ID="userInfoFirstName" runat="server" ForeColor="Maroon"></asp:Label>
            <asp:Label ID="userInfoLastName" runat="server"></asp:Label>
        </h4>
        <h5>
            <asp:Label ID="userInfoEmail" runat="server"></asp:Label></h5>
        <asp:LinkButton runat="server" ID="lnkLogout" OnClick="lnkLogout_Click">Logout!</asp:LinkButton>
    </asp:Panel>

    <asp:Panel ID="panelShowFilms" runat="server" CssClass="movie__info content clearfix" Visible="false">
        <h2 id="listTitle" class="m_3" runat="server"></h2>
    </asp:Panel>

    <asp:Panel ID="panelFilm" runat="server" Visible="false">
        <div class="content">
            <h1 class="recent">
                <asp:Label ID="lbTitle" class="movie_option title" runat="server"></asp:Label></h1>
            <div class="clearfix">
                <div class="movie_top">
                    <div class="col-md-7 movie_box">
                        <div class="desc1 span_3_of_2">
                            <strong>Release date: </strong>
                            <asp:Label ID="lbReleaseDate" class="movie_option ReleaseDate" runat="server" Text=""></asp:Label>
                            <br />
                            <strong>Genre: </strong>
                            <asp:Label ID="lbGenre" class="movie_option genre" runat="server"></asp:Label>
                            <br />
                            <strong>Run Time: </strong>
                            <asp:Label ID="lbRunTime" class="movie_option runTime" Text="0" runat="server"></asp:Label>
                            <br />
                            <strong>Studio: </strong>
                            <asp:Label ID="lbStudio" class="movie_option studio" runat="server"></asp:Label>
                            <br />
                            <strong>Country: </strong>
                            <asp:Label ID="lbCountry" class="movie_option country" runat="server"></asp:Label>
                            <br />
                            <strong>Languages: </strong>
                            <asp:Label ID="lbLanguage" class="movie_option language" runat="server"></asp:Label>
                            <br />
                            <strong>Imdb: </strong>
                            <asp:HyperLink ID="lkImdbCode" class="movie_option ImdbCode" runat="server"></asp:HyperLink>
                            <br />
                            <strong>TagLine: </strong>
                            <asp:Label ID="lbTagLine" class="movie_option tagLine" runat="server"></asp:Label>
                            <br />
                            <strong>Synopsis: </strong>
                            <asp:Label ID="lbSynopsis" class="movie_option synopsis" runat="server"></asp:Label>
                            <br />
                            <strong>Directors: </strong>
                            <asp:Label ID="lbDirector" class="movie_option director" runat="server"></asp:Label>
                            <br />
                            <strong>Writers: </strong>
                            <asp:Label ID="lbWriter" class="movie_option actors" runat="server"></asp:Label>
                            <br />
                            <strong>Actors: </strong>
                            <asp:Label ID="lbActors" class="movie_option actors" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="grid images_3_of_2">
                            <div class="movie_image">
                                <span class="movie_rating">
                                    <asp:Label ID="lbRating" runat="server"></asp:Label></span> <%--average rating--%>
                                <asp:Image ID="lbImgPoster" runat="server" CssClass="imgPoster" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="ShowComments" runat="server" Visible="false">
        <div class="content">
            <div class="clearfix">
                <div class="movie_rate">
                    <div class="rating_desc">
                        <asp:ScriptManager ID="ScriptManagerStarRating" runat="server"></asp:ScriptManager>
                        <%--<cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>--%>
                        <asp:UpdatePanel ID="UpdatePanelStarRating" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <cc1:Rating ID="StarRating" runat="server"
                                    AutoPostBack="true"
                                    RatingAlign="Horizontal"
                                    RatingDirection="LeftToRightTopToBottom"
                                    CssClass="ratingStar"
                                    WaitingStarCssClass="Filled"
                                    StarCssClass="ratingItem"
                                    FilledStarCssClass="Filled"
                                    EmptyStarCssClass="Empty"
                                    SavedStarCssClass="Saved"
                                    MaxRating="5" OnChanged="btnStarRating_Click">
                                </cc1:Rating>
                                <asp:Button ID="btnStarRating" runat="server" OnClick="btnStarRating_Click" Style="visibility: hidden" />
                                <asp:Label ID="lblStarRating" runat="server" Text="Your Rate:"></asp:Label>
                                <script type="text/javascript">
                                    Sys.Extended.UI.RatingBehavior.prototype._onStarClick = function (item) {
                                        if (this._readOnly) {
                                            return;
                                        }
                                        this.set_Rating(this._currentRating);
                                        __doPostBack('btnStarRating', '');

                                        //if (this._ratingValue == this._currentRating) {
                                        //    this.set_Rating(this._currentRating);
                                        //    //alert("current rating");
                                        //    //return;
                                        //}
                                        //if (this._ratingValue != this._currentRating) {
                                        //    this.set_Rating(this._currentRating);
                                        //}
                                    };
                                </script>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>

                    <div class="single single_list">
                        <h1>Comments</h1>
                        <%--                        <ul class="single_list">
                            <li>--%>
                        <%--                                <div class="preview"></div>--%>
                        <%--<div class="data">--%>
                        <div class="title">
                            <asp:Label ID="lbReviewTimeStamp" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lbReviewName" runat="server" Visible="false"></asp:Label>
                        </div>
                        <asp:Label ID="lbReview" runat="server" Visible="false"></asp:Label>

                        <asp:GridView runat="server" ID="gdvReviews" CssClass="table table-responsive table-bordered">
                            <Columns>
                                <asp:BoundField HeaderText="#" DataField="Id" Visible="false" />
                                <asp:BoundField HeaderText="Date/Time" DataField="TimeStamp" />
                                <asp:BoundField HeaderText="User" DataField="User.FirstName" />
                                <asp:BoundField HeaderText="Rating" DataField="Rating" />
                                <asp:BoundField HeaderText="Review" DataField="ReviewComment" />
                            </Columns>
                        </asp:GridView>


                        <%--<asp:ListView ID="lvComments" runat="server" OnItemDataBound="lvComments_ItemDataBound" OnItemCommand="lvComments_ItemCommand">
                                        <ItemTemplate>
                                            <asp:Label Visible="true"  ID="lbUser" Text='<%# Eval("User") %>' runat="server" > </asp:Label>
                                            <asp:Label Visible="true"  ID="lbTimeStamp" Text='<%# Eval("TimeStamp") %>' runat="server" > </asp:Label>
                                            <asp:Label Visible="true"  ID="lbReviewComment" Text='<%# Eval("ReviewComment") %>' runat="server" > </asp:Label>

                                            <%--<td>
                                                <%# Eval("User") %>
                                            </td>
                                            <td>
                                                <%# Eval("TimeStamp") %>
                                            </td>
                                            <td>
                                                <%# Eval("ReviewComment") %>
                                            </td>--%>
                        <%-- <%# DataBinder.Eval(review.User, "User")%>: <%# DataBinder.Eval(review.TimeStamp, "Value")%>  --%>
                        <%--                                        </ItemTemplate>
                                    </asp:ListView>--%>

                        <%--                                </div>
                            </li>

                        </ul>--%>
                    </div>
                    <!--REVIEW COMMENTS-->
                    <%--<form method="post" action="contact-post.html">--%>
                    <%--						<div class="to">
		                     	<input type="text" class="text" value="Name" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Name';}">
							 	<input type="text" class="text" value="Email" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Email';}" style="margin-left:3%">
							</div>--%>
                    <div class="text commentTextBox">
                        <asp:TextBox ID="txtReviewComment" value="Message:" TextMode="multiline" Width="1050" Columns="100" Rows="5" runat="server" />
                        <%--<textarea runat="server" value="Message:" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Message';}">Message:</textarea>--%>
                    </div>
                    <div class="form-submit1">
                        <asp:Button ID="btnSubmitComment" runat="server" Text="Submit Your Review" OnClick="btnSubmitComment_Click" />
                        <br>
                    </div>
                    <div class="clearfix"></div>
                    <%--</form>--%>
                </div>
            </div>
        </div>
    </asp:Panel>

    <footer id="footer">
        <div id="footer-3d">
            <div class="gp-container">
                <span class="first-widget-bend"></span>
            </div>
        </div>
        <div id="footer-widgets" class="gp-footer-larger-first-col">
            <div class="gp-container">
                <div class="footer-widget footer-1">
                    <div class="wpb_wrapper">
                        <img src="assets/images/f_logo.png" alt="" />
                    </div>
                </div>
                <div>
                    <br>
                    <br>
                    <p class="text" style="color: white;">The world's most popular and authoritative source for movie, TV and celebrity content.</p>
                </div>
            </div>
        </div>
        <%--<div class="footer_box">
                    <div class="col_1_of_3 span_1_of_3">
                        <h3>Categories</h3>
                        <ul class="first">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Crime</a></li>
                            <li><a href="#">Drama</a></li>
                        </ul>
                    </div>
                    <div class="col_1_of_3 span_1_of_3">
                        <h3>Categories</h3>
                        <ul class="first">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Crime</a></li>
                            <li><a href="#">Drama</a></li>
                        </ul>
                    </div>
                    <div class="col_1_of_3 span_1_of_3">
                        <h3>Categories</h3>
                        <ul class="first">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Crime</a></li>
                            <li><a href="#">Drama</a></li>
                        </ul>
                    </div>--%>
        <div class="clearfix"></div>
        <div class="clearfix"></div>
    </footer>

</asp:Content>
