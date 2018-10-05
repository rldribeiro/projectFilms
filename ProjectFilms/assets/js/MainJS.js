// GLOBAIS

var roles = "";
var genres = "";
var studios = "";

var filmCrew = [];
var filmGenres = [];
var filmStudios = [];
var filmCountries = [];
var users = {};

var allGenres = [];
var allStudios = [];

var crewCount = 0;
var selectedFilmId = 0;

function toogleEdit(id) {
    $('.editDetails').hide();
    $('.showDetails').show();

    if (id != null) {
        $('#currentName_' + id).hide();
        $('#currentGender_' + id).hide();
        $('#currentEmail_' + id).hide();
        $('#btnEdit_' + id).hide();
        $('#btnDelete_' + id).hide();

        $('#genderChoice_' + id).show();
        $('#nameChoice_' + id).show();
        $('#emailChoice_' + id).show();
        $('#firstNameChoice_' + id).show();
        $('#lastNameChoice_' + id).show();

        $('#btnSave_' + id).show();
        $('#btnCancel_' + id).show();
    }
}

// GERIR EQUIPA

function listRoles() {
    // Devolve uma lista de <options> com os roles em base de dados.
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListRoles',
        data: '',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                var line = '<option value="' + key.Id + '">' + key.Name + '</option>';
                roles = roles + line;
            });
            $('#crewRole').append(roles);
        },
        error: function (data, status, error) {
            alert('Error listing roles: ' + error);
        }
    });
}

function listFilmCrew(filmId) {
    // A partir do ID de um filme, devolve uma lista com todos os elementos, no formato: X | NOME | ROLE
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListFilmCrew',
        data: '{filmId:' + filmId + '}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (key, value) {
                //alert(value.Id + value.Name + +value.Role.Id +value.Role.Name);
                addCrewMember(filmId, value.Name, value.Role.Id, value.Role.Name);
            });
        },

        error: function (data, status, error) {
            alert('Error listing crew: ' + error);
        }
    });
}

function addCrewMember(filmId, personName, roleId, roleName) {
    // Cria uma linha com o formato X | NOME | ROLE
    if (personName == null && roleId == null) {
        filmId = selectedFilmId;
        personName = $('#crewName').val().trim();
        roleId = $('#crewRole').val();
        roleName = $('#crewRole option:selected').text();
    }
    if (personName != '' && roleId != 0) {
        crewCount++;
        var crew = '{Film: { Id: ' + filmId + ' }, Name: "' + personName + '", Role: { Id: ' + roleId + ', Name: "' + roleName + '" } }';
        if ($.inArray(crew, filmCrew) != -1) {
            alert('Duplicate entry. Are you professor Mota trying to mess this up?');
        } else if (personName == '') {
            // Se 
            $('#crewName').val('');
        } else {
            filmCrew.push(crew);
            var deleteCrew = '<button type="button" class="btn btn-link" style="color:red" onclick="removeCrewLine(' + crewCount + ', \'' + personName + '\', \'' + roleId + '\', \'' + roleName + '\')"><i class="fa fa-times-circle" aria-hidden="true"></i></button>';
            $('#crewList').append('<div id="crew_' + crewCount + '">' + deleteCrew + '<span crew="' + crewCount + '">' + personName + '</span> | <strong><span id="">' + roleName.toUpperCase() + '</span><strong><br /></div>');
            var crewColor = 'black';
            switch (roleName) {
                case 'director':
                    crewColor = '#85144b';
                    break;
                case 'writer':
                    crewColor = '#0074D9';
                    break;
                case 'actor':
                    crewColor = '#3D9970';
                    break;
            }
            $('#crew_' + crewCount).css('color', crewColor);
            $('#crewName').val('');
        }
    }
}

function removeCrewLine(lineId, personName, roleId, roleName) {
    var compare = '{Film: { Id: ' + selectedFilmId + ' }, Name: "' + personName + '", Role: { Id: ' + roleId + ', Name: "' + roleName + '" } }';
    $('#crew_' + lineId).remove();
    for (i = 0; i < filmCrew.length; i++) {
        if (filmCrew[i] == compare) {
            filmCrew.splice(i, 1);
        }
    }
}

