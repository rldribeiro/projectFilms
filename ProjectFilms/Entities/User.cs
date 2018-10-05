using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProjectFilms.Entities
{
	public class User
	{
		public int Id { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string Email { get; set; }
		public bool IsAdmin { get; set; }
		public bool State { get; set; }
		public string Password { get; set; }        
	}
}