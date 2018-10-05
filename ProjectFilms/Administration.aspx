<%@ Page Title="" Language="C#" MasterPageFile="~/Films.Master" AutoEventWireup="true" CodeBehind="Administration.aspx.cs" Inherits="ProjectFilms.Administration" %>

<%@ MasterType VirtualPath="~/Films.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>Project Films - Administration</title>

    <!-- Fontfaces CSS-->

    <link href="/assets/vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
    <link href="/assets/vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
    <link href="/assets/vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">

    <link href="/assets/css/font-face.css" rel="stylesheet" media="all">
    <link href="/assets/css/custom.css" rel="stylesheet" />
    <link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="/assets/css/styleAdm.css" rel="stylesheet" />

    <!-- JQuery -->
    <script src="assets/js/jquery-3.3.1.min.js"></script>
    <!-- O nosso JS -->
    <script src="/assets/js/MainJS.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="adminMenu" class="p-t-20 content">
        <div class="container" style="padding: 2em 0">
            <div class="row text-center pad-top">
                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-6">
                    <div class="div-square">
                        <asp:LinkButton runat="server" ID="lnkFilms" OnClick="lnkFilms_Click">
							<i class="fas fa-film fa-5x"></i>
							<h4>Manage Films</h4>
                        </asp:LinkButton>
                    </div>
                </div>

                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-6">
                    <div class="div-square">
                        <asp:LinkButton runat="server" ID="lnkCrew" OnClick="lnkCrew_Click">
							<i class="fa fa-star fa-5x"></i>
							<h4>Manage Artists</h4>
                        </asp:LinkButton>
                    </div>
                </div>

                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-6">
                    <div class="div-square">
                        <asp:LinkButton runat="server" ID="lnkStudios" OnClick="lnkStudios_Click">
							<i class="fa fa-building fa-5x"></i>
							<h4>Manage Studios</h4>
                        </asp:LinkButton>
                    </div>
                </div>

                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-6">
                    <div class="div-square">
                        <asp:LinkButton runat="server" ID="lnkGenres" OnClick="lnkGenres_Click">
							<i class="fa fa-tag fa-5x"></i>
							<h4>Manage Genres</h4>
                        </asp:LinkButton>
                    </div>
                </div>

                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-6">
                    <div class="div-square">
                        <asp:LinkButton runat="server" ID="lnkUsers" OnClick="lnkUsers_Click">
							<i class="fa fa-users fa-5x"></i>
							<h4>Manage Users</h4>
                        </asp:LinkButton>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <asp:Panel runat="server" ID="panelFilms" CssClass="content">

        <div id="filmDatabase">
            <h2>Films in Database</h2>

            <div class="col-xs-4">
                <!-- COMO TEMOS APENAS UM PAINEL DE CADA VEZ, PODEMOS USAR O MESMO ID NO INPUT DE SEARCH -->
                <input id="searchString" onkeydown="searchFilms()" type="text" class="form-control" style="margin: 10px 0" placeholder="Search for movie TITLES and artist NAMES..." aria-label="Recipient's username" aria-describedby="basic-addon2" />
            </div>
            <div class="col-xs-2">
                <button id="btnSearch" class="btn btn-outline-secondary" type="button" style="margin: 10px 0" onclick="listFilms()">Search</button>
            </div>

            <table class="table table-bordered" id="filmTable">

                <thead>
                    <th style="display: none">ID</th>
                    <th class="text-center">
                        <button type="button" id="btnEditPoster" class="btn btn-warning form-control" onclick="posterForm()">ALTER POSTERS</button></th>
                    <th class="text-center">Title</th>
                    <th>Director</th>
                    <th>Year</th>
                    <th>Run Time</th>
                    <th colspan="2">
                        <button type="button" id="btnNewFilm" class="btn btn-warning form-control" onclick="filmForm(0)">NEW FILM</button></th>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

        <div id="filmForm" film="0">

            <div class="row">
                <div class="col-lg-4 text-center">
                    <img src="assets/images/ip/GodardNoPoster.jpg" id="filmPoster" style="width: 90%" />
                </div>

                <div class="col-lg-8">
                    <h3>Title:</h3>
                    <input id="filmTitle" type="text" class="form-control" />

                    <h4 style="padding-top: 10px;">Release Date:</h4>
                    <input id="filmDate" type="date" class="form-control" />

                    <h4 style="padding-top: 10px;">Run Time:</h4>
                    <input id="filmRunTime" type="number" class="form-control" />

                    <h4 style="padding-top: 10px;">Tag Line:</h4>
                    <input id="filmTagLine" type="text" class="form-control" />

                    <h4 style="padding-top: 10px;">Synopsis:</h4>
                    <textarea id="filmSynopsis" class="form-control" rows="7">
						</textarea>

                    <h4 style="padding-top: 10px;">IMDd code:</h4>
                    <input id="filmIMDB" type="text" class="form-control" />

                    <hr />
                    <h4 style="padding-top: 10px;">Genre(s):</h4>
                    <div id="genreList">
                    </div>
                    <div id="newGenre">
                        <select id="genreName" class="form-control"></select><br />
                        <button type="button" id="addNewGenre" class="btn btn-primary" onclick="addGenre()">ADD GENRE</button>
                    </div>
                    <hr />

                    <h4 style="padding-top: 10px;">Studio(s):</h4>
                    <div id="studioList">
                    </div>
                    <div id="newStudio">
                        <select id="studioName" class="form-control"></select><br />
                        <button type="button" id="addNewStudio" class="btn btn-primary" onclick="addStudio()">ADD STUDIO</button>
                    </div>
                    <hr />

                    <h4 style="padding-top: 10px;">Countries:</h4>
                    <div id="countryList">
                    </div>
                    <div id="newCountry">
                        <select id="countryName" class="form-control"></select><br />
                        <button type="button" id="addNewCountry" class="btn btn-primary" onclick="addCountry()">ADD COUNTRY</button>
                    </div>
                    <hr />

                    <h4 style="padding-top: 10px;">Crew:</h4>
                    <div id="crewList">
                    </div>
                    <div id="newCrew">
                        <input type="text" class="form-control" id="crewName" placeholder="Artist Name" />
                        <select id="crewRole" class="form-control"></select><br />
                        <button type="button" id="addNewCrew" class="btn btn-primary" onclick="addCrewMember()">ADD CREW</button>
                    </div>
                    <hr />

                    <button type="button" class="btn btn-primary" style="margin-top: 5px;" onclick="saveFilmChanges()">SAVE</button>
                    <button type="button" class="btn btn-danger" style="margin-top: 5px;" onclick="listFilms()">CANCEL</button>

                </div>
            </div>
        </div>

        <div id="posterForm" class="text-center">
            <h2>Upload Posters</h2>
            <div style="width: 500px; background-color: lightsteelblue; margin: auto; padding: 20px; text-align: left">
                Choose film:
                <asp:DropDownList runat="server" ID="ddlFilms" CssClass="btn btn-default"></asp:DropDownList>
                <br />
                <br />
                <asp:FileUpload runat="server" ID="FileUploadControl" />
                <br />
                <br />
                <asp:Button runat="server" ID="btnUpload" Text="Upload" CssClass="btn btn-primary" OnClick="btnUpload_Click" />
                <asp:Label runat="server" ID="StatusLabel" Text="" />
                <div class="text-right">
                    <button type="button" class="btn btn-danger" style="margin-top: 5px;" onclick="listFilms()">CANCEL</button>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            listFilms();
        </script>
    </asp:Panel>

    <asp:Panel ID="panelCrew" runat="server" CssClass="content">
        <h2>People in Films</h2>
        <div class="col-xs-4">
            <input id="searchString" onkeydown="searchPeople()" type="text" class="form-control" style="margin: 10px 0" placeholder="Search for directors, writers, actors and more..." aria-label="Recipient's username" aria-describedby="basic-addon2" />
        </div>
        <div class="col-xs-2">
            <button id="btnSearch" class="btn btn-outline-secondary" type="button" style="margin: 10px 0" onclick="listPeople()">Search</button>
        </div>

        <p><em>You can insert aditional artists directly in the films they entered!</em></p>
        <table class="table table-bordered" id="crewTable">
            <thead>
                <th class="text-center">Name</th>
                <th class="text-center">Gender</th>
                <%--<th class="text-center">Listed mainly as...</th>--%>
                <th class="text-center">Controls</th>
            </thead>
            <tbody>
            </tbody>
        </table>

        <script type="text/javascript">
            listPeople();
        </script>

    </asp:Panel>

    <asp:Panel ID="panelStudios" runat="server" CssClass="content">
        <h2>Existing Studios</h2>
        <table class="table table-bordered" id="studiosTable">
            <thead>
                <th class="text-center">
                    <div class="col-xs-4">
                        <input type="text" id="txtNewStudio" placeholder="New Studio Name" class="form-control" />
                    </div>
                    <div class="col-xs-2">
                        <button type="button" id="btnNewStudio" class="btn btn-warning" onclick="newStudio()">ADD STUDIO</button>
                    </div>
                </th>
                <th class="text-center">CONTROLS
                </th>
            </thead>
            <tbody>
            </tbody>
        </table>
        <script type="text/javascript">
            tableStudios();
        </script>
    </asp:Panel>

    <asp:Panel ID="panelGenres" runat="server" CssClass="content">
        <h2>Genres in Use</h2>

        <table class="table table-bordered" id="genresTable">
            <thead>
                <th class="text-center">
                    <div class="col-xs-4">
                        <input type="text" id="txtNewGenre" placeholder="New Genre Name" class="form-control " />
                    </div>
                    <div class="col-xs-2">
                        <button type="button" id="btnNewGenre" class="btn btn-warning" onclick="newGenre()">ADD GENRE</button>
                    </div>
                </th>

                <th class="text-center">CONTROLS
                </th>
            </thead>
            <tbody>
            </tbody>
        </table>
        <script type="text/javascript">
            tableGenres();
        </script>

    </asp:Panel>

    <asp:Panel ID="panelUsers" runat="server" CssClass="content">
        <h2 id="usersH2">Registered Users</h2>
        <div id="searchDivs">
            <div class="col-xs-4">
                <input id="searchString" onkeydown="searchUsers()" type="text" class="form-control" style="margin: 10px 0" placeholder="Search for registered users..." />
            </div>
            <div class="col-xs-2">
                <button id="btnSearch" class="btn btn-outline-secondary" type="button" style="margin: 10px 0" onclick="tableUsers()">Search</button>
            </div>
        </div>
        <table class="table table-bordered" id="usersTable">



            <thead>
                <th class="text-center">Name</th>
                <th class="text-center">Email</th>
                <th class="text-center">Number of Comments</th>
                <th class="text-center">Controls</th>
            </thead>
            <tbody>
            </tbody>
        </table>

        <table class="table table-bordered" id="commentsTable">
            <thead>
                <th class="text-center">Date/Time</th>
                <th class="text-center">Film</th>
                <th class="text-center">Rating</th>
                <th class="text-center">Comment</th>
                <th class="text-center">Controls</th>
            </thead>
            <tbody>
            </tbody>
        </table>

        <script type="text/javascript">
            tableUsers();
        </script>

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
                    <br>
                    <p>It is a long established fact that a reader will be distracted by the readable content of a page.</p>
                    <p class="text">There are many variations of passages of Lorem Ipsum available, but the majority have suffered.</p>
                </div>
                <div class="footer_box">
                    <div class="clearfix"></div>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>
    </footer>

</asp:Content>