function saveCrewChanges() {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/SaveFilmCrew',
        data: '{filmId: ' + selectedFilmId + ', crew: ' + JSON.stringify(filmCrew) + '}',
        dataType: 'json',
        success: function () {
            //alert('Nem me acreditava...');
        },
        error: function (status, error) {
            alert('Error saving crew:' + status + ' | ' + error);
        }
    });
    filmCrew = [];
}

function listPeople() {
    $("#crewTable > tbody > tr").remove();
    var searchString = $('#searchString').val();
    if (searchString == null) {
        searchString = '';
    }
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListPeople',
        data: '{searchString: "' + searchString + '"}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (key, value) {
                var name = value.Name != null ? value.Name : "";
                var gender = value.Gender == 'm' ? 'male' : value.Gender == 'f' ? 'female' : "<strong>*</strong> undefined <strong>*</strong>";

                var btnDelete = '<button type="button" style="margin: 5px 0" class="btn btn-danger my-2 showDetails" id="btnDelete_' + value.Id + '" onclick="removePerson(' + value.Id + ', \'' + name + '\', \'' + value.Gender + '\')">DELETE</button>';
                var btnEdit = '<button type="button" style="margin: 5px 0" class="btn btn-primary my-2 showDetails" id="btnEdit_' + value.Id + '" onClick="toogleEdit(' + value.Id + ')">EDIT</button>';
                var btnSave = '<button type="button" style="margin: 5px 0" class="btn btn-success my-2 editDetails" id="btnSave_' + value.Id + '" onClick="alterPerson(' + value.Id + ')">SAVE</button>';
                var btnCancel = '<button type="button" style="margin: 5px 0" class="btn btn-danger my-2 editDetails" id="btnCancel_' + value.Id + '" onClick="toogleEdit()">CANCEL</button>';

                var row = '<tr id="artist_' + value.Id + '">' +
                    '<td class="text-center align-middle"><strong><span class="showDetails" id="currentName_' + value.Id + '">' + name + '<span></strong><input class="editDetails"  type="text" id="nameChoice_' + value.Id + '" value="' + name + '"></td>' +
                    '<td class="text-center align-middle"><span class="showDetails" id="currentGender_' + value.Id + '">' + gender + '</span><select class="editDetails" id="genderChoice_' + value.Id + '"><option value="m">male</option><option value="f">female</option><option value="x">undefined</option></select></td>' +
                    //'<td class="text-center align-middle">' + mainRole + '</td>' +
                    '<td class="text-center align-middle">' + " " + btnSave + " " + btnCancel + " " + btnEdit + " " + btnDelete + '</td>' +
                    '</tr>';
                $('#crewTable').append(row);
                $('#genderChoice_' + value.Id).val(value.Gender || 'x'); // coloca a selecção de género na opção que vem da base de dados.
                toogleEdit();
            });
        },
        error: function (data, status, error) {
            alert('Error listing Films: ' + error);
        }
    });
}

function removePerson(personId, personName, personGender) {
    var pronoum = personGender === 'm' ? 'he' : personGender === 'f' ? 'she' : 'it';
    var confirmation = confirm('This will DELETE ' + personName + ' from all the films ' + pronoum + ' enters. Are you sure?');
    if (confirmation) {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/RemovePerson',
            data: '{personId: ' + personId + '}',
            dataType: 'json',
            success: function () {
                $('#crewTable tr#artist_' + personId + ' td').hide(200);
            },
            error: function (data, status, error) {
                alert('Error (delete Person): ' + error);
            }
        });
    }
}

function alterPerson(personId) {
    var person = {};
    person.Id = personId;
    person.Name = $('#nameChoice_' + personId).val();
    person.Gender = $('#genderChoice_' + personId).val();

    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/AlterPerson',
        data: '{person: ' + JSON.stringify(person) + '}',
        dataType: 'json',
        success: function () {
            toogleEdit();
            alert('Details updated!');
            $('#currentName_' + personId).text($('#nameChoice_' + personId).val());
            $('#currentGender_' + personId).text($('#genderChoice_' + personId + ' option:selected').text());
        },
        error: function (data, status, error) {
            alert('Error (delete Person): ' + error);
        }
    });
}

// GERIR GÉNEROS

function listGenres() {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListGenres',
        data: '',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                var line = '<option value="' + key.Id + '">' + key.Name + '</option>';
                genres = genres + line;
            });
            $('#genreName').append(genres);
        },
        error: function (data, status, error) {
            alert('Error listing genres: ' + error);
        }
    });
}

function listFilmGenres(filmId) {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListFilmGenres',
        data: '{filmId:' + filmId + '}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                addGenre(key.Id, key.Name);
            });
        },
        error: function (data, status, error) {
            alert('Error listing film genres: ' + error);
        }
    });
}

function addGenre(id, name) {
    if (name == null) {
        name = $('#genreName option:selected').text();
        id = $('#genreName').val()
    }
    if (document.getElementById('genre_' + id) !== null) {
        alert('That genre is already listed!');
    } else if (name !== "") {
        var deleteGenre = '<button type="button" class="btn btn-link" style="color:red" onclick="removeGenre(\'' + id + '\')"><i class="fa fa-times-circle" aria-hidden="true"></i></button>';
        $('#genreList').append('<div id="genre_' + id + '">' + deleteGenre + '<span>' + name + '</span>');
        filmGenres.push(id);
    }
}

function removeGenre(id) {
    $('#genre_' + id).remove();
    filmGenres.splice(filmGenres.indexOf(id), 1);
}

function saveGenreChanges() {
    // ACTUALIZAR GÉNEROS
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/SaveFilmGenres',
        data: '{filmId: ' + selectedFilmId + ', genresId: [' + filmGenres + ']}',
        dataType: 'json',
        success: function () {
        },
        error: function (status, error) {
            alert('Error Genres Changes:' + status + " | " + error);
        }
    });
    filmGenres = [];
}

function tableGenres() {
    allGenres = [];
    $("#genresTable > tbody > tr").remove();
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListGenres',
        data: '',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                // Cria a lista de géneros para editar
                var btnDelete = '<button type="button" style="margin: 5px 0" class="btn btn-danger my-2 showDetails" id="btnDelete_' + key.Id + '" onclick="deleteGenre(' + key.Id + ', \'' + key.Name + '\')">DELETE</button>';
                var btnEdit = '<button type="button" style="margin: 5px 0" class="btn btn-primary my-2 showDetails" id="btnEdit_' + key.Id + '" onClick="toogleEdit(' + key.Id + ')">EDIT</button>';
                var btnSave = '<button type="button" style="margin: 5px 0" class="btn btn-success my-2 editDetails" id="btnSave_' + key.Id + '" onClick="alterGenre(' + key.Id + ')">SAVE</button>';
                var btnCancel = '<button type="button" style="margin: 5px 0" class="btn btn-danger my-2 editDetails" id="btnCancel_' + key.Id + '" onClick="toogleEdit()">CANCEL</button>';

                var row = '<tr id="studio_' + key.Id + '">' +
                    '<td class="text-center align-middle"><strong><span class="showDetails" id="currentName_' + key.Id + '">' + key.Name + '<span></strong><input class="editDetails"  type="text" id="nameChoice_' + key.Id + '" value="' + key.Name + '"></td>' +
                    '<td class="text-center align-middle">' + " " + btnSave + " " + btnCancel + " " + btnEdit + " " + btnDelete + '</td>' +
                    '</tr>';
                $('#genresTable').append(row);
                allGenres.push(key.Name);
            });
            toogleEdit();
        },
        error: function (data, status, error) {
            alert('Error listing genres: ' + error);
        }
    });
}

function newGenre() {
    var name = $('#txtNewGenre').val().trim().toLowerCase();

    if (allGenres.indexOf(name) != -1) {
        alert('Duplicate entry!');
    } else if (name == null || name == '') {
        alert('You must provide a name for the new Genre!');
    } else {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/NewGenre',
            data: '{name: "' + name + '"}',
            dataType: 'json',
            success: function (data) {
                alert('New genre successfuly added!');
                $('#txtNewGenre').val('');
                tableGenres();
            },
            error: function (data, status, error) {
                alert('Error adding new Studio: ' + error);
            }
        });
    }
}

function alterGenre(id) {
    var newName = $('#nameChoice_' + id).val();
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/AlterGenre',
        data: '{id: ' + id + ', name: "' + newName + '"}',
        dataType: 'json',
        success: function (data) {
            $('#currentName_' + id).text(newName);
            toogleEdit();
        },
        error: function (data, status, error) {
            alert('Error adding new genre: ' + error);
        }
    });
}

function deleteGenre(id) {
    var confirmation = confirm('This will DELETE ' + $('#currentName_' + id).text() + ' from all the films. Are you sure?');
    if (confirmation) {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/DeleteGenre',
            data: '{id: ' + id + '}',
            dataType: 'json',
            success: function (data) {
                tableGenres();
            },
            error: function (data, status, error) {
                alert('Error adding new Studio: ' + error);
            }
        });
    }
}

// GERIR ESTÚDIOS

function listStudios() {
    var studioSelect = '';
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListStudios',
        data: '',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                // Cria a combobox
                var optionLine = '<option value="' + key.Id + '">' + key.Name + '</option>';
                studioSelect = studioSelect + optionLine;
            });
            $('#studioName').append(studioSelect);
        },
        error: function (data, status, error) {
            alert('Error listing studios: ' + error);
        }
    });
}

function tableStudios() {
    allStudios = [];
    $("#studiosTable > tbody > tr").remove();
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListStudios',
        data: '',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                // Cria a lista de estúdios para editar
                var btnDelete = '<button type="button" style="margin: 5px 0" class="btn btn-danger my-2 showDetails" id="btnDelete_' + key.Id + '" onclick="deleteStudio(' + key.Id + ', \'' + key.Name + '\')">DELETE</button>';
                var btnEdit = '<button type="button" style="margin: 5px 0" class="btn btn-primary my-2 showDetails" id="btnEdit_' + key.Id + '" onClick="toogleEdit(' + key.Id + ')">EDIT</button>';
                var btnSave = '<button type="button" style="margin: 5px 0" class="btn btn-success my-2 editDetails" id="btnSave_' + key.Id + '" onClick="alterStudio(' + key.Id + ')">SAVE</button>';
                var btnCancel = '<button type="button" style="margin: 5px 0" class="btn btn-danger my-2 editDetails" id="btnCancel_' + key.Id + '" onClick="toogleEdit()">CANCEL</button>';

                var row = '<tr id="studio_' + key.Id + '">' +
                    '<td class="text-center align-middle"><strong><span class="showDetails" id="currentName_' + key.Id + '">' + key.Name + '<span></strong><input class="editDetails"  type="text" id="nameChoice_' + key.Id + '" value="' + key.Name + '"></td>' +
                    '<td class="text-center align-middle">' + " " + btnSave + " " + btnCancel + " " + btnEdit + " " + btnDelete + '</td>' +
                    '</tr>';
                $('#studiosTable').append(row);
                allStudios.push(key.Name);
            });
            toogleEdit();
        },
        error: function (data, status, error) {
            alert('Error listing studios: ' + error);
        }
    });
}

function listFilmStudios(filmId) {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListFilmStudios',
        data: '{filmId:' + filmId + '}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                addStudio(key.Id, key.Name);
            });
        },
        error: function (data, status, error) {
            alert('Error listing film studios: ' + error);
        }
    });
}

function addStudio(id, name) {
    if (name == null) {
        name = $('#studioName option:selected').text();
        id = $('#studioName').val()
    }
    if (document.getElementById('studio_' + id) !== null) {
        alert('That studio is already listed!');
    } else if (name !== "") {
        var deleteStudio = '<button type="button" class="btn btn-link" style="color:red" onclick="removeStudio(\'' + id + '\')"><i class="fa fa-times-circle" aria-hidden="true"></i></button>';
        $('#studioList').append('<div id="studio_' + id + '">' + deleteStudio + '<span>' + name + '</span>');
        filmStudios.push(id);
    }
}

function newStudio() {
    var name = $('#txtNewStudio').val().trim();

    if (allStudios.indexOf(name.toLowerCase()) != -1) {
        alert('Duplicate entry!');
    } else if (name == null || name == '') {
        alert('You must provide a name for the new studio!');
    } else {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/NewStudio',
            data: '{name: "' + name + '"}',
            dataType: 'json',
            success: function (data) {
                alert('New studio successfuly added!');
                $('#txtNewStudio').val('');
                tableStudios();
            },
            error: function (data, status, error) {
                alert('Error adding new Studio: ' + error);
            }
        });
    }
}

function alterStudio(id) {
    var newName = $('#nameChoice_' + id).val();
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ModifyStudio',
        data: '{id: ' + id + ', name: "' + newName + '"}',
        dataType: 'json',
        success: function (data) {
            $('#currentName_' + id).text(newName);
            toogleEdit();
        },
        error: function (data, status, error) {
            alert('Error adding new Studio: ' + error);
        }
    });
}

function removeStudio(id) {
    // retira um estúdio de um filme (apaga a linha e remove da lista de estúdios)
    $('#studio_' + id).remove();
    filmStudios.splice(filmStudios.indexOf(id), 1);
}

function deleteStudio(id) {
    var confirmation = confirm('This will DELETE ' + $('#currentName_' + id).text() + ' from all the films. Are you sure?');
    if (confirmation) {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/DeleteStudio',
            data: '{id: ' + id + '}',
            dataType: 'json',
            success: function (data) {
                tableStudios();
            },
            error: function (data, status, error) {
                alert('Error adding new Studio: ' + error);
            }
        });
    }
}

function saveStudioChanges() {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/SaveFilmStudios',
        data: '{filmId: ' + selectedFilmId + ', studiosId: [' + filmStudios + ']}',
        dataType: 'json',
        success: function () {
        },
        error: function (status, error) {
            alert('Error Studio Changes:' + status + " | " + error);
        }
    });
    filmStudios = [];
}

// GERIR PAÍSES

function listCountries() {
    var countrySelect = '';
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListCountries',
        data: '',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                // Cria a combobox
                var optionLine = '<option value="' + key.IsoCode + '">' + key.Name + '</option>';
                countrySelect = countrySelect + optionLine;
            });
            $('#countryName').append(countrySelect);
        },
        error: function (data, status, error) {
            alert('Error listing countries: ' + error);
        }
    });
}

function listFilmCountries(filmId) {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/ListFilmCountries',
        data: '{filmId:' + filmId + '}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (i, key) {
                addCountry(key.IsoCode, key.Name);
            });
        },
        error: function (data, status, error) {
            alert('Error listing film countries: ' + error);
        }
    });
}

function addCountry(isoCode, name) {
    if (name == null) {
        name = $('#countryName option:selected').text();
        isoCode = $('#countryName').val();
    }
    if (document.getElementById('country_' + isoCode) !== null) {
        alert('That country is already listed!');
    } else if (name !== "") {
        var deleteCountry = '<button type="button" class="btn btn-link" style="color:red" onclick="removeCountry(\'' + isoCode + '\')"><i class="fa fa-times-circle" aria-hidden="true"></i></button>';
        $('#countryList').append('<div id="country_' + isoCode + '">' + deleteCountry + '<span>' + name + '</span>');
        filmCountries.push(isoCode);
    }
}

function removeCountry(id) {
    $('#country_' + id).remove();
    filmCountries.splice(filmCountries.indexOf(id), 1);
}

function saveCountryChanges() {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/SaveFilmCountries',
        data: '{filmId: ' + selectedFilmId + ', countriesId: ' + JSON.stringify(filmCountries) + '}',
        dataType: 'json',
        success: function () {
        },
        error: function (status, error) {
            alert('Error Country Changes:' + status + " | " + error);
        }
    });
    filmCountries = [];
}

// GERIR FILMES

function listFilms() {

    var searchString = $('#searchString').val();
    if (searchString == null) {
        searchString = '';
    }

    $("#filmTable > tbody > tr").remove();
    $("#posterForm").hide();
    $("#filmForm").hide();
    clearFilmForm();
    $("#filmDatabase").show();

    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/FilmsServices.asmx/SearchFilms',
        data: '{searchString: "' + searchString + '"}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (key, value) {
                if (value != null) {
                    var director = '';
                    $.each(value.Crew, function (key, value) {
                        if (value.Role.Id == 1) {
                            director = value.Name;
                        }
                    });
                    var title = value.Title != null ? value.Title : "";
                    var date = value.ReleaseDateString != null ? value.ReleaseDateString.substring(6, 10) : "";
                    var runTime = value.RunTime != null ? value.RunTime : 0;

                    var btnDelete = '<button type="button" style="margin: 5px 0" class="btn btn-danger form-control my-2" onclick="removeFilm(' + value.Id + ', \'' + title + '\')">DELETE</button>';
                    var btnEdit = '<button type="button" style="margin: 5px 0" class="btn btn-primary form-control my-2" onClick="filmForm(' + value.Id + ')">EDIT</button>';

                    var row = '<tr id="film_' + value.Id + '">' +
                        '<td class="text-center align-middle"><img id="Poster' + value.Id + '" src="/assets/images/ip/' + value.ImgPoster + '.jpg" width="69" alt="Poster" \></td>' +
                        '<td id="Title' + value.Id + '" class="text-center align-middle"><strong>' + title + '</strong></td>' +
                        '<td id="Director' + value.Id + '" class="align-middle">' + director + '</td>' +
                        '<td id="ReleaseDate' + value.Id + '" class="align-middle">' + date + '</td>' +
                        '<td id="RunTime' + value.Id + '" class="align-middle">' + runTime + ' min</td>' +
                        '<td class="text-center align-middle">' + btnEdit + '<br />' + btnDelete + '</td>' +
                        '</tr>';

                    $("#filmTable").append(row);
                }
            });
        },
        error: function (data, status, error) {
            alert('Error listing Films: ' + error);
        }
    });
}

function posterForm() {
    $("#posterForm").show();
    $("#filmForm").hide();
    $("#filmDatabase").hide();
}

function removeFilm(id, title) {
    var confirmation = confirm('This will DELETE ' + title + ' from the database. Are you sure?');
    if (confirmation) {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/DeleteFilm',
            data: '{filmId:' + id + '}',
            dataType: 'json',
            success: function () {
                $('#filmTable tr#film_' + id + ' td').hide(200);
            },
            error: function (status, error) {
                alert('Error:' + status + " " + error);
            }
        });
    }
}

function filmForm(id) {
    $('#filmForm').attr('film', id);
    $("#filmDatabase").hide();
    $("#filmForm").show();

    selectedFilmId = id;

    if (id !== 0) {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/GetFilm',
            data: '{filmId: ' + id + '}',
            dataType: 'json',
            success: function (data) {
                var film = data.d;
                $('#filmTitle').val(film.Title);
                $("#filmPoster").attr("src", '/assets/images/ip/' + film.ImgPoster + '.jpg');
                $('#filmDate').val(film.ReleaseDateString);
                $('#filmRunTime').val(film.RunTime);
                $('#filmTagLine').val(film.TagLine);
                $('#filmSynopsis').text(film.Synopsis);
                $('#filmIMDB').val(film.ImdbCode);
                $('#filmTrailer').val(film.Trailer);
                $('#filmSite').val(film.OfficialSite);
            },
            error: function (data, status, error) {
                alert('Error:' + data + " " + status + " " + error);
            }
        });

        listFilmCrew(id);
        listFilmGenres(id);
        listFilmStudios(id);
        listFilmCountries(id);
    }
}

function saveFilmChanges() {
    var filmId = selectedFilmId;
    var title = $('#filmTitle').val().trim();
    var date = $('#filmDate').val();
    var runTime = $('#filmRunTime').val();
    var tagLine = $('#filmTagLine').val().trim();
    var synopsis = $('#filmSynopsis').val().trim();
    var imdbCode = $('#filmIMDB').val().trim();

    if (title == "" || date == "" || runTime == 0 || tagLine == "" || synopsis == "" || imdbCode == "") {
        alert('Not all fields have data.');
    } else {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/FilmsServices.asmx/SaveFilm',
            data: '{filmId: ' + filmId +
                ' , title: "' + title +
                '", date: "' + date +
                '", runtime: ' + runTime +
                ' , tagline: "' + tagLine +
                '", synopsis: "' + synopsis +
                '", imdbcode: "' + imdbCode + '"}',
            dataType: 'json',
            success: function (data) {
                selectedFilmId = data.d;
                //alert('Filme guardado com id: ' + data.d);
                saveStudioChanges();
                saveGenreChanges();
                saveCrewChanges();
                saveCountryChanges();
                alert('Changes successfully submitted!');
                listFilms();
            },
            error: function (data, status, error) {
                alert('Error saving film: ' + status + " | " + error);
            }
        });
    }
}

function clearFilmForm() {
    $('#filmTitle').val('');
    $('#filmDate').val('');
    $('#filmRunTime').val('');
    $('#filmTagLine').val('');
    $('#filmSynopsis').text('');
    $('#filmIMDB').val('');
    $('#filmTrailer').val('');
    $('#filmSite').val('');
    $('#filmPoster').attr('src', 'assets/images/ip/GodardNoPoster.jpg');
    $('#studioList').empty();
    $('#genreList').empty();
    $('#crewList').empty();

}

// FUNÇÕES PARA ACTIVAR PESQUISA COM ENTER

function searchUsers() {
    if (event.key === 'Enter') {
        event.preventDefault();
        tableUsers();
    }
}

function searchFilms() {
    if (event.key === 'Enter') {
        event.preventDefault();
        listFilms();
    }
}

function searchPeople() {
    if (event.key === 'Enter') {
        event.preventDefault();
        listPeople();
    }
}

// GERIR UTILIZADORES

function tableUsers() {
    $("#usersTable > tbody > tr").remove();
    $('#commentsTable').hide();
    $('#searchDivs').show();
    $('#usersH2').text('Registered Users');
    var searchString = $('#searchString').val();
    if (searchString == null) {
        searchString = '';
    }
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/UsersService.asmx/ListUsers',
        data: '{searchString: "' + searchString + '"}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (key, value) {
                users[value.Id] = value;
                var adminStar = value.IsAdmin == true ? '<span style="color:blue"> [ ADMIN ]</span>' : '';
                var blockStar = value.State == false ? '<span style="color:red"> [ BLOCKED ] </span>' : '';

                var btnBlock = '<button type="button" style="margin: 5px 0" class="btn btn-warning my-2 showDetails" id="btnBlock" onclick="blockUser(' + value.Id + ')">BLOCK / UNBLOCK</button>';
                if (value.IsAdmin) {
                    btnBlock = '';
                }
                var btnEdit = '<button type="button" style="margin: 5px 0" class="btn btn-primary my-2 showDetails" id="btnEdit_' + value.Id + '" onClick="toogleEdit(' + value.Id + ')">EDIT</button>';
                var btnSave = '<button type="button" style="margin: 5px 0" class="btn btn-success my-2 editDetails" id="btnSave_' + value.Id + '" onClick="alterUser(' + value.Id + ')">SAVE</button>';
                var btnCancel = '<button type="button" style="margin: 5px 0" class="btn btn-danger my-2 editDetails" id="btnCancel_' + value.Id + '" onClick="toogleEdit()">CANCEL</button>';

                var row = '<tr id="user_' + value.Id + '">' +
                    '<td userdetail="Name" class="text-center align-middle"><span class="showDetails" id="currentName_' + value.Id + '"><strong>' + value.FirstName + ' ' + value.LastName + adminStar + blockStar + '</strong></span><input class="editDetails"  type="text" id="firstNameChoice_' + value.Id + '" value="' + value.FirstName + '"> <input class="editDetails"  type="text" id="lastNameChoice_' + value.Id + '" value="' + value.LastName + '"></td>' +
                    '<td userdetail="Email" class="text-center align-middle"><span class="showDetails" id="currentEmail_' + value.Id + '">' + value.Email + '</span><input class="editDetails" type="email" id="emailChoice_' + value.Id + '" value="' + value.Email + '"></td>' +
                    '<td ><span id="userCommentsCount_' + value.Id + '"></span><button id="btnComments_' + value.Id + '" type="button" class="btn btn-link" onclick="tableComments(' + value.Id + ')"></button></td>' +
                    '<td class="text-center align-middle">' + btnEdit + ' ' + btnSave + ' ' + btnCancel + ' ' + btnBlock + '</td>' +
                    '</tr>';
                $('#usersTable').append(row);
                //var count = countUserComments(value.Id);
                //$('#userCommentsCount_' + value.Id).text(count);
                $('#btnComments_' + value.Id).text('SEE COMMENTS');
            });
            toogleEdit();
        },
        error: function (data, status, error) {
            alert('Error listing users: ' + error);
        }
    });
}

function countUserComments(userId) {
    var count = 0;
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/UsersService.asmx/CountUserComments',
        data: '{id: ' + userId + '}',
        dataType: 'json',
        success: function (data) {
            count = data.d;
        },
        error: function (data, status, error) {
            alert('Error counting comments: ' + error);
        }
    });
    return count;
}

function blockUser(userId, isAdmin) {
    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/UsersService.asmx/Block',
        data: '{id: ' + userId + '}',
        dataType: 'json',
        success: function (data) {
            tableUsers();
        },
        error: function (data, status, error) {
            alert('Error blocking user: ' + error);
        }
    });
}

function alterUser(userId) {
    toogleEdit();

    var firstName = $('#firstNameChoice_' + userId).val();
    var lastName = $('#lastNameChoice_' + userId).val();
    var email = $('#emailChoice_' + userId).val();

    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/UsersService.asmx/ModifyUser',
        data: '{id: ' + userId + ', firstName: "' + firstName + '", lastName: "' + lastName + '", email: "' + email + '"}',
        dataType: 'json',
        success: function (data) {
            tableUsers();
        },
        error: function (data, status, error) {
            alert('Error adding new Studio: ' + error);
        }
    });
}

function tableComments(userId) {
    var user = users[userId];
    $("#commentsTable > tbody > tr").remove();
    $('#usersTable').hide();
    $('#searchDivs').hide();
    $('#commentsTable').show();
    $('#usersH2').text('Comments for ' + user.FirstName + ' ' + user.LastName);

    $.ajax({
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        url: '/WebServices/UsersService.asmx/ListReviews',
        data: '{userId: "' + userId + '"}',
        dataType: 'json',
        success: function (data) {
            $.each(data.d, function (key, value) {
                var btnDelete = '<button type="button" style="margin: 5px 0" class="btn btn-warning my-2 showDetails" id="btnBlock" onclick="deleteComment(' + value.Id + ')">DELETE COMMENT</button>';

                var row = '<tr id="comment_' + value.Id + '">' +
                    '<td commentdetail="TimeStamp"  class="text-center align-middle"><span class="showDetails" id="commentTimeStamp_' + value.Id + '">' + value.TimeStampString + '</span></td>' +
                    '<td commentdetail="Film"       class="text-center align-middle"><span class="showDetails" id="commentFilm_' + value.Id + '"><strong>' + value.Film.Title + '</strong></span></td>' +
                    '<td commentdetail="Rating"    class="text-center align-middle"><span class="showDetails" id="commentRating_' + value.Id + '">' + value.Rating + '</span></td>' +
                    '<td commentdetail="Comment"    class="text-center align-middle"><span class="showDetails" id="commentReview_' + value.Id + '">' + value.ReviewComment + '</span></td>' +
                    '<td class="text-center align-middle">' + btnDelete + '</td>' +
                    '</tr>';
                $('#commentsTable').append(row);
            });
            toogleEdit();
        },
        error: function (data, status, error) {
            alert('Error listing users: ' + error);
        }
    });
}

function deleteComment(commentId) {
    var confirmation = confirm('This will DELETE the comment from the database. Was it THAT offensive?');
    if (confirmation) {
        $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: '/WebServices/UsersService.asmx/DeleteComment',
            data: '{commentId:' + commentId + '}',
            dataType: 'json',
            success: function () {
                $('#commentsTable tr#comment_' + commentId + ' td').hide(200);
            },
            error: function (status, error) {
                alert('Error deleting comment:' + status + " " + error);
            }
        });
    }
}

// ARRANQUE

$(function(){
    
listRoles();
listGenres();
listStudios();
listCountries();
});
